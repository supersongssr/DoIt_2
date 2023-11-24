--
-- Date: 2023-11-23
-- user login & register 

REDIS = require "resty.redis"   
REDIS_AUTH = 'ngxluaredis'
MEM = ngx.shared.limit  --lua shared dict 
PRE = 'g_'  -- all db save need prefix 
SITE = 'http://'..'getit.mac.cc'


-- get user info 
function GetUserByDB(email) 
    local u = {}
    local uKey = PRE..'user_'..email
    u['email'],err = red:hget(uKey, 'email')
    if nil == u['email'] then 
        return nil ,'erdis error'
    elseif ngx.null == u['email'] then 
        return nil , 'user not exist '
    end 
    u['id'] = red:hget(uKey, 'id')
    u['name'] = red:hget(uKey, 'name')
    u['pwd'] = red:hget(uKey, 'pwd')
    u['coins'] = red:hget(uKey, 'coins')
    u['urlclicks'] = red:hget(uKey, 'urlclicks')
    u['ip'] = red:hget(uKey, 'ip')
    u['ipv6'] = red:hget(uKey, 'ipv6')
    u['devices'] = red:hget(uKey, 'devices')
    u['inviteby'] = red:hget(uKey, 'inviteby')
    u['invites'] = red:hget(uKey, 'invites')
    
    return u, nil
end

-- user login
function Login() 
    ngx.req.read_body()
    local args,err = ngx.req.get_post_args()
    if not args then Say('err,请求参数不存在'..err)
    end 
    if args['email'] and args['pwd'] then  -- check info
    else Say("err,请输入邮箱和密码")
    end 

    local user ,err = GetUserByDB(args['email'])
    if user then 
        if user['pwd'] == args['pwd'] then 
            local user = {}
            local token = ngx.md5(user['name']..user['pwd'])
            MEM:set(PRE..'token_'..token, user['email'])  -- shared dict 
            local cookieExpires = ngx.time() + 86400000
            ngx.header['Set-Cookie'] = 'token='..token..';path=/;Max-Age=8640000'..';Expires='..ngx.cookie_time(cookieExpires)
            Say('ok,loginsuccess')
        else 
            Say('err,密码错误')
        end 
    else 
        Say('err,用户不存在')
    end 

    -- 记录不同的ip登录? 这个可以有么?还是说,只在那个jump那里去记录呢?
    -- 不同的地方登录多少次都没问题,但是跳转不行?
end 

-- invite and pay 
function Invite() 
    ngx.req.read_body()
    local args = ngx.req.get_posts_args 
    if not args then 
        return nil ,'args not exist'
    end 
    local email ,err = red:sget(PRE..'invite_codes_index',args['inviteby'] )
    if ngx.null ~= email and nil ~= email  then
        local user,err  = GetUserByDB(email) --get invietby user 
        if user then 
            local uKey = PRE..'user_'..email  -- add coins
            red:init_pipeline()
            local newCoins = user['coins'] + 500
            local newInvites = user['invites'] +1 
            red:hset(uKey,'coins', newCoins)
            red:hset(uKey,'invites',newInvites)
            ok, err = red:commit_pipeline()
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
function Register()
    ngx.req.read_body()
    local args,err = ngx.req.get_post_args()
    if not args then  Say('err,请求参数报错'..err)
    end 
    if args['email'] and args['name'] and args['pwd'] then 
    else Say('err,请输入 账号 密码 邮箱')
    end 

    if #args['pwd'] < 6 then Say('err,密码至少6位')
    end 

    local ip = ngx.var.remote_addr
    if MEM:get(PRE..'reg_ip_'..ip) then  -- ip limits 
        Say('err,该IP重复注册')
    end
    
    local user = GetUserByDB(args['email'])
    if user then Say('err,该邮箱已被注册')
    end 

    local uKey = PRE..'user_'..args['email']
    red:incr(PRE..'all_users_count')
    local userID = red:get(PRE..'all_users_count')
    if userId == ngx.null then Say('err,无法获取用户id')
    end 
    red:init_pipeline()  -- start reg 
    red:hset(uKey, 'id', userID)  -- pre_user_email hash 
    red:hset(uKey, 'name', args['name'])
    red:hset(uKey, 'email', args['email'])
    red:hset(uKey, 'pwd', args['pwd'])
    red:hset(uKey, 'coins', 100)
    red:hset(uKey, 'urlclicks',0)
    red:hset(uKey, 'devices', 0)
    red:hset(uKey, 'invites', 0)
    if args['inviteby'] then red:hset(uKey, 'inviteby', args['inviteby'])
    end 
    ok, err = red:commit_pipeline()
    if ok then 
        local token = ngx.md5(args['name']..args['pwd'])
        MEM:set(PRE..'token_'..token,args['email'])  -- shared dict 
        local cookieExpires = ngx.time() + 86400000
        ngx.header['Set-Cookie'] = 'token='..token..';path=/;Max-Age=8640000'..';Expires='..ngx.cookie_time(cookieExpires)
        ngx.print('ok,注册成功_')
    else 
        Say('err,注册失败请联系管理员')
    end 

    ok, err = red:sadd(PRE..'users_index', args['email'])  -- pre_users_index
    if not ok then ngx.print('_写入用户index失败_'..err)
    end 
    ok, err = red:hset(PRE..'invite_codes_index', userID, args['email']) --pre_invite_codes_index
    if not ok then ngx.print('_写入邀请index失败_'..err)
    end 

    MEM:set(PRE..'reg_ip_'..ip,1,604800)  --7days iplimit

    if args['inviteby'] then Invite() -- invite
    end 

    Say('_注册完成_')
end 

-- db connect to redis 
function DBConn()
    red = REDIS:new() -- redis start 
    red:set_timeouts(1000,1000,1000) -- 1sec

    ok ,err = red:connect("127.0.0.1", 6379)
    if not ok then Say('err,faild connetct to db :', err)
    end 

    ok, err = red:auth(REDIS_AUTH)
    if not ok then Say('err,faild login to db :',err)
    end 

    return true 
end 

-- ngx say and exit 
function Say(message)
    ngx.say(message)
    if red then red:set_keepalive(10000, 10)  -- red
    end 
    ngx.exit(200)
end 

-- get user info 
function UserInfo()
    if ngx.var.cookie_token then 
        local email = MEM:get(PRE..'token_'..ngx.var.cookie_token)
        if email then 
            local u = GetUserByDB(email) -- u:user
            if u then 
                Say('ok,'..u['id']..','..u['name']..','..u['email']..','..u['coins']..','..u['urlclicks']..','..u['devices']..','..u['invites'])
            else 
                Say('err,用户不存在')
            end 
        else 
            Say('err,token错误')
        end 
    else 
        Say('err,还没登录')
    end 
end 

---- logic

if DBConn() then --db
end 

if ngx.var.uri == "/user/info" then UserInfo() --get user info 
elseif ngx.var.uri == "/user/login" then Login() --login
elseif ngx.var.uri == "/user/register" then Register() --register
else Say("err,非法请求地址")
end 
