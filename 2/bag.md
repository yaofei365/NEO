## 变量命名
名称 | 单词
|----|---|
背包 | bag
物品 | item    
唯一 id | unique_id
位置 | slot

## 描述规范
(1) `tbl_item = { [item_id] = {item}, ... }` 表示 `tbl_item` 是一个 `lua table`, 以 `item_id` 用为 key, `item` 作为 value    
(2) `tbl_item = { {item}, ... }` 表示 `tbl_item` 是一个 `lua 序列`, 序列里的每个元素是 `item`    

## 游戏背包模块 bag    
(1) 游戏背包泛指 `MMORPG` 游戏中的背包, 本项目实现的背包, 一个物品只占一个 `背包格子`    
(2) 放在 `背包格子` 的物品以 `lua` `table` 的形式保存在内存中, 每个物品至少包含以下信息    
```lua
{
	unique_id = 0, -- 表示物品的唯一 id, 全局唯一
	item_id = 0, -- 表示物品 id, 用于标识此物品的用途
	count = 0, -- 表示物品的数量
	slot = 0, -- 表示在背包格子的位置
}
```
(3) 分别放在两个`背包格子` 且 `item_id` 相同的两个物品可叠加成一个实体, 叠加后只占一个`背包格子`, `count` 为两个物品的 `count` 之和         

## bag 提供以下接口
(1) 创建背包 (callback)    
a. `callback` 必须提供以下接口    
on_add_item() 用于监听物品增加信息, 无返回    
on_mod_item() 用于监听物品修改信息, 无返回    
on_del_item() 用于监听物品删除信息, 无返回    
can_overlay(item, item_id, count, ...) 判断物品是否可叠加, 可叠加返回 true, 否则返回 false    
get_bag_size() 返回背包大小    
create_item(bag, item_id, count, free_slot, ...) 返回创建的新物品    
get_item_overlay_size(item_id) 根据 item_id 返回物品的叠加数    

(2) `load_item(tbl_item)`    
a. 游戏初始化时, 将物品加载到背包       
b. 无返回值
c. `tbl_item = { [unique_id] = {item}, ... }`

(3) `put_item_id(item_id, count)`    
a. 添加指定 `item_id` 的物品, 个数为 `count` 个    
b. 加入物品成功时, 返回 `true`, 否则返回 `false`    
c. 当背包已存在 `item_id` 的物品时, 需要优先叠加到 `现有物品` 上    
d. 调用完 `put_item_id()` 后, 必须调用 `commit()` 接口提交背包的修改     

(4) `put_item_begin()`    
a. 开始背包增加物品修改     

(5) `put_item_commit()`    
a. 提交背包增加物品修改     
b. 无返回值    

## 调用示例
见 `test.lua`

## TODO 
1. 可以根据 item_uuid 快速找到一件物品(这个物品可能是在背包 也可能是在身上的装备)    
2. 合成的物品如果是指定的身上装备的物品，那么需要放回【装备背包】上       
3. 背包提供了一个 on_add_item() 接口用于监听【珍希物品】的获取，用于公告，当背包满直接发邮件时，不会走到 on_add_item() 的逻辑   
