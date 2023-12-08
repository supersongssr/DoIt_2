--
-- Date: 2023-11-23
-- url redirect

local Util = require('resty.util')

-- Config
local MEM = ngx.shared.limit  --lua shared dict 
local PRE = 'g_'  -- all db save need prefix 
local SITE = 'https://'..'game.okxz.top'
local INFO_URL = SITE..'/info#'
local LOGIN_URL = SITE..'/in'
local Say = Util.NgxSay
local Redirect = Util.NgxRedirect
local GetUser = Util.RedisHgetToTable
local ok -- ,err 
local Red, err = Util.RedisConn('127.0.0.1',6379,nil)
if err then Say(err) end 

-- is token exist ?
local function IsTokenExist()
    if ngx.var.cookie_token then 
        if MEM:get(PRE..'token_'..ngx.var.cookie_token) then 
            return true
        end 
    end 
    ngx.redirect(LOGIN_URL) --default 302
end 

-- click rate limit , 7 days 100 times then  7 times / 1day  limit 
local function IsRateLimit() 
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

--- logic ---

IsTokenExist()  -- is token?

IsRateLimit() -- click rates limit 

-- is url exist?
local url,err = Red:hget(PRE..'urls',ngx.var.arg_id)
if nil == url or ngx.null == url then ngx.redirect(INFO_URL..'下载链接不存在') end 

-- is user exist?
local email = MEM:get(PRE..'token_'..ngx.var.cookie_token)
local userItems = {'email','urlclicks','coins','devices','ip','ipv6'}
local user,err = GetUser(Red, PRE..'user_'..email, userItems)
if err then Redirect(INFO_URL..err) 
elseif not user['email'] then Redirect(LOGIN_URL)
end 

-- is coins used out ?
if tonumber(user['urlclicks']) > tonumber(user['coins']) then  -- coins used out 
    Redirect(INFO_URL..'金币已用完-请充值或邀请返利')
end

-- is device used out?
if tonumber(user['devices']) > 128 then 
    Redirect(INFO_URL..'您更换设备-IP 超过100次-账号已失效-请重新购买账号')
end

-- is new device ?
local ip = ngx.var.remote_addr	  -- devices used ?
if ip ~= user['ip'] and ip ~= user['ipv6'] then 
    if #ip > 15 then 
        Red:hset(PRE..'user_'..email, 'ipv6', ip)
    else 
        Red:hset(PRE..'user_'..email, 'ip', ip)
    end 
    local udevices = user['devices'] + 1
    local ok ,err = Red:hset(PRE..'user_'..email, 'devices', udevices)
    if err then Redirect(INFO_URL..err)
    Redirect(INFO_URL..'您已使用新IP登录:'..ip..'__已更换:'..udevices..'次')
    end
end 

-- url redirect and add user urlclicks 
local clicksNewCount = user['urlclicks'] + 1
local _,err = Red:hset(PRE..'user_'..email, 'urlclicks', clicksNewCount)
if err then Redirect(INFO_URL..err)
else 
    Redirect(url , 301) -- jump to real url 
end 






