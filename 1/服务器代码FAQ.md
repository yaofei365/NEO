1. 如何找到某个结构的赋值代码?     
	a). 服务器的所有[结构]都会有 `deploy\common\netimpl\common\` 这个文件夹有对应的定义     
	b). 少数内部使用的[结构]不会在 `deploy\common\netimpl\common\` 定义, 但必定是在一个 Lua 文件内, 如果是跨多个 Lua 文件的, 必定会在 `deploy\common\netimpl\common\` 有定义(即使协议没有使用到)     
	c). 赋值操作的惯用写法是:     
    ```
		local create_yyy = require("netimpl.common.yyy").create_response -- 此句代码通常写在 Lua 文件头部

		local xxx = create_yyy() -- yyy 为结构名
		xxx.zzz = aaa
    ```
	d). 综上所述, 只需要全局查找所有 create_yyy() 就可以找到所有赋值的相关代码     

2. 如何找到发送某条协议的所有代码?     
	a). 服务器发送协议必定是通过 `daserver.syncCall` 或 `daserver.call` 发送的     
	b). a). 提及的两个接口都必须传递 servant_name 这个参数     
	c). 综上所述, 只需要全局搜索 servant_name 就可以     
	d). server_name 在代码中的惯用写法是 NETDEFINE.XXXXX (具体可参考 netdefine.lua 文件中的定义, 每条协议必定对应一个 servant_name)     

3. 
