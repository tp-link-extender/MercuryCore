--!strict

--[[
	A symbol for representing nil values in contexts where nil is not usable.
]]

local Types = require "../Types"

return {
	type = "Symbol",
	name = "None",
} :: Types.None
