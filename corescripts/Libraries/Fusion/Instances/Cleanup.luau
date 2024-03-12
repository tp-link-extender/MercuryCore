--!strict

--[[
	A special key for property tables, which adds user-specified tasks to be run
	when the instance is destroyed.
]]

local PubTypes = require "../PubTypes"

local Cleanup = {}
Cleanup.type = "SpecialKey"
Cleanup.kind = "Cleanup"
Cleanup.stage = "observer"

function Cleanup:apply(
	userTask: any,
	_: Instance,
	cleanupTasks: { PubTypes.Task }
)
	table.insert(cleanupTasks, userTask)
end

return Cleanup
