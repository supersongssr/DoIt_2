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
- [x] try to see how meili search work
- [x] built website with doit v0.4
    - [x] install nginx on macos ? ?
        - [x] raspberry is better ? Yes , it's better . 
        - [x] but nginx ?? on macos, better to 
        - [x] or install caddy2 ?
            - [x] yeap ,instal caddy2 on macos ,is better! 
    - [x] move git folder to raspberry pi . 
    - [x] move hugo folder to raspberry pi folder 

- [x] homepage auto adapts to screens 
    - [x] copy from getit old version .
    - [x] try use hugo , caddy2 
    - [x] change the first page url 
    - [x] try edit the hoem page , and adjust it 

- [x] edit home page , adjust 
    - [x] card summary 
    - [x] img size
    - [x] screen size 

- [x] try edit fuse , and index.json creat 
    - [x] try use list 

- [x] hugo filename ? how ? chinese words

- [x] use less control the login page 

- [x] edit about page to a new 
    - [x] how about page creat ?
        - [x] If need content , add the content 
        - [x] need the content 
- [x] add pages : 
    - [x] user/  need md 
        - [x] use type ? cools , page ?  Or anything else ?
        - [x] add html 
        - [x] add css 
    - [x] login/ no md 
        - [x] add html 
        - [x] add scss 

- [x] add a info page 

- [x] BUG: the first click search bug ,the print not on the search arear.

- [x] nginx lua redis , 
    - [x] how import redis ?
    - [x] use which redis component
        - [x] lua resty redis 


- [] db:  with site pre .   site = 'g_'
    - user_info  hash  many ; user info hash 
        - user name 
        - user email 
        - user password 
        - user coin money  1$=100coin 
        - user ip 
        - user ipv6 
        - user token : md5(username_password)
        - invite by 
        - divices count 
        - url redirect count 
        - invite users count 
        - invite code ; number ; user id 
    - user_info_index  set 
    - url_info hash  one 
    - invite_code  hash  one  
    - invite_list set many  ; user invite user list 
    - total user count : string number , incresment



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
