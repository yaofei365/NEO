1. 分别在 gateway 和 dbmgr 进程新增两条协议 `gw_player_create` 和 `db_player_create`     
2. `gw_player_create` 和 `db_player_create` 协议的字段如下    
```
request:
	sex, number
	nickname, string

response:
	retcode, number
	player_id, number
```
3. 执行 `run_all.bat`, 再执行 `test.bat`    
4. `test` 会发送 `gw_player_create` 到 `gateway` 进程, `gw_player_create` 在收到协议后, 发送 `db_player_create` 到 dbmgr, dbmgr 向 mysql 插入数据      
5. `test` 返回并打印 `player_id`    

注:
1. 数据库初始化 sql 在 `deploy\server\bat\create_struct.sql`
