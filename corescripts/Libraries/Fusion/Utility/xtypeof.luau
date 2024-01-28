--!strict

--[[
	Extended typeof, designed for identifying custom objects.
	If given a table with a `type` string, returns that.
	Otherwise, returns `typeof()` the argument.
]]

local typeof = require "../Polyfill/typeof"

local function xtypeof(x: any)
	local typeString = typeof(x)

	if typeString == "table" and type(x.type) == "string" then
		return x.type
	else
		return typeString
	end
end

return xtypeof
