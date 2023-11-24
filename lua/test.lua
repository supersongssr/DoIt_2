--
-- Date: 2023-11-23
-- user login & register 

REDIS = require "resty.redis"   
REDIS_AUTH = 'ngxluaredis'
MEM = ngx.shared.limit  --lua shared dict 
PRE = 'g_'  -- all db save need prefix 
SITE = 'http://'..'getit.mac.cc'

-- test redis 


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

--- logic 
DBConn()

-- hset 
ok ,err = red:hset('gaga','email','111@gaag.cc')

if not ok then Say(err )
else Say('ok')
end 