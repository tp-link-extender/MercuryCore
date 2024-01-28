--!strict

--[[
	Constructs a 'use callback' for the purposes of collecting dependencies.
]]

local PubTypes = require "../PubTypes"
local Types = require "../Types"
-- State
local isState = require "../State/isState"

type Set<T> = { [T]: any }

local function makeUseCallback(dependencySet: Set<PubTypes.Dependency>)
	local function use<T>(target: PubTypes.CanBeState<T>): T
		if isState(target) then
			dependencySet[target] = true
			return (target :: Types.StateObject<T>):_peek()
		end
		return target
	end
	return use
end

return makeUseCallback
