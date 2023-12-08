--
-- Date: 2023-11-23
-- admin add urls

local Util = require('resty.util')

local PRE = 'g_'  -- all db save need prefix 
local ADMIN_TOKEN = 'admintesttoken'
local Say = Util.NgxSay 
local Red, err = Util.RedisConn('127.0.0.1',6379, nil) 
if err then Say(err) end 

-- check admin token 
function CheckToken()
    if ngx.time() > tonumber(ngx.var.cookie_time) - 10  and ngx.time() < tonumber(ngx.var.cookie_time) + 10 then 
        if ngx.var.cookie_token == ngx.md5(ADMIN_TOKEN..ngx.var.cookie_time) then 
        else 
            Say('status=err&err=token wrong ')
        end 
    else 
        Say('status=err&err=timestamp error&ngxtime='..ngx.time())
    end 
end 

-- set url by api 
function HSetUrls()
    ngx.req.read_body()
    local post_args = ngx.req.get_post_args()
    Red:init_pipeline(100) 
    local i = 0
    for k,v in pairs(post_args) do 
        Red:hset(PRE..'urls', k ,v )
        i = i + 1
    end 
    if i > 100 then 
        Say('status=err&err=args too many numis:'..tostring(i))
    end 
    local ok, err = Red:commit_pipeline()
    if not ok then 
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
