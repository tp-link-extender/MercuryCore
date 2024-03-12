--!strict

--[[
	A special key for property tables, which stores a reference to the instance
	in a user-provided Value object.
]]

local PubTypes = require "../PubTypes"
local logError = require "../Logging/logError"
local xtypeof = require "../Utility/xtypeof"

local Ref = {}
Ref.type = "SpecialKey"
Ref.kind = "Ref"
Ref.stage = "observer"

function Ref:apply(
	refState: any,
	applyTo: Instance,
	cleanupTasks: { PubTypes.Task }
)
	if xtypeof(refState) ~= "State" or refState.kind ~= "Value" then
		logError "invalidRefType"
	else
		refState:set(applyTo)
		table.insert(cleanupTasks, function()
			refState:set(nil)
		end)
	end
end

return Ref
