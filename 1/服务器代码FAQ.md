#### 1. 如何找到某个结构的赋值代码?     
a) 服务器的所有[结构]在 `deploy\common\netimpl\common\` 这个文件夹必须有对应的定义 及 每个字段的注释    
b) 少数内部使用的[结构]不会在 `deploy\common\netimpl\common\` 定义, 但必定是在一个 Lua 文件内, 如果是跨多个 Lua 文件的, 必定会在 `deploy\common\netimpl\common\` 有定义(即使协议没有使用到)     
c) 赋值操作的惯用写法是:     
```
local create_yyy = require("netimpl.common.yyy").create_response -- 此句代码通常写在 Lua 文件头部

local xxx = create_yyy() -- yyy 为结构名
xxx.zzz = aaa
```
d) 综上所述, 只需要全局查找所有 create_yyy() 就可以找到所有赋值的相关代码     

#### 2. 如何找到发送某条协议的所有代码?     
a) 服务器发送协议必定是通过 `daserver.syncCall` 或 `daserver.call` 发送的     
b) a). 提及的两个接口都必须传递 servant_name 这个参数     
c) 综上所述, 只需要全局搜索 servant_name 就可以     
d) server_name 在代码中的惯用写法是 NETDEFINE.XXXXX (具体可参考 netdefine.lua 文件中的定义, 每条协议必定对应一个 servant_name)     

#### 3. 服务器各个进程的作用分别是什么？    
各个不同的进程分别负责管理不同的数据, 主要的进程及它们各自管理的数据, 如下所述        
a) `LoginMgr` 玩家连接服务器时, 第一个连接的进程, 主要负责`角色创建`，`分配 gateway进程`    
b) `Gateway` 玩家选择角色后, 连接的第二个进程, 主要管理`玩家的私有数据`(即不需要通知其它玩家的数据, eg. 玩家的成就, 任务 ...)    
c) `Cellapp` 场景管理, 管理所有场景内相关的数据, eg. 玩家的外观, 战斗 ...    
d) `Globalmgr` 单服公共数据, eg. 帮派    
e) `dbmgr` 主要负责数据的读取 及 写入    

#### 4. 服务器代码用到了哪些 Lua 特性?    
a) 服务器业务逻辑只有少部份代码(Cellapp)使用了`metatable`, 实现一些类似“函数重载”(函数替换)的功能；至于协程，服务器业务代码是禁止使用的。    
b) `metatable` 的使用例子如下
```
local avatar = {}

function avatar.print()
	log_info("this is avatar")
end

local monster = setmetatable({}, {__index = avatar})

function monster.print()
	log_info("this is monster")
end
```

#### 5. 用 table 在各个函数与协议间传递, 不会很混乱么?    
不会, 因为    
a) 服务器的所有[结构]在 `deploy\common\netimpl\common\` 这个文件夹必须有对应的定义 及 每个字段的注释    
b) 少数内部使用的[结构]不会在 `deploy\common\netimpl\common\` 定义, 但必定是在一个 Lua 文件内, 如果是跨多个 Lua 文件的, 必定会在 `deploy\common\netimpl\common\` 有定义(即使协议没有使用到)    

#### 6. 服务器是如何触发业务逻辑的?    
a) 由客户端发起协议触发, 通常是 `GW_` 开头的协议    
b) 由服务器的定时器触发, 通常在进程目录下 `main` 文件通过调用 `addTimeTask` 添加定时器    

#### 7. 数据库的数据实时写入`mysql`么?
不是，默认配置下，每 10 秒同步一次数据库至 `mysql`    

#### 8. 如何查找 `mysql` 某个表修改的所有代码?    
修改`mysql`的表，在 Lua 必须通过 `daodb.表名()` 进行操作, 而目前只有`dbmgr`和`centermgr`两个进程可以操作数据库, 所以在`dbmgr`或`centermgr`目录下查找`daodb.表名()`    
eg. `daodb.tb_user()`

#### 9. 如何对`mysql`某个表进行增删改查操作?    
详见: https://github.com/yaofei365/NEO/blob/master/1/4.服务器库表结构.md    

#### 10. 策划配置表如何读取，使用?    
在服务器代码中，对配置表的统一命名是：`tb_table_xxx` (其中`xxx`为策划配置的`excel`表名)    
读取策划配置表时, 如下所示(例子以读取`meridians`配置表为例):
```
local load_table = require("load_table")
local tb_table_meridians = load_table("tb_table_meridians")
```
上述两句代码通常写在 Lua 文件头部, `load_table()` 返回的值是一个`table`    
查找哪些代码使用了某个配置表，可以全文搜索`tb_table_xxx`(其中`xxx`为策划配置的`excel`表名)    

#### 11. 服务器间如何通讯?    
a) 在大多数情况下，用`daserver.syncCall()`和`daserver.call()`就可以; 其中`syncCall`表示"同步"调用，必须得对端返回协议才会继续走下面的逻辑     
b) 
```
-- servant_name 为协议号, 通常在 netdefine.lua 定义
-- request 为请求协议
-- response 为返回协议
-- 此函数没有返回值, 调用后, 直至服务器返回协议才会继续走下面的逻辑
-- 出现超时(默认10s), 返回出错的情况, 统一在 response 的 retcode 字段中赋值错误码
daserver.syncCall(servant_name, request, response)

-- servant_name 为协议号, 通常在 netdefine.lua 定义
-- request 为请求协议
-- 此函数没有返回值, 调用后只管发送协议, 不等服务器返回
daserver.call(servant_name, request)
```

#### 12. 用什么`IDE`？
通常用`sublime`, 将 `deploy` 目录用鼠标拖进左侧的 `side bar` 即可    
常用的快捷键使用如下:    
`Ctrl + p` 查找文件名    
`Ctrl + r` 查找函数名    
`Ctrl + f` 当前文件中查找    
`Ctrl + Shift + f` 全文文件中查找    




