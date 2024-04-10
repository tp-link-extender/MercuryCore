--!strict

--[[
	Returns true if the given value is not automatically memory managed, and
	requires manual cleanup.
]]

local typeof = require "../../../Modules/Polyfill/typeof"

local function needsDestruction(x: any): boolean
	return typeof(x) == "Instance"
end

return needsDestruction
