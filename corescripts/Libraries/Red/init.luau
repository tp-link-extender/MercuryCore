--!strict

local function Red(_, Script: LuaSourceContainer)
	local _SERVER

	if Script:IsA "LocalScript" then
		_SERVER = false
	elseif Script:IsA "Script" then
		_SERVER = true
	else
		error("Argument must be the script itself", 2)
	end

	local Net = require "./Net"(_SERVER)

	return {
		Server = Net.Server,
		Client = Net.Client,

		Collection = require "./Util/Collection",
		Ratelimit = require "./Util/Ratelimit",
		Promise = require "./Util/Promise",
		Signal = require "./Util/Signal",
		Clock = require "./Util/Clock",
		Spawn = require "./Util/Spawn",
		Bin = require "./Util/Bin",
	}
end

return {
	Help = function()
		return "See https://redblox.dev/ for more information."
	end,
	Load = Red,
}
