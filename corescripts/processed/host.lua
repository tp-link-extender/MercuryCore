-- Start Game Script Arguments
local placeId, port, sleeptime, access, url, killID, deathID, timeout, autosaveInterval, locationID, groupBuild, machineAddress, gsmInterval, gsmUrl, maxPlayers, maxSlotsUpperLimit, maxSlotsLowerLimit, gsmAccess, injectScriptAssetID, servicesUrl, permissionsServiceUrl, apiKey, libraryRegistrationScriptAssetID = ...


-- StartGame -- 
pcall(function() game:GetService("ScriptContext"):AddStarterScript(injectScriptAssetID) end)
game:GetService("RunService"):Run()

-- REQUIRES: StartGanmeSharedArgs.txt
-- REQUIRES: MonitorGameStatus.txt

------------------- UTILITY FUNCTIONS --------------------------

function waitForChild(parent, childName)
	while true do
		local child = parent:findFirstChild(childName)
		if child then
			return child
		end
		parent.ChildAdded:wait()
	end
end

-- returns the player object that killed this humanoid
-- returns nil if the killer is no longer in the game
function getKillerOfHumanoidIfStillInGame(humanoid)

	-- check for kill tag on humanoid - may be more than one - todo: deal with this
	local tag = humanoid:findFirstChild("creator")

	-- find player with name on tag
	if tag then
		local killer = tag.Value
		if killer.Parent then -- killer still in game
			return killer
		end
	end

	return nil
end

-- send kill and death stats when a player dies
function onDied(victim, humanoid)
	local killer = getKillerOfHumanoidIfStillInGame(humanoid)
	local victorId = 0
	if killer then
		victorId = killer.userId
		print("STAT: kill by " .. victorId .. " of " .. victim.userId)
		game:HttpGet(url .. "/Game/Knockouts.ashx?UserID=" .. victorId .. "&" .. access)
	end
	print("STAT: death of " .. victim.userId .. " by " .. victorId)
	game:HttpGet(url .. "/Game/Wipeouts.ashx?UserID=" .. victim.userId .. "&" .. access)
end

-----------------------------------END UTILITY FUNCTIONS -------------------------

-----------------------------------"CUSTOM" SHARED CODE----------------------------------

pcall(function() settings().Network.UseInstancePacketCache = true end)
pcall(function() settings().Network.UsePhysicsPacketCache = true end)
--pcall(function() settings()["Task Scheduler"].PriorityMethod = Enum.PriorityMethod.FIFO end)
pcall(function() settings()["Task Scheduler"].PriorityMethod = Enum.PriorityMethod.AccumulatedError end)

--settings().Network.PhysicsSend = 1 -- 1==RoundRobin
settings().Network.PhysicsSend = Enum.PhysicsSendMethod.ErrorComputation2
settings().Network.ExperimentalPhysicsEnabled = true
settings().Network.WaitingForCharacterLogRate = 100
pcall(function() settings().Diagnostics:LegacyScriptMode() end)

-----------------------------------START GAME SHARED SCRIPT------------------------------

local url = "_BASE_URL"
local assetId = placeId -- might be able to remove this now

local scriptContext = game:GetService('ScriptContext')
pcall(function() scriptContext:AddStarterScript(libraryRegistrationScriptAssetID) end)
scriptContext.ScriptsDisabled = true

-- game:SetPlaceID(nil, false)
game:GetService("ChangeHistoryService"):SetEnabled(false)

-- establish this peer as the Server
local ns = game:GetService("NetworkServer")

if url~=nil then
	pcall(function() game:GetService("Players"):SetAbuseReportUrl(url .. "/Report/Games.ashx") end)
	pcall(function() game:GetService("ScriptInformationProvider"):SetAssetUrl(url .. "/Asset/") end)
	pcall(function() game:GetService("ContentProvider"):SetBaseUrl(url .. "/") end)
	-- pcall(function() game:GetService("Players"):SetChatFilterUrl(url .. "/Game/ChatFilter.ashx") end)

	-- game:GetService("BadgeService"):SetPlaceId(placeId)
	if access~=nil then
		game:GetService("BadgeService"):SetAwardBadgeUrl(url .. "/Game/Badge/AwardBadge.ashx?UserID=%d&BadgeID=%d&PlaceID=%d&" .. access)
		game:GetService("BadgeService"):SetHasBadgeUrl(url .. "/Game/Badge/HasBadge.ashx?UserID=%d&BadgeID=%d&" .. access)
		game:GetService("BadgeService"):SetIsBadgeDisabledUrl(url .. "/Game/Badge/IsBadgeDisabled.ashx?BadgeID=%d&PlaceID=%d&" .. access)

		game:GetService("FriendService"):SetMakeFriendUrl(servicesUrl .. "/Friend/CreateFriend?firstUserId=%d&secondUserId=%d&" .. access)
		game:GetService("FriendService"):SetBreakFriendUrl(servicesUrl .. "/Friend/BreakFriend?firstUserId=%d&secondUserId=%d&" .. access)
		game:GetService("FriendService"):SetGetFriendsUrl(servicesUrl .. "/Friend/AreFriends?userId=%d&" .. access)
	end
	game:GetService("BadgeService"):SetIsBadgeLegalUrl("")
	game:GetService("InsertService"):SetBaseSetsUrl(url .. "/Game/Tools/InsertAsset.ashx?nsets=10&type=base")
	game:GetService("InsertService"):SetUserSetsUrl(url .. "/Game/Tools/InsertAsset.ashx?nsets=20&type=user&userid=%d")
	game:GetService("InsertService"):SetCollectionUrl(url .. "/Game/Tools/InsertAsset.ashx?sid=%d")
	game:GetService("InsertService"):SetAssetUrl(url .. "/Asset/?id=%d")
	game:GetService("InsertService"):SetAssetVersionUrl(url .. "/Asset/?assetversionid=%d")
	
	pcall(function() loadfile(url .. "/Game/LoadPlaceInfo.ashx?PlaceId=" .. placeId)() end)
	
	pcall(function() 
		if access then
			loadfile(url .. "/Game/PlaceSpecificScript.ashx?PlaceId=" .. placeId .. "&" .. access)()
		end
	end)
end

pcall(function() game:GetService("NetworkServer"):SetIsPlayerAuthenticationRequired(true) end)
settings().Diagnostics.LuaRamLimit = 0
--settings().Network:SetThroughputSensitivity(0.08, 0.01)
--settings().Network.SendRate = 35
--settings().Network.PhysicsSend = 0  -- 1==RoundRobin

--shared["__time"] = 0
--game:GetService("RunService").Stepped:connect(function (time) shared["__time"] = time end)




if placeId~=nil and killID~=nil and deathID~=nil and url~=nil then
	-- listen for the death of a Player
	function createDeathMonitor(player)
		-- we don't need to clean up old monitors or connections since the Character will be destroyed soon
		if player.Character then
			local humanoid = waitForChild(player.Character, "Humanoid")
			humanoid.Died:connect(
				function ()
					onDied(player, humanoid)
				end
			)
		end
	end

	-- listen to all Players' Characters
	game:GetService("Players").ChildAdded:connect(
		function (player)
			createDeathMonitor(player)
			player.Changed:connect(
				function (property)
					if property=="Character" then
						createDeathMonitor(player)
					end
				end
			)
		end
	)
end

game:GetService("Players").PlayerAdded:connect(function(player)
	print("Player " .. player.userId .. " added")
	
	if url and access and placeId and player and player.userId then
		game:HttpGet(url .. "/Game/ClientPresence.ashx?action=connect&" .. access .. "&PlaceID=" .. placeId .. "&UserID=" .. player.userId)
		game:HttpGet(url .. "/Game/PlaceVisit.ashx?UserID=" .. player.userId .. "&AssociatedPlaceID=" .. placeId .. "&" .. access)
	end
end)


game:GetService("Players").PlayerRemoving:connect(function(player)
	print("Player " .. player.userId .. " leaving")	

	if url and access and placeId and player and player.userId then
		game:HttpGet(url .. "/Game/ClientPresence.ashx?action=disconnect&" .. access .. "&PlaceID=" .. placeId .. "&UserID=" .. player.userId)
	end
end)

if placeId~=nil and url~=nil then
	-- yield so that file load happens in the heartbeat thread
	wait()
	
	-- load the game
	game:Load(url .. "/asset/?id=" .. placeId)
end

if _MAP_LOCATION_EXISTS then
	-- yield so that file load happens in the heartbeat thread
	wait()

	-- load the game
	game:Load("_MAP_LOCATION")
end

-- Now start the connection
ns:Start(_PORT, sleeptime) 

game:GetService("Visit"):SetPing("_SERVER_PRESENCE_URL", 30)

if timeout then
	scriptContext:SetTimeout(timeout)
end
scriptContext.ScriptsDisabled = false

--delay(1, function()
--	loadfile(url .. "/analytics/GamePerfMonitor.ashx")(game.JobId, placeId)
--end)

local reset = ";mc"
game.Players.PlayerAdded:connect(function(player)
  player.Chatted:connect(function(msg)
    if msg==reset then
      if player.Character then
        player.Character.Humanoid.Health = 0
      end
    end
  end)
end)

------------------------------END START GAME SHARED SCRIPT--------------------------