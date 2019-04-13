做一个 DEMO, 实现以下功能    
(1) 使用 `luasocket` 和 `luasql` 两个组件    
(2) 实现 `客户端` `client.lua` 和 `服务器端` `server.lua`         
(3) 在 `客户端` 输入字符串 `hello world`, 发送到服务器, 服务器连接 `Mysql` 并向表中插入记录, 如果执行成功，返回 "success" 给客户端; 如果执行失败，则返回错误信息给客户端    
(4) `mysql`数据库库表定义见 `project/sql.sql`    
(5) 不需要在代码中执行建表语句, 运行服务器前，执行过 `project/sql.sql` 即可正常运行      
(6) `mysql`相关配置，服务器监听地址和端口统一在配置文件 `server.config` 配置, 具体字段详见下方    
(7) 验收要求详见 https://github.com/kinbei/NEO-private/blob/master/demo/project/test.md    

## 配置文件

服务端配置文件 `server.config`    
```lua
host = 192.168.0.240
port = 3360
user = root
password = 123456
database = sample
listen_port = 6789
```

客户端配置文件 `client.config`    
```lua
ip = 192.168.0.240
port = 6789
```

