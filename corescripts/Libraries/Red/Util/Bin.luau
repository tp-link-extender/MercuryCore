--!strict

local Spawn = require "./Spawn"
local typeof = require "../../../Modules/Polyfill/typeof"

type BinItem = Instance | RBXScriptConnection | () -> ...any

return function()
	local Bin: { BinItem } = {}

	return function(Item: BinItem)
		table.insert(Bin, Item)
	end, function()
		for _, Item in ipairs(Bin) do
			if typeof(Item) == "Instance" then
				Item:Destroy()
			elseif typeof(Item) == "RBXScriptConnection" then
				Item:disconnect()
			elseif typeof(Item) == "function" then
				Spawn(Item)
			end
		end

		-- table.clear(Bin)
		for i, _ in ipairs(Bin) do
			Bin[i] = nil
		end
	end
end
