--!strict

--[[
	Constructs special keys for property tables which connect event listeners to
	an instance.
]]

local PubTypes = require "../PubTypes"
local logError = require "../Logging/logError"
local typeof = require "../../../Modules/Polyfill/typeof"

local function getProperty_unsafe(instance: Instance, property: string)
	return (instance :: any)[property]
end

local function OnEvent(eventName: string): PubTypes.SpecialKey
	local eventKey = {}
	eventKey.type = "SpecialKey"
	eventKey.kind = "OnEvent"
	eventKey.stage = "observer"

	function eventKey:apply(
		callback: any,
		applyTo: Instance,
		cleanupTasks: { PubTypes.Task }
	)
		local ok, event = pcall(getProperty_unsafe, applyTo, eventName)
		if not ok or typeof(event) ~= "RBXScriptSignal" then
			logError("cannotConnectEvent", nil, applyTo.ClassName, eventName)
		elseif typeof(callback) ~= "function" then
			logError("invalidEventHandler", nil, eventName)
		else
			table.insert(cleanupTasks, event:connect(callback))
		end
	end

	return eventKey
end

return OnEvent
