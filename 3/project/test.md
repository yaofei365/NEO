## 验收要求

1. 服务器启动, 等待客户端连接, 界面显示    
```
Listen on 0.0.0.0:6789
```

2. 服务器启动, 端口被占用, 界面显示    
```
error: Failed to bind port
请按任意键继续. . .
```

3. 客户端连接上服务器时, 界面显示客户端ip和端口    
```
Listen on 0.0.0.0:6789
New client from : 127.0.0.1:23950
```
4. 在客户端输入"hello world"并发送给服务器, 界面显示客户端输入的内容    
```
Listen on 0.0.0.0:6789
New client from : 127.0.0.1:23950
Recv from: client(127.0.0.1:23950) hello world
```
检查`mysql`数据库`sample`库中的 `sample` 表是否插入了数据    

|id|msg|  
|------|---|
|1|hello world|

客户端会收到服务器发送的 `success`
```
success
```

强制关闭客户端，界面有断开提示    
```
Listen on 0.0.0.0:6789
New client from : 127.0.0.1:23950
Recv from: client(127.0.0.1:23950) hello world
Disconnected: client(127.0.0.1:51107)
```

5. 同时开启多个客户端连接服务器，并检查 4 的操作步骤    
```
Listen on 0.0.0.0:6789
New client from : 127.0.0.1:23950
Recv from: client(127.0.0.1:23950) hello world
New client from : 127.0.0.1:51107
Recv from: client(127.0.0.1:51107) hello world
```

6. Mysql 服务器配置修改为 `无法连接的地址`, 服务器在接收到了客户端字符后，会有错误提示    
```
Listen on 0.0.0.0:6789
New client from : 127.0.0.1:51299
Recv from: client(127.0.0.1:51299) hello world
Error from: client(127.0.0.1:51299) Failed to connect mysql (192.
168.0.24:3306) - database(sample), msg(LuaSQL: Error connecting to database. MyS
QL: Can't connect to MySQL server on '192.168.0.24' (10060))
```

同时客户端也会收到相应的提示    
```
Failed to connect mysql (192.168.0.24:3306) - database(sample), m
sg(LuaSQL: Error connecting to database. MySQL: Can't connect to MySQL server on
 '192.168.0.24' (10060))
```

7. Mysql 服务器配置修改为 `错误的用户名密码`, 服务器在接收到了客户端字符后，会有错误提示    
```
Listen on 0.0.0.0:6789
New client from : 127.0.0.1:51932
Recv from: client(127.0.0.1:51932) hello world
Error from: client(127.0.0.1:51932) Failed to connect mysql (127.
0.0.1:3306) - database(sample), msg(LuaSQL: Error connecting to database. MySQL:
 Access denied for user 'root'@'localhost' (using password: YES))
 ```
同时客户端也会收到了相应的提示
```
Failed to connect mysql (127.
0.0.1:3306) - database(sample), msg(LuaSQL: Error connecting to database. MySQL:
 Access denied for user 'root'@'localhost' (using password: YES))
```

8. 配置文件中的 `database` 修改为错误的数据库名, 服务器在接收到了客户端字符后，会有错误提示   
```
Listen on 0.0.0.0:6789
New client from : 192.168.0.240:51870
Recv from: client(192.168.0.240:51870) hello world
Error from: client(192.168.0.240:51870) Failed to connect mysql (127.0.0.1:3306) - database(sample1), msg(LuaSQL: Error connecting to database. MySQL: Unknown database 'samplexxx')
```
同时客户端也会收到了相应的提示
```
Failed to connect mysql (127.0.0.1:3306) - database(sample1), msg(LuaSQL: Error connecting to database. MySQL: Unknown database 'samplexxx')
```

9. 将 `mysql` 数据库中的 `sample` 库中的 `sample` 表删除, 服务器在接收到了客户端字符后，会有错误提示    
```
Listen on 0.0.0.0:6789
New client from : 127.0.0.1:51490
Recv from: client(127.0.0.1:51490) hello world
Error from: client(192.168.0.240:51734) LuaSQL: Error executing query. MySQL: Table 'sample.sample' doesn't exist
```
同时客户端也会收到了相应的提示
```
LuaSQL: Error executing query. MySQL: Table 'sample.sample' doesn't exist
```

10. 执行以下 sql 脚本, 服务器在接收到了客户端字符后，会有错误提示    
```
drop table if exists `sample`;
create table `sample` (
  `id` bigint(20) unsigned not null auto_increment comment '自增id',
  primary key (`id`)
) engine=innodb default charset=utf8 collate=utf8_unicode_ci comment='测试';

```
```
Listen on 0.0.0.0:6789
New client from : 192.168.0.240:51734
Recv from: client(192.168.0.240:51734) hello world
Error from: client(192.168.0.240:51734) LuaSQL: Error executing q
uery. MySQL: Column count doesn't match value count at row 1

```
同时客户端也会收到了相应的提示
```
LuaSQL: Error executing query. MySQL: Column count doesn't match value count at row 1
```
