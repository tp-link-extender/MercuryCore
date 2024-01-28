--!strict

--[[
	A special key for property tables, which allows users to extract values from
	an instance into an automatically-updated Value object.
]]

local PubTypes = require "../PubTypes"
local logError = require "../Logging/logError"
local xtypeof = require "../Utility/xtypeof"

local function Out(propertyName: string): PubTypes.SpecialKey
	local outKey = {}
	outKey.type = "SpecialKey"
	outKey.kind = "Out"
	outKey.stage = "observer"

	function outKey:apply(
		outState: any,
		applyTo: Instance,
		cleanupTasks: { PubTypes.Task }
	)
		-- local ok, event =
		-- 	pcall(applyTo.GetPropertyChangedSignal, applyTo, propertyName)
		local ok, event = pcall(function()
			return applyTo.Changed
		end)

		if not ok then
			logError("invalidOutProperty", nil, applyTo.ClassName, propertyName)
		elseif xtypeof(outState) ~= "State" or outState.kind ~= "Value" then
			logError "invalidOutType"
		else
			outState:set((applyTo :: any)[propertyName])
			table.insert(
				cleanupTasks,
				event:connect(function(prop)
					if prop == propertyName then
						outState:set((applyTo :: any)[propertyName])
					end
				end)
			)
			table.insert(cleanupTasks, function()
				outState:set(nil)
			end)
		end
	end

	return outKey
end

return Out
