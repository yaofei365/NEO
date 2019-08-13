做一个 DEMO, 实现以下功能    
(1) 下载 [project.rar](https://github.com/kinbei/NEO/blob/master/3/project.rar)
(2) 使用 `luasocket` 和 `luasql` 两个组件    
(3) 实现 `client.lua` 和 `server.lua` 两个文件并放到 `project` 目录下, 双击 `server.bat` 和 `client.bat` 检查运行结果     
(4) 具体验收要求详见 https://github.com/kinbei/NEO/blob/master/3/project/test.md    
(5) 在 `客户端` 输入字符串 `hello world`, 发送到服务器, 服务器连接 `Mysql` 并向表中插入记录, 如果执行成功，返回 "success" 给客户端; 如果执行失败，则返回错误信息给客户端       
(6) `mysql`数据库库表定义见 `project/sql.sql`      
(7) 不需要在代码中执行建表语句, 运行服务器前，执行过 `project/sql.sql` 即可正常运行      
(8) `mysql`相关配置，服务器监听地址和端口统一在配置文件 `server.config` 配置, 具体字段详见下方    

## 配置文件

### 服务端配置文件 `server.config`    
```lua
host = 127.0.0.1
port = 3306
user = root
password = 123456
database = sample
server_ip = 0.0.0.0
server_port = 6789
```

#### 客户端配置文件 `client.config`    
```lua
server_ip = 127.0.0.1
server_port = 6789
```

