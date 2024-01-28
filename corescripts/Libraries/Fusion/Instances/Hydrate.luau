--!strict

--[[
	Processes and returns an existing instance, with options for setting
	properties, event handlers and other attributes on the instance.
]]

local PubTypes = require "../PubTypes"
local applyInstanceProps = require "../Instances/applyInstanceProps"

local function Hydrate(target: Instance)
	return function(props: PubTypes.PropertyTable): Instance
		applyInstanceProps(props, target)
		return target
	end
end

return Hydrate
