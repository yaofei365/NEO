# 实现游戏背包模块    

## 游戏背包(bag)说明    
(1) 游戏背包里, 每件物品只占一个格子    
(2) 游戏背包格子从 1 开始     
(3) 放进游戏背包格子的物品 `item` 包含以下字段    
```lua
{
	unique_id = 0 -- 表示物品的唯一 id, 全局唯一
	slot = 0 -- 表示在背包格子的位置
	item_id = 0 -- 表示具体的物品
	count = 0 -- 表示物品的数量
	bind = 0 -- 表示物品是否绑定, 0 为非绑, 1 为绑定
}
```
(4) 背包里的部份物品可叠加(即一个格子放 1 个以上的相同物品), 物品的叠加数(overlay_size)从配置文件中读取     

## 物品配置文件    
```lua
{
	[item_id] = { item_id = xx, item_name = "xx", overlay_size = xx },
	...
}
```
`item_name` 表示物品名称    
`overlay_size` 表示物品的叠加数    

## 游戏背包(bag)提供以下接口
(1) `load_item(tbl_item)`    
`tbl_item` 是一个 `table`, 以 `item` 的 `unique_id` 作为 `key`, `item` 作为 `value`      
用于游戏启动时, 将物品加载到背包      

(2) `put_item_id(item_id, count)`    
a. 添加指定 `item_id` 的物品, 个数为 `count` 个    
b. 当背包已存在 item_id 的物品时, 需要优先叠加到 现有物品 上     

## 调用示例
```lua
local unique_id = 0
local function get_next_unique_id()
	unique_id = unique_id + 1
	return unique_id
end

local function new_item(item_id, count)
	local item = {}
	item.unique_id = get_next_unique_id()
	item.slot = 0
	item.item_id = item_id
	item.bind = 0

	return item
end

local function create_item_table()
	local 
	for i = 1, 10 do
		local item_id = math.random(1, 3)
		local item = new_item(1, 2)
		
	end
end

local bag = require("bag")

```