-- Start Game
print "[Mercury]: Loaded Host corescript"

local InsertService = game:GetService "InsertService"
local BadgeService = game:GetService "BadgeService"
local ScriptContext = game:GetService "ScriptContext"
local RunService = game:GetService "RunService"
local ScriptInformationProvider = game:GetService "ScriptInformationProvider"
local ChangeHistoryService = game:GetService "ChangeHistoryService"
local ContentProvider = game:GetService "ContentProvider"
local Players = game:GetService "Players"
local Visit = game:GetService "Visit"

-- establish this peer as the Server
local NetworkServer = game:GetService "NetworkServer"

-- StartGame --

RunService:Run()

-- REQUIRES: StartGanmeSharedArgs.txt
-- REQUIRES: MonitorGameStatus.txt

local url = _BASE_URL

-----------------------------------"CUSTOM" SHARED CODE----------------------------------

pcall(function()
	settings().Network.UseInstancePacketCache = true
end)
pcall(function()
	settings().Network.UsePhysicsPacketCache = true
end)
--pcall(function() settings()["Task Scheduler"].PriorityMethod = Enum.PriorityMethod.FIFO end)
pcall(function()
	settings()["Task Scheduler"].PriorityMethod =
		Enum.PriorityMethod.AccumulatedError
end)

--settings().Network.PhysicsSend = 1 -- 1==RoundRobin
settings().Network.PhysicsSend = Enum.PhysicsSendMethod.ErrorComputation2
settings().Network.ExperimentalPhysicsEnabled = true
settings().Network.WaitingForCharacterLogRate = 100
pcall(function()
	settings().Diagnostics:LegacyScriptMode()
end)

-----------------------------------START GAME SHARED SCRIPT------------------------------

-- pcall(function()
-- 	ScriptContext:AddStarterScript(libraryRegistrationScriptAssetID)
-- end)
ScriptContext.ScriptsDisabled = true

-- game:SetPlaceID(nil, false)
ChangeHistoryService:SetEnabled(false)

if url ~= nil then
	pcall(function()
		Players:SetAbuseReportUrl(`{url}/Report/Games.ashx`)
	end)
	pcall(function()
		ScriptInformationProvider:SetAssetUrl(`{url}/Asset/`)
	end)
	pcall(function()
		ContentProvider:SetBaseUrl(`{url}/`)
	end)

	BadgeService:SetIsBadgeLegalUrl ""
	InsertService:SetBaseSetsUrl(
		`{url}/Game/Tools/InsertAsset.ashx?nsets=10&type=base`
	)
	InsertService:SetUserSetsUrl(
		`{url}/Game/Tools/InsertAsset.ashx?nsets=20&type=user&userid=%d`
	)
	InsertService:SetCollectionUrl(`{url}/Game/Tools/InsertAsset.ashx?sid=%d`)
	InsertService:SetAssetUrl(`{url}/asset?id=%d`)
	InsertService:SetAssetVersionUrl(`{url}/Asset/?assetversionid=%d`)
end

pcall(function()
	NetworkServer:SetIsPlayerAuthenticationRequired(true)
end)
settings().Diagnostics.LuaRamLimit = 0

Players.PlayerAdded:connect(function(player)
	print(`Player {player.userId} added`)
end)

Players.PlayerRemoving:connect(function(player)
	print(`Player {player.userId} leaving`)
end)

if _MAP_LOCATION_EXISTS then
	-- yield so that file load happens in the heartbeat thread
	RunService.Heartbeat:wait()

	-- load the game
	game:Load(_MAP_LOCATION)
end

-- Now start the connection
NetworkServer:Start(_SERVER_PORT)

Visit:SetPing(_SERVER_PRESENCE_URL, 30)

-- if timeout then
-- 	ScriptContext:SetTimeout(timeout)
-- end
ScriptContext.ScriptsDisabled = false

-- delay(1, function()
-- 	loadfile(`{url}/analytics/GamePerfMonitor.ashx`)(game.JobId, placeId)
-- end)

-- yimy stuff
local reset = ";mc"
game.Players.PlayerAdded:connect(function(player)
	player.Chatted:connect(function(msg)
		if msg == reset and player.Character then
			player.Character.Humanoid.Health = 0
		end
	end)
end)
