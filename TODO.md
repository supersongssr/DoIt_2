# todo 


## Test 
- [x] PI  /www/site/index/

## tood list 
- [x] 功能: 首页 多栏显示功能
    - [x] index add summary-card
    - [x] edit summary
    - [x] homepage 和 page 宽度不能一样
        - use index instead of page 
    - [x] 是否要将首页的显示做成一个 config 模块呢? 需要设置才能使用? 兼容原版的项目?
    - [x] 修改页面显示
    - [x] 修改scss

- [x] 增加 fuse list title 精简 fuse 功能
    - fuse搜索添加 简单 fuse版本,直接生成 list的索引的方式,降低 index.json的大小.提高fuse的速度
    - [x] slug title 和 url匹配的方案
        - hugo端 slug -> url 
            - [] slug转小写
            - [] url转义
        - title -> slug 
            - [x] 去除不能作为文件名的字符串
            - [] 大小不转小写
            - [x] 去除一切非法字符仅保留 _ 和 英文中文数字
            - [x] 去除空格

- [] api页面,用于和 后台交互的页面
    - [] info
    - [] login page
    - [] vip page