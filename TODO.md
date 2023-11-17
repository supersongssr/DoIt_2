a todo list 
====

copy from hugo do it version v0.4.0 

# other file 参考
MarkDown/2023-01-07_golang_learn_note.md
MarkDown/2022-09-20_lua将user表和jump表分开.md
MarkDown/2023-02-10_HUGO_静态网站_cookies_共享.md
https://www.fusejs.io/examples.html#search-string-array


# todo list steps
- [x] 找一找之前自己做的东西, 里面有没有记录自己怎么搞这个 主题的
- [x] 自己改的所有的东西,都记下来
- [x] make a getit.cc website 
    - [x] install hugo on macbook 
        - [x] try brew install method 
            - try : brew install hugo-extended  
                - [x] 没找到 hugo-extended
            - [x] try :brew install hugo 
                - hugo v0.120.4-f11bca5fec2ebb3a02727fb2a5cfb08da96fd9df+extended
                - 似乎包含了 extended
        - [x] install the 直接安装满足你操作系统 (Windows, Linux, macOS) 的最新版本  Hugo (> 0.83.0). 
        - [x] hugo version must > 0.83.0 
        - [x] 由于这个主题的一些特性需要将  SCSS 转换为  CSS, 推荐使用 Hugo extended 版本来获得更好的使用体验. 
        - [x] hugo version better is : hugo extended
    - [x] try make some md file
        - [x] export from game.cc?
        - [x] try upload some img file to imgcdn.cc ; ok 
- [x] how hugo know which theme used ?
    - [x] how? use the hugo.toml 
- [x] clear game.cc website 
    - [x] reclone github getit theme 
- [x] 获取 github 里面 doit的最新的 release版. 
    - [x] 在此版本的基础上, 自建一hugo个分支: getit
    - [x] 首页弄成 多样式的那种, 研究一下是怎么做到的.
- [x] try update raspberry pi hugo version to 120 
    - move hugo /usr/bin/hugo

- [x] make a website with at last 12 posts md file 
    - [x] export the md file from game.cc ,cool !
    - [x] then make the website . 
    - [x] then edit the theme 

- [x] the hugo_getit , check the different codes 
    - [x] make a new copy 
    - [x] upload a new load 
    - [x] i remember i used the last version . 
    - [x] I find it : Add suport giscus comment system  
    - [x] between : Commits on Nov 4, 2021   -   Commits on Nov 6, 2021
    - [x] find it :
        - chore: add 0.2.13 changelog     Nov 6, 2021   ## [0.2.13] - 2021-11-06
- [x] check the different with doit getit 
- [] try to see how meili search work
- [] built website with doit v0.4
    - [] install nginx on macos ? ?
        - [] raspberry is better ? Yes , it's better . 
        - [] but nginx ?? on macos, better to 
        - [] or install caddy2 ?
            - [] yeap ,instal caddy2 on macos ,is better! 
    - [] move git folder to raspberry pi . 
    - [] move hugo folder to raspberry pi folder 

- [] ngx lua can get the post query 
    - [] let login page use : post query , but : ? a.b.c j.b.c???
    - [] ohno only get method! 

- [] the lua file ,try use a file 
    - [] mybye try use load file? 


- [] the jump url ,try use the num id , not the md5!
    - [] if use num, will be easy to find .

- [] try understand the hugo themes reasons 

- [] add the home page cards spacing . make it wider .

- [] learn the theme 
    - first : alyouts : index.html ,  add a  summary-card , 
    - assets css _page _home.scss , add a  summary-card , css 
    - then the _media.scss 


- [] why I remake a getit theme ?
    - [] Need make the steps , how I make it possible 

- [] hugo theme doit theme , edit
	- [] get github hugo getit 


- [] make a copy to raspiberry pi , try use the live mode 

- [] home page UI adaptive size 
    - [] refer to  love it theme 


- [] fuse.js use [] list to search 
    - [] the search , only  title . is OK  save the json file size .

- [] lua login and user page :
    - [] login : use &user&pwd=
    - [] user: user json 

- [] in future , consider meilisearch !
    - [] the fast and powerful search ! 

- [] lua实现模糊查询
    - [] ngx.re.find , 然后把标题,时间,url 放到一个文件中去,逐行对比

- [] redis 实现查询: 
    - 插件 redisearch 

- [] 评论程序,用 golang作为后端的 artalk

- [] /login /user页面设计
    - XMLHttpRequest 可以实现 get post请求
    - [] 默认/user页面
    - [] /user页面用 string or json, 获取 ok,username,i,i,i 
        - [] 判断不是ok, 就跳转到登录页面
    - [] /login 页面 显示购买 和 购买账号按钮
        - [] login 用 get到方式传递账号密码即可. 
        - [] 第一次登录用 User文件逐行对比. 
            - [] 登录成功后,写入 内存字典

- [] 开源搜索引擎:  meilisearch  zincsearch redisearch

- [] WP MD
    - [] WP for invite, 9.9/y
    - [] MD for seal, 9.9/forerer
        - [] 未来, 使用redis注册,邀请
            - [] 一个url链接跳转 1分钱. 注册送1元, 签到送1元, 邀请送5元? 是否可行?

- [] 当前评论可以考虑用 algolia, 多个站点,多注册几个账号就好了.
    - [] 多注册几个账号,就好了.