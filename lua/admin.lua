--
-- Date: 2023-11-23
-- admin add urls

local Util = require('g_util')

local PRE = 'g_'  -- all db save need prefix 
local ADMIN_TOKEN = 'admintesttoken'
local Say = Util.NgxSay 
local ok --, err 
local Red, err = Util.RedisConn('127.0.0.1',6379, nil) 
if err then Say(err) end 

-- check admin token 
function CheckToken()
    if ngx.time > tonumber(ngx.var.cookie_time) - 10  and ngx.time < tonumber(ngx.var.cookie_time) + 10 then 
        if ngx.var.cookie_token == ngx.md5(ADMIN_TOKEN..ngx.var.cookie_time) then 
        else 
            Say('status=err&err=token wrong ')
        end 
    else 
        Say('status=err&err=timestamp error')
    end 
end 

-- set url by api 
function HSetUrls()
    ngx.req.read_body()
    local post_args = ngx.req.get_post_args()
    Red:init_pipeline() 
    for k,v in pairs(post_args) do 
        Red:hset(PRE..'urls', k ,v )
    end 
    local ok, err = Red:commit_pipeline()
    if err then 
        Say('status=err&err=erris:'..err)
    else 
        Say('status=ok&ok=sucess')
    end 
end 

--- logic ---

if ngx.var.uri ~= "/admin/url" then Say('status=err&err=uri illegal ')
end 

CheckToken() --Token
HSetUrls()  --HSet 
