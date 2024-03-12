local CollectionService = game:GetService "CollectionService"

local Spawn = require "./Spawn"

return function<T...>(
	Tag: string,
	Start: (Instance) -> T...,
	Stop: (T...) -> ()
): () -> ()
	local InstanceMap = {}

	for _, Instance in ipairs(CollectionService:GetTagged(Tag)) do
		Spawn(function()
			InstanceMap[Instance] = { Start(Instance) }
		end)
	end

	local AddConnection = CollectionService:GetInstanceAddedSignal(Tag)
		:connect(function(Instance)
			InstanceMap[Instance] = { Start(Instance) }
		end)

	local RemoveConnection = CollectionService:GetInstanceRemovedSignal(Tag)
		:connect(function(Instance)
			local Value = InstanceMap[Instance]

			if Value then
				InstanceMap[Instance] = nil
				Stop(unpack(Value))
			end
		end)

	return function()
		AddConnection:Disconnect()
		RemoveConnection:Disconnect()

		for Instance, Value in pairs(InstanceMap) do
			Spawn(Stop, unpack(Value))
		end
	end
end
