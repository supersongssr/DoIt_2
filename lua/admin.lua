--
-- Date: 2023-11-23
-- admin add urls

REDIS = require "resty.redis"   
MEM = ngx.shared.limit  --lua shared dict 
PRE = 'g_'  -- all db save need prefix 
SITE = 'http://'..'getit.mac.cc'
ADMIN_TOKEN = 'admintesttoken'
REDIS_AUTH = 'ngxluaredis'

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

-- check admin token 
function CheckToken()
    local args = ngx.req.get_post_args
    if args['token'] != ADMIN_TOKEN then 
        Say('err,token wrong ')
    end 
    if not args['urls'] then 
        Say('err,urls missing ')
    end 
end 

-- set url by api 
function HSetUrls()
    local args = ngx.req.get_post_args
    local uKey = PRE..'urls'
    red:init_pipeline() 
    for k , v in pairs(args['urls']) do 
        red:hset(uKey, k ,v )
    end 
    ok, err = red:commit_pipeline()
    if ok then 
        Say('ok,sucess')
    else 
        Say('err,erris:'..err)
    end 
end 

--- logic 

if ngx.var.uri != "/admin/url" then Say('err,uri illegal ')
end 

CheckToken()

DBConn()

HSetUrls()
-- 链接 db
-- 验证密钥, 是否是关键的key , post获取
-- 逐个更新吗? 还是多个一起更新? 我觉得可以多个一起更新.

