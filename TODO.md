# todo 


## Test 
- [x] PI  /www/site/index/

hugo server --bind 0.0.0.0 

## tood list 
- [x] 功能: 首页 多栏显示功能
    - [x] index add summary-card
    - [x] edit summary
    - [x] homepage 和 page 宽度不能一样
        - use index instead of page 
    - [x] 是否要将首页的显示做成一个 config 模块呢? 需要设置才能使用? 兼容原版的项目?
    - [x] 修改页面显示
    - [x] 修改scss



- [x] fuse.js 增加 airMode 和 miniMode
    - [x] meilisearch
        - [x] 如果有服务器可以考虑 meilisearch
        - 不如 page find 
    - [x] pagefind, agolia 模式
        - pagefind如何运作
            - 网站构建后, 运行pagefind, 生成索引放到public文件夹. 
            - rust写的, 可以索引全文,速度非常快.
            - 有专门的一个搜索页面. 
            - 可以大型,且全文搜索,很厉害
        - agolia如何运作
            - 远程调用.
    - [x] fuse.js json搜索引擎
        - [x] 默认模式  uri , title , content , date
        - [x] airMode  uri, title , date 
            - [x] 轻量, 不索引 content, 把content变为别的东西. 现在还没想要变成啥,先取消掉; 变成uri
            - [x] miniMode  only title ; string array mode 
            - [x] index.json , 变成 string array 模式. 进一步精简
                - slug 即 url! 模式 



- [] api页面,用于和 后台交互的页面
    - [] info
    - [] login page
    - [] vip page