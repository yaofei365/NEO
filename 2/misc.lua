local function table_length(t)
	local c = 0
	for k, v in pairs(t) do
		c = c + 1
	end
	return c
end

return {
	table_length = table_length,
}