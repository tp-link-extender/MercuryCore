--!strict

--[[
	A common interface for accessing the values of state objects or constants.
]]

local PubTypes = require "../PubTypes"
local Types = require "../Types"
-- State
local isState = require "../State/isState"

local function peek<T>(target: PubTypes.CanBeState<T>): T
	if isState(target) then
		return (target :: Types.StateObject<T>):_peek()
	end
	return target
end

return peek
