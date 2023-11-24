--
-- Date: 2023-11-23
-- url redirect

REDIS = require "resty.redis"   
REDIS_AUTH = 'ngxluaredis'
MEM = ngx.shared.limit  --lua shared dict 
PRE = 'g_'  -- all db save need prefix 
SITE = 'http://'..'getit.mac.cc'
INFO_URL = SITE..'/info#'
LOGIN_URL = SITE..'/in'

-- redirect url 
function Redirect(url,status)
    if status ~= 301 then status = 302
    end 
    if red then red:set_keepalive(10000, 10)  -- red
    end 
    ngx.redirect(url, status )
end 

-- ngx say and exit 
function Say(message)
    ngx.say(message)
    if red then red:set_keepalive(10000, 10)  -- red
    end 
    ngx.exit(200)
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

-- get user info 
function GetUserByDB(email) 
    local u = {}
    local uKey = PRE..'user_'..email
    u['email'] = red:hget(uKey, 'email')
    if not u['email'] then 
        return nil , 'user not exist '
    end 
    -- u['id'] = red:hget(uKey, 'id')
    -- u['name'] = red:hget(uKey, 'name')
    -- u['pwd'] = red:hget(uKey, 'pwd')
    u['coins'] = red:hget(uKey, 'coins')
    u['urlclicks'] = red:hget(uKey, 'urlclicks')
    u['ip'] = red:hget(uKey, 'ip')
    u['ipv6'] = red:hget(uKey, 'ipv6')
    u['devices'] = red:hget(uKey, 'devices')
    -- u['inviteby'] = red:hget(uKey, 'inviteby')
    -- u['invites'] = red:hget(uKey, 'invites')
    
    return u, nil
end

-- is token exist ?
function IsTokenExist()
    if ngx.var.cookie_token then 
        if MEM:get(PRE..'token_'..ngx.var.cookie_token) then 
            return true
        end 
    end 
    ngx.redirect(LOGIN_URL) --default 302
end 

-- click rate limit , 7 days 100 times then  7 times / 1day  limit 
function IsRateLimit() 
    local token = ngx.var.cookie_token
    local clicksDaily = MEM:get(PRE..'click_rate_daily_'..token)
    if clicksDaily then  -- rate 7clicks/day
        if clicksDaily > 9 then 
            local clicks = MEM:get(PRE..'click_rate_'..token)
            if clicks then  -- rate 100clicks/7days
                if clicks > 128 then 
                    ngx.redirect(INFO_URL..'限制7次每天,7天后解除,您点击太快了')
                end 
            else 
                MEM:set(PRE..'click_rate_'..token, 1, 604800)
            end 
        end 
    else 
        MEM:set(PRE..'click_rate_daily_'..token,0, 90000) -- 25hours
    end 
    MEM:incr(PRE..'click_rate_'..token, 1)
    MEM:incr(PRE..'click_rate_daily_'..token, 1)
    return false
end 
    
--- logic 

IsTokenExist()  -- is token?

IsRateLimit() -- click rates limit 

DBConn() -- db

-- is url exist?
local id = ngx.var.arg_id 
local url = red:hget(PRE..'urls',id)
if not url then 
    ngx.redirect(INFO_URL..'下载链接不存在')
end 

-- is user exist?
local token = ngx.var.cookie_token
local email = MEM:get(PRE..'token_'..token)
local user,err = GetUserByDB(email)
if not user then Redirect(LOGIN_URL)
end 

-- is coins used out ?
if user['urlclicks'] > user['coins'] then  -- coins used out 
    Redirect(INFO_URL..'金币已用-请充值或邀请返利')
end

-- is device used out?
if user['device'] > 128 then 
    Redirect(INFO_URL..'您更换设备-IP超过100次-账号已失效-请重新购买账号')
end

-- is new device ?
local ip = ngx.var.remote_addr	  -- devices used ?
if ip ~= user['ip'] and ip ~= user['ipv6'] then 
    if #ip > 15 then 
        red:hset(PRE..'user_'..email, 'ipv6', ip)
    else 
        red:hset(PRE..'user_'..email, 'ip', ip)
    end 
    local udevices = user['devices'] + 1
    red:hset(PRE..'user_'..email, 'devices', udevices)
    Redirect(INFO_URL..'您已使用新IP登录:'..ip..'__已更换:'..udevices..'次')
end 

-- url redirect and add user urlclicks 
local clicksNewCount = user['urlclicks'] + 1
ok,err = red:hset(PRE..'user_'..email, 'urlclicks', clicksNewCount)
if ok then 
    Redirect(url , 301) -- jump to real url 
else 
    Redirect(INFO_URL..'下载登记失败请联系管理员')
end 






