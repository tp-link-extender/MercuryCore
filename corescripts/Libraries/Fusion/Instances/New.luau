--!strict

--[[
	Constructs and returns a new instance, with options for setting properties,
	event handlers and other attributes on the instance right away.
]]

local PubTypes = require "../PubTypes"
local defaultProps = require "../Instances/defaultProps"
local applyInstanceProps = require "../Instances/applyInstanceProps"
local logError = require "../Logging/logError"

local function New(className: string)
	return function(props: PubTypes.PropertyTable): Instance
		local ok, instance = pcall(Instance.new, className)

		if not ok then
			logError("cannotCreateClass", nil, className)
		end

		local classDefaults = defaultProps[className]
		if classDefaults ~= nil then
			for defaultProp, defaultValue in pairs(classDefaults) do
				instance[defaultProp] = defaultValue
			end
		end

		applyInstanceProps(props, instance)

		return instance
	end
end

return New
