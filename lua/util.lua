--
-- 和业务逻辑没有关系的 工具包

local Redis = require 'resty.redis'

local _M = {
    version = '0.1',
    updateat = '2023-11-27',
}

-- db connect to redis 
function _M.RedisConn(address, port , auth) 
    local red = Redis:new() -- redis start 
    red:set_timeouts(1000,1000,1000) -- 1sec

    local ok ,err = red:connect(address, port)
    if not ok then 
        return nil , 'status=err&err=faild connetct to db :'..err
    end 

    if nil ~= auth then 
        ok, err = red:auth(auth)
        if not ok then 
            return nil , 'status=err&err=faild login to db :'..err
        end
    end 

    return red ,  nil
end 

-- ngx say and exit 
function _M.NgxSay(message, exitCode)
    ngx.say(message)
    if not exitCode then exitCode = 200 
    end 
    ngx.exit(exitCode)
end 

-- redirect url 
function _M.NgxRedirect(url,status)
    if nil == status then status = 302
    end 
    ngx.redirect(url, status )
end 

-- redis hget hash to table 
function _M.RedisHgetToTable(redis , key, items) 
    local u = {}
    if nil == items then 
        return nil , 'items not exist'
    end 
    for i,t in pairs(items) do 
        local ok,err = redis:hget(key, t)
        if err then 
            return nil , 'hget err'..err
        end 
        if ngx.null == ok then 
            u[t] = nil 
        else 
            u[t] = ok
        end 
    end 
    
    return u, nil
end

return _M