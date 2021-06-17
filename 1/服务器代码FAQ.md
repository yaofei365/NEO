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
(1) dbmgr 与 centermgr 在启动进程时, 会将 `mysql`相关表加载至"内存数据库" (以下相关表的数据不会加载至"内存数据库")    
a) 表名 `tb_ad_` 开头的表(通常是 php 相关表)      
b) 表名 `tb_rp_` 开头的表(通常是 php 相关表)    
c) 表名 `tmp_` 开头的表(通常是处理某个问题的临时表)           
d) `vw_` 开头的视图     
(2) `tb_player_` 开头, 并以 `_pd` 结尾的表, 只会根据 `player_id` 加载部份玩家的数据(详情请参阅: https://github.com/yaofei365/NEO/blob/master/1/4.服务器库表结构.md 一文中的 `玩家私有数据表` 一节)         
(3) 进程启动后, 一切数据更新都先更新至"内存数据库"，再定时同步至"mysql";     
(4) 基于 (2) 的描述, 不建议在进程启动时直接修改 mysql; 通常是停止进程后, 在 mysql 作相关数据修改, 再重新启动进程;     

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

#### 12. 用什么`IDE`?    
通常用`sublime`, 打开`sublime`后用鼠标将`deploy`目录拖到去即可    
常用的快捷键使用如下:    
`Ctrl + p` 查找文件名    
`Ctrl + r` 查找函数名    
`Ctrl + f` 当前文件中查找    
`Ctrl + Shift + f` 全文文件中查找    

#### 13. 进程内存的数据保存在哪?    
每个进程都有自己保存的数据，保存的数据通常在进程目录下`global.lua`文件里有定义    
读取时, 采用`进程名_global`来获取(eg. 在 gateway 中可以用 gateway_global.xxx 来获取保存在进程内的数据)    

#### 14. 有没有封装一些公用函数?    
a) 进程内的公用函数通常在每个进程目录下的`global.lua`里     
b) 多个进程使用的公用代码通常在 `deploy\server\lua\server_common`目录下     
c) 不涉及业务逻辑的公用函数在 `deploy\common\commonfunc.lua`    
d) 公用的"队列"用法
```
local create_queue = require("server_common.queue")
local q = create_queue()
q.push(x) -- 将 x 添加到队列的尾部, 无返回值    
q.push_array(t) -- 将 t (t为数组) 里的所有元素, 添加至队列的尾部, 无返回值    
local x = q.pop() -- 移除并返回队列的第一个元素
local t = q.pop_array(x) -- 移除并返回队列的前 x 个元素, 返回值为数值
local len = q.size() -- 返回队列的长度
```

#### 15. 如何将内网环境的数据导致本地进行测试?     
a) 打开 http://dev.project1.local:8080/job/misc-backup-database/build?delay=0sec, `DBNAME` 改为内网的数据库名, 按`build` 开始构建    
b) 构建完成后, 打开 http://dev.project1.local/dbbackup/ 进行下载, 通常第一个文件即刚刚导出的数据库    
c) 运行 \deploy\server\bat\import_sql_from_file.bat, 选择 `单服` 或 `央服`, 然后拖入上一步下载的`sql`文件, 回车, 等待导入完成    

#### 16. 如何使用内网账号在本地进行测试?     
a) 获取角色昵称    
b) 根据角色昵称， 在本地数据库`tb_player`表查找字段`nickname`对应的记录, 并记录`user_id`字段的值    
c) 根据`user_id`在本地数据库`tb_user`表找到对应记录, 并获取`session`值, 在客户端使用`session`进行登录       

#### 17. 如何调试服务器代码?     
a) 服务器不支持`单步调试`，目前是通过加 log 来定位问题的    
b) 示例代码如下:
```
-- 下面两句代码通常写在 lua 文件头部
local daserver = require("framework.daserver")
local log_error = daserver.log_error

-- 在需要打印 log 的位置加上 log_error
log_error("%s %d", ...)
```
c) 如果想要打印一个`table`里的所有值，可以用`require("util.dump").dump(t)`       
**注意: `dump`函数只能用于内网 / 本地调试时打印数据, 正式发布时需要去除 (因为此函数有一定的时间消耗, 会影响到玩家的正常操作)**      
```
log_error("%s", require("util.dump").dump(t))  -- 其中 t 为需要打印的 table
```

#### 18. 服务器如何实例“每日重置”，“每周重置”?      
a) 参见 [库表结构](https://github.com/yaofei365/NEO/blob/master/1/4.%E6%9C%8D%E5%8A%A1%E5%99%A8%E5%BA%93%E8%A1%A8%E7%BB%93%E6%9E%84.md)中第 7 点: `玩家私有数据表`    
b) 由于服务器并非加载所有玩家的数据到`内存数据库`， “每日重置”时只有部份活跃玩家的数据在`内存数据库`     
c) 目前服务器实现的“每日重置”是通过对每个“需要重置的数据”记录多一个“重置时间戳”, eg: 玩家的`每日活跃值(active_value)`, 会有一个`活跃值重置时间(active_value_reset_time)`     
d) 读取数据时, 先判断“重置时间”，如果一致，则数据有效； 如果不一致，则表示数据“重置”， 如下代码所示 (同样以`每日活跃值`作为例子)     
```
if player.avatar_detail.active_value_reset_time ~= gateway_global.daily_reset_time then
	player.avatar_detail.active_value_reset_time = 0
	player.avatar_detail.active_value_reset_time = gateway_global.daily_reset_time
end

-- 后续操作 ...
```
e) 游戏中所有数据的重置基本上都采用这个方案, 每日重置则与 `gateway_global.daily_reset_time` 判断； 每周重置则与 `gateway_global.weekly_reset_time` 判断     

#### 19. 新增奖励类型需要修改哪些代码?     
详见: https://github.com/jzqy/jzqy/wiki 整理了一些常见的代码修改      

#### 20. 什么情况下需要生成一个`唯一 id`?    
a) 此`id`在协议中使用, 并且数据库的多个表会记录这个`id`    
b) 如果使用数据库的`自增 id`, 在 a) 的情况下, 合服时, 需要同时修改多张表中记录的`id`    
c) 目前合服脚本只支持三种情况 两个服务器的表数据直接合并； 表数据直接清除;   只保留其中一个服的数据;     
d) 综上所述, 需要生成`唯一 id`, 保证合服时, 两张表的数据可以直接合并;    

#### 21. 如何在 `gateway` 获得一个`唯一 id`?    
a) 在 `deploy/server/lua/dbmgr/dbdefine.lua` 中 `SYSTEM_UUID_TYPE` 新增一个新的定义（gateway 的唯一 id 通常在 1000 以后增加）      
b) 通知运维在 ${svnpath}\deploy\server\sqlscript\init_system_data.sql 中 insert `tb_sys_id_increment` 时增加语句, 并提供修复sql     
c) 如果增加 >= 1000 的定义, 通知运维在 ${svnpath}\shell\server\sqlscript\sp_fixed_worker_uuid.sql 加上对应的函数调用      
d) c) 中提及的`sp_fixed_worker_uuid`, 第一个参数表示刚刚新增的定义的值, 第二个参数表示此`唯一 id`保存在数据库对应的表(可以通过此表获取此 id 在单服的最大值)       
d) 在`gateway`使用以下代码获取`唯一id`(其中 XXXXX 为新增的定义)    
```
local get_next_uuid = require("server_common.get_next_uuid").get_next_uuid

...

get_next_uuid(gateway_global.tbl_sys_uuid_inc, DBDEF.SYSTEM_UUID_TYPE.XXXXX, gateway_global.server_id)
```

#### 22. 如何添加一个定时器?    
以 `gateway` 为例, 可以使用以下代码添加一个定时器    
```
	local function timeout()
		return -- return nil 时表示定时器终止
		return 1000 -- return 1000 表示 1000 毫秒后再次触发
	end

	gateway_global.timewheel:timeout(seconds * 1000, timeout)
```
a) `gateway_global.timewheel:timeout()`　第一个参数为时间(即多长时间后触发, 注意单位是: 毫秒); 第二个参数为 触发时调用的函数;     
b) timemout 函数的返回值决定`定时器`是否重复触发; `return nil` 时定时器则不会再触发        
c) 定时器触发时, 调用者有责任对数据进行检查(eg. 玩家可能已经不在线, 玩家相关数据已经不在内存)     

#### 23. GW_ 开头与 GWI_ 开头都是 `gateway` 的协议, 它们有什么区别?     
a) `GW_`开头的协议通常用于客户端的请求, 对客户端开放     
b) `GWI_`开头的协议通常是服务器内部**主动**通知`gateway`的协议，只对服务器内部开放     

#### 24. 协议通讯的四个接口 `daserver.call()`, `daserver.send()`, `daserver.syncCall()`, `daserver.syncSend()` 它们有什么区别?    
a) 有 `sync` 前缀的 `daserver.syncCall()`, `daserver.syncSend()` 表示调用之后, 必须等待**对端服务器**返回，才会继续走之后的逻辑；会"阻塞"业务, 默认超时是 10 秒     
b) 没有`sync` 前缀的 `daserver.call()`, `daserver.send()` 表示调用之后, 不会等待**对端服务器**返回, 不会“阻塞”业务    
c) 发送协议使用 `call` 或 `send` 取决于： “发送者”是 “被动连接”(别人主动发起连接) 还是 “主动连接”(自己主动连接别人)     
d) "被动连接"用`send`; "主动连接"用`call`;    
e) eg. 在现有服务器的架构中, `gateway` 主动连接 `globalmgr`, 所以 `gateway` 向 `globalmgr` 发送协议时, 应该用 `call`; 而 `globalmgr` 向 `gateway` 发送协议时, 应该用 `send`;     

f) 在`\deploy\server\conf\`目录下找到对应进程的配置文件,  其中 `[servant service settings]` 表示本进程提供的服务(监听的端口); `[server settings]` 表示本进程主动连接的服务;     
g) eg. 从 gateway.conf 的配置中可以看出, gateway 会主动连接 `dbmgr`, `globalmgr`, `chatrecord` 三个进程, 所以在 gateway 向这三个进程发送协议都应该用 `call`     
h) 当不确定用 `call` 还是用 `send` 时, 可以通过查看配置的方式确定;     

#### 25. gateway 向 cellapp 发送协议应该用 `call()` 还是 `send()`, 查看 gateway 配置文件没有主动连接 cellapp?    
在现有的服务器架构中, 大部份进程的连接关系都会在进程的配置文件中会相应的配置; 除了 `cellapp` 是个特例, 因为 `cellapp` 会配置很多个进程, 如果每个都在 gateway 的配置文件里配置, 那么将会有不小的配置工作量；所以`cellapp`目前采用的是"动态连接"，即当 gateway 需要向某个 cellapp 发送协议时, 才会“动态连接”上`cellapp`; 这些细节都被封装到了 `player:call_cellapp()`(同步调用) 和 `player:send_to_cellapp()`(异步调用, 不等返回); 所以在 gateway 中向 cellapp 发送协议, 通常调用 `player:call_cellapp()` 或 `player:send_to_cellapp()` 即可; 

#### 26. dbmgr 或 centermgr 增加一个 表结构 或 修改表字段 需要哪些操作？    
a) 通常需要在 `\deploy\server\sqlscript\modify\` 新增一个 sql 文件(修复语句); `modify` 文件夹下的 sql 文件通常是以数字来命名, 每增加一个 sql 文件, 文件名采用数字累加 1 的方式命名;    
b) [增加表结构示例](https://github.com/yaofei365/NEO/blob/master/1/%E5%A2%9E%E5%8A%A0%E8%A1%A8%E7%BB%93%E6%9E%84%E7%A4%BA%E4%BE%8B.sql); [修改表结构示例](https://github.com/yaofei365/NEO/blob/master/1/%E4%BF%AE%E6%94%B9%E8%A1%A8%E7%BB%93%E6%9E%84%E7%A4%BA%E4%BE%8B.sql)(修改表采用存储过程的方式，主要为了可以重复调用);向表里插入数据通常也是用`replace into`；       
c) dbmgr 在 `\deploy\server\sqlscript\modify\` 目录下新增修复语句; centermgr 在 `\deploy\server\sqlscript-center\modify\` 目录下新增修复语句;     
d) 修复语句 sql 必须用 **utf-8 格式** 保存;     
e) 增加修复语句 sql 并提交至 svn, 通知管理员生成 `program.exe` 后, 才能在 Lua 代码中使用 `daodb.xxxx()` 操作表的内容    
f) 如果数据库表结构字段不对应 或 表不存在, 在启动`dbmgr` 或 `centermgr` 时会报错     
g) **修复数据 与 表结构 的 sql 不要写在同一个 sql 文件; 方便管理员生成 program.exe;**       

#### 27. `call_event()` 的用法？     
示例用法:
```
	player:add_call_event("on_get_rare_item", tbl_item, OPERATION.ACTIVITY_REWARD)
	player:add_call_event("xxx", ...)
	player:call_event()
```
(1) `call_event()` 是对一些函数的封装调用    
(2) 这些函数通常在进程目录下的`event`文件夹下    
(3) 进程启动时, 会遍历`event`目录下除`event.lua`文件外的所有其它文件, 并对其执行`require`操作(这个细节封装在 `event/event.lua` 中, 使用时只需要在`event`目录下添加对应的文件即可)      
(4) eg. 在`event`目录下添加一个`on_levelup.lua`的文件, `on_levelup.lua` 文件的具体实现如下:    
```
return function(old_level, new_level)
	log_info("old_level(%d)|new_level(%d)", old_level, new_level)
end
```
调用时使用以下代码:    
```
	player:add_call_event("on_levelup", old_level, new_level)
	player:call_event()
```
(5) `add_call_event()` 将 需要调用的函数 添加至队列, `call_event()` 遍历队列并执行队列里的所有函数(这些细节封装在 `event/event.lua` 中）    

#### 28. `call_event()` 的用途？     
`call_event()`在现有服务器中，主要有以下三个用途      

(1) 封装一些常见的“事件处理”(公共代码), 如玩家等级升级, 玩家 vip 变更 ... 等等, 做其它一些成就/活动系统开发时, 需要处理"某个事件", 则可以优先在 `event` 目录下查找有无现成封装好的"事件"    

(2) 实现“延迟调用”，具体应用场景如 `gateway` 的发奖励流程(具体代码详见: `/deploy/server/lua/gateway/player/reward.lua` 中的 `reward()` 函数), 需要确保所有奖励都发放成功，再处理一些“奖励事件”(如首充公告)     
gateway 的奖励流程是 `(a)先判断数值合法性 -> (b)修改玩家内存数据 -> (c)更新数据库` 在 (a) - (c) 的过程中是不允许有"阻塞(同步)"调用的，如果有，那么可以放到 event 函数里, 在完成 (c) 后会统一调用`call_event()`     

(3) 在“公用”进程的代码中，充当“公用接口”, 具体应用场景是:     
`activitymgr`进程不是一个真正的"进程"，是 `globalmgr` 和 `centermgr` 抽取出来的 "公用代码"，主要用于管理活动相关数据；而在 `globalmgr` 和 `centermgr` 发送给玩家消息处理方式是不同的；此时可以在`activitymgr`使用 
```
activitymgr_global:add_call_event("send_to_player", req); 
activitymgr_global:call_event()
```    
分别在`globalmgr` 和 `centermgr`进程目录下的`activitymgr_event`添加 `send_to_player.lua` 并加上具体的实现。     

#### 29. `DEFINE.REWARD_COST_TYPE.CHARGE_MONEY` 和 `DEFINE.REWARD_COST_TYPE.CHARGE_PRICE` 的区别是什么?     
(1) 在早期的服务器实现中，`tb_table_charge` 只有 `money` 字段，没有 `price` 字段; `money` 是指玩家充值会得到的"元宝数"； `price` 是后期增加的字段，表示玩家充值时所花费的钱(单位: 分)  
(2) 在早期的服务器实现中，“月卡”是使用“元宝”来购买；所有活动的充值进度是使用 `money` 字段的值来增加“活动进度”；

(3) 后期，策划需求 - “月卡必须使用真钱购买”，于是在 `tb_table_charge` 表增加了一些新的充值档次，如 "月卡充值", 而"月卡充值"这个充值档次的 `money` 是必须配置为 0 的(否则按原有逻辑，玩家会收到元宝)    
(4) 在 (3) 的前提下, "购买月卡" 也需要增加"活动进度"； 于是增加了 `price` 字段用于增加“消费真钱”的活动进度；     
(5) 后期的活动配置基本都采用 `DEFINE.REWARD_COST_TYPE.CHARGE_PRICE` 进行配置;     

#### 30. 如何找到某个逻辑的相关代码？    
(1) 从`gateway`相关的协议(GW_ 开头的协议)入手, 在 netdefine.lua 中查找相关协议 (所以在 netdefine.lua 增加注释非常必要, 有时候代码中的叫法与实际游戏中的叫法不同, 可以询问下客户端发的哪一条协议)      
(2) 从`mysql`相关的表结构入手，先查找 dbmgr 哪些地方对"相关的表结构"进行操作, 再通过查找哪里地方发送 dbmgr 的协议    





