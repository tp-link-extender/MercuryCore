--!strict

--[[
	Constructs special keys for property tables which connect property change
	listeners to an instance.
]]

local PubTypes = require "../PubTypes"
local logError = require "../Logging/logError"
local typeof = require "../Polyfill/typeof"

local function OnChange(propertyName: string): PubTypes.SpecialKey
	local changeKey = {}
	changeKey.type = "SpecialKey"
	changeKey.kind = "OnChange"
	changeKey.stage = "observer"

	function changeKey:apply(
		callback: any,
		applyTo: Instance,
		cleanupTasks: { PubTypes.Task }
	)
		-- local ok, event =
		-- 	pcall(applyTo.GetPropertyChangedSignal, applyTo, propertyName)
		local ok, event = pcall(function()
			return applyTo.Changed
		end)

		if not ok then
			logError(
				"cannotConnectChange",
				nil,
				applyTo.ClassName,
				propertyName
			)
		elseif typeof(callback) ~= "function" then
			logError("invalidChangeHandler", nil, propertyName)
		else
			table.insert(
				cleanupTasks,
				event:connect(function(prop)
					if prop == propertyName then
						callback((applyTo :: any)[propertyName])
					end
				end)
			)
		end
	end

	return changeKey
end

return OnChange
