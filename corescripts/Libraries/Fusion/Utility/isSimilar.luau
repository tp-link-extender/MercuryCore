--!strict
--[[
    Returns true if A and B are 'similar' - ie. any user of A would not need
    to recompute if it changed to B.
]]

local function isSimilar(a: any, b: any): boolean
	-- HACK: because tables are mutable data structures, don't make assumptions
	-- about similarity from equality for now (see issue #44)
	if type(a) == "table" then
		return false
	end
	-- NaN does not equal itself but is the same
	return a == b or a ~= a and b ~= b
end

return isSimilar
