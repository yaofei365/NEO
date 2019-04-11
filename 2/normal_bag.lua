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

local function on_add_item(self, item)
end

local function on_mod_item(self, item)
end

local function on_del_item(self, item)
end

local function can_overlay(self, item, item_id, count, ...)
	if item.item_id ~= item_id then
		return false
	else
		return true
	end
end

local function get_bag_size()
	return 3
end

local function create_item(self, bag, item_id, count, free_slot, ...)
	local item = {}
	item.unique_id = gen_unique_id()
	item.slot = free_slot
	item.item_id = item_id
	item.count = count
	return item
end

local function get_item_overlay_size(self, item_id)
	return tbl_config_item[item_id].overlay_size
end

local function create()
	local m = {}
	m.create_item = create_item
	m.get_item_overlay_size = get_item_overlay_size
	m.get_bag_size = get_bag_size
	m.can_overlay = can_overlay
	m.on_add_item = on_add_item
	m.on_mod_item = on_mod_item
	m.on_del_item = on_del_item

	return create_bag(m)
end
return create