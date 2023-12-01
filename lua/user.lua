--
-- Date: 2023-11-23
-- user login & register 

local Util = require('g_util')

local MEM = ngx.shared.limit  --lua shared dict 
local PRE = 'g_'  -- all db save need prefix 
-- local SITE = 'http://'..'getit.mac.cc'
local Say = Util.NgxSay
local GetUser = Util.RedisHgetToTable
local ok -- , err 
-- local UserItems = {'id','name','email','pwd','coins','urlclicks','devices','invites','inviteby','ip','ipv6'}

local Red, err  = Util.RedisConn('127.0.0.1', 6379 , nil) --db : ip , port , password
if err then Say(err) end 

-- user login
local function Login() 
    ngx.req.read_body()
    local args,err = ngx.req.get_post_args()
    if not args then Say('status=err&err=请求参数不存在'..err) end 
    if args['email'] and args['pwd'] then  -- check info
    else Say("status=err&err=请输入邮箱和密码")
    end 
    local userItems = {'name','email','pwd'}
    local user ,err = GetUser(Red , PRE..'user_'..args['email'],userItems)
    if err then Say(err) end 
    if user['email'] then 
        if user['pwd'] == args['pwd'] then 
            local token = ngx.md5(user['name']..user['pwd'])
            MEM:set(PRE..'token_'..token, user['email'])  -- shared dict 
            local cookieExpires = ngx.time() + 86400000
            ngx.header['Set-Cookie'] = 'token='..token..';path=/;Max-Age=8640000'..';Expires='..ngx.cookie_time(cookieExpires)
            Say('status=ok&ok=loginsuccess')
        else 
            Say('status=err&err=密码错误')
        end 
    else 
        Say('status=err,&err=用户不存在')
    end 
end 

-- invite and pay 
local function Invite() 
    ngx.req.read_body()
    local args = ngx.req.get_posts_args 
    if not args then 
        return nil ,'args not exist'
    end 
    local email ,err = Red:sget(PRE..'invite_codes_index',args['inviteby'] )
    if ngx.null ~= email and nil ~= email  then
        local userItems = {'id','name','email','pwd','coins','urlclicks','devices','invites','inviteby','ip','ipv6'}
        local user,err  = GetUser(Red, PRE..'user_'..email, userItems) --get invietby user 
        if err then Say(err) end 
        if user['email'] then 
            local uKey = PRE..'user_'..email  -- add coins
            Red:init_pipeline()
            local newCoins = user['coins'] + 500
            local newInvites = user['invites'] +1 
            Red:hset(uKey,'coins', newCoins)
            Red:hset(uKey,'invites',newInvites)
            ok, err = Red:commit_pipeline()
            if ok then 
                ngx.print('_返利成功_')
                return 'sucess' ,nil 
            else 
                ngx.print('_返利失败_')
                return nil , 'coins add faild'
            end
        else 
            ngx.print('_邀请人不存在_')
            return nil , 'user not exist'
        end 
    else
         ngx.print('_无法获取邀请人信息_')
         return nil , 'can not get the email '
    end 
end 

-- register user , and invite , and add the coin 
local function Register()
    ngx.req.read_body()
    local args,err = ngx.req.get_post_args()
    if not args then  Say('status=err&err=请求参数报错'..err)
    end 
    if args['email'] and args['name'] and args['pwd'] then 
    else Say('status=err&err=请输入 账号 密码 邮箱')
    end 

    if #args['pwd'] < 6 then Say('status=err&err=密码至少6位')
    end 

    local ip = ngx.var.remote_addr
    if MEM:get(PRE..'reg_ip_'..ip) then  -- ip limits 
        Say('status=err&err=该IP重复注册')
    end
    local userItems = {'email'}
    local user ,err= GetUser(Red , PRE..'user_'..args['email'],userItems)
    if err then Say(err) end 
    if user['email'] then Say('status=err&err=该邮箱已被注册') end 

    local uKey = PRE..'user_'..args['email']
    Red:incr(PRE..'all_users_count')
    local userID = Red:get(PRE..'all_users_count')
    if userId == ngx.null then 
        Say('status=err&err=无法获取用户id') 
    end 
    Red:init_pipeline()  -- start reg 
    Red:hset(uKey, 'id', userID)  -- pre_user_email hash 
    Red:hset(uKey, 'name', args['name'])
    Red:hset(uKey, 'email', args['email'])
    Red:hset(uKey, 'pwd', args['pwd'])
    Red:hset(uKey, 'coins', 100)
    Red:hset(uKey, 'urlclicks',0)
    Red:hset(uKey, 'devices', 0)
    Red:hset(uKey, 'invites', 0)
    if args['inviteby'] then Red:hset(uKey, 'inviteby', args['inviteby'])
    end 
    ok, err = Red:commit_pipeline()
    if ok then 
        ngx.print('status=ok&ok=注册成功_')
    else 
        Say('status=err&err=注册失败请联系管理员')
    end 

    ok, err = Red:sadd(PRE..'users_index', args['email'])  -- pre_users_index
    if err then ngx.print('_写入用户index失败_'..err) end 
    ok, err = Red:hset(PRE..'invite_codes_index', userID, args['email']) --pre_invite_codes_index
    if err then ngx.print('_写入邀请index失败_'..err) end 

    MEM:set(PRE..'reg_ip_'..ip,1,604800)  --7days iplimit

    if args['inviteby'] then Invite() -- invite
    end 

    Say('_注册完成_')
end 

-- get user info 
local function UserInfo()
    if ngx.var.cookie_token then 
        local email = MEM:get(PRE..'token_'..ngx.var.cookie_token)
        if email then 
            local userItems = {'id','name','email','coins','urlclicks','devices','invites',}
            local u,err  = GetUser(Red, PRE..'user_'..email,userItems) -- u:user
            if err then Say('rediserr:'..err) end 
            if u['email'] then 
                u['status'] = 'ok'
                Say(ngx.encode_args(u))
            else 
                Say('status=err&err=用户不存在')
            end 
        else 
            Say('status=err&err=token错误')
        end 
    else 
        Say('status=err&err=还没登录')
    end 
end 

--- logic ---


if ngx.var.uri == "/user/info" then UserInfo() --get user info 
elseif ngx.var.uri == "/user/login" then Login() --login
elseif ngx.var.uri == "/user/register" then Register() --register
else Say("status=err&err=非法请求地址")
end 
