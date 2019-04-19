local create_normal_bag = require("normal_bag")
local misc = require("misc")

local function check_bag_item(bag, unique_id, item_id, count)
	local item = bag.tbl_item[unique_id]
	assert(item.unique_id == unique_id)
	assert(item.item_id == item_id)
	assert(item.count == count)
end

local bag = create_normal_bag()

-- 检查放入物品逻辑
local b = bag:put_item_begin()
assert(b:put_item_id(1, 10) == true)
assert(b:put_item_id(2, 10) == true)
assert(b:put_item_id(2, 3) == true)
bag:put_item_commit(b)

-- 检查背包物品个数
assert(misc.table_length(bag.tbl_item) == 3)

-- 检查背包里的具体物品
check_bag_item(bag, 1, 1, 10)
check_bag_item(bag, 2, 2, 12)
check_bag_item(bag, 3, 2, 1)

-- 测试背包空间不足的情况
b = bag:put_item_begin()
assert(b:put_item_id(2, 12) == false)

b = bag:put_item_begin()
assert(b:put_item_id(2, 11) == true)
bag:put_item_commit(b)

-- 检查背包物品个数
assert(misc.table_length(bag.tbl_item) == 3)

-- 检查背包里的具体物品
check_bag_item(bag, 1, 1, 10)
check_bag_item(bag, 2, 2, 12)
check_bag_item(bag, 3, 2, 12)

print("pass")