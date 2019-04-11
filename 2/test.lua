local create_bag = require("bag")
local tbl_config_item = {
	[1] = { item_id = 1, overlay_size = 10, item_name = "item_1" },
	[2] = { item_id = 2, overlay_size = 12, item_name = "item_2" },
}

local unique_id = 0
local function gen_unique_id()
	unique_id = unique_id + 1
	return unique_id
end

local callback = {}
function callback:on_add_item(item)
end

function callback:on_mod_item(item)
end

function callback:on_del_item(item)
end

function callback:can_overlay(item, item_id, count, ...)
	if item.item_id ~= item_id then
		return false
	else
		return true
	end
end

function callback:get_bag_size()
	return 3
end

function callback:create_item(bag, item_id, count, free_slot, ...)
	local item = {}
	item.unique_id = gen_unique_id()
	item.slot = free_slot
	item.item_id = item_id
	item.count = count
	return item
end

function callback:get_item_overlay_size(item_id)
	return tbl_config_item[item_id].overlay_size
end

local function table_length(t)
	local c = 0
	for k, v in pairs(t) do
		c = c + 1
	end
	return c
end

local bag = create_bag(callback)

local b = bag:put_item_begin()
assert(b:put_item_id(1, 10) == true)
assert(b:put_item_id(2, 10) == true)
assert(b:put_item_id(2, 3) == true)
bag:put_item_commit(b)

assert(table_length(bag.tbl_item) == 3)

local item

item = bag.tbl_item[1]
assert(item.unique_id == 1)
assert(item.item_id == 1)
assert(item.count == 10)

item = bag.tbl_item[2]
assert(item.unique_id == 2)
assert(item.item_id == 2)
assert(item.count == 12)

item = bag.tbl_item[3]
assert(item.unique_id == 3)
assert(item.item_id == 2)
assert(item.count == 1)
