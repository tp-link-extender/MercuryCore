print "[Mercury]: Loaded Host corescript"
local placeId, sleeptime, access, url, killID, deathID, timeout, injectScriptAssetID, servicesUrl, libraryRegistrationScriptAssetID
pcall(function()
	return game:GetService("ScriptContext"):AddStarterScript(injectScriptAssetID)
end)
game:GetService("RunService"):Run()
local waitForChild
waitForChild = function(parent, childName)
	while true do
		local child = parent:findFirstChild(childName)
		if child then
			return child
		end
		parent.ChildAdded:wait()
	end
end
local getKillerOfHumanoidIfStillInGame
getKillerOfHumanoidIfStillInGame = function(humanoid)
	local tag = humanoid:findFirstChild "creator"
	if tag and tag.Value.Parent then
		return tag.Value
	end
end
local onDied
onDied = function(victim, humanoid)
	local killer, victorId = getKillerOfHumanoidIfStillInGame(humanoid), 0
	if killer then
		victorId = killer.userId
		print("STAT: kill by " .. tostring(victorId) .. " of " .. tostring(victim.userId))
		game:HttpGet(tostring(url) .. "/Game/Knockouts.ashx?UserID=" .. tostring(victorId) .. "&" .. tostring(access))
	end
	print("STAT: death of " .. tostring(victim.userId) .. " by " .. tostring(victorId))
	return game:HttpGet(
		tostring(url) .. "/Game/Wipeouts.ashx?UserID=" .. tostring(victim.userId) .. "&" .. tostring(access)
	)
end
pcall(function()
	settings().Network.UseInstancePacketCache = true
end)
pcall(function()
	settings().Network.UsePhysicsPacketCache = true
end)
pcall(function()
	settings()["Task Scheduler"].PriorityMethod = Enum.PriorityMethod.AccumulatedError
end)
settings().Network.PhysicsSend = Enum.PhysicsSendMethod.ErrorComputation2
settings().Network.ExperimentalPhysicsEnabled = true
settings().Network.WaitingForCharacterLogRate = 100
pcall(function()
	return settings().Diagnostics:LegacyScriptMode()
end)
url = "_BASE_URL"
local scriptContext = game:GetService "ScriptContext"
pcall(function()
	return scriptContext:AddStarterScript(libraryRegistrationScriptAssetID)
end)
scriptContext.ScriptsDisabled = true
game:GetService("ChangeHistoryService"):SetEnabled(false)
local ns = game:GetService "NetworkServer"
if url ~= nil then
	pcall(function()
		return game:GetService("Players"):SetAbuseReportUrl(tostring(url) .. "/Report/Games.ashx")
	end)
	pcall(function()
		return game:GetService("ScriptInformationProvider"):SetAssetUrl(tostring(url) .. "/Asset/")
	end)
	pcall(function()
		return game:GetService("ContentProvider"):SetBaseUrl(tostring(url) .. "/")
	end)
	if access ~= nil then
		do
			local _with_0 = game:GetService "BadgeService"
			_with_0:SetAwardBadgeUrl(
				tostring(url) .. "/Game/Badge/AwardBadge.ashx?UserID=%d&BadgeID=%d&PlaceID=%d&" .. tostring(access)
			)
			_with_0:SetHasBadgeUrl(
				tostring(url) .. "/Game/Badge/HasBadge.ashx?UserID=%d&BadgeID=%d&" .. tostring(access)
			)
			_with_0:SetIsBadgeDisabledUrl(
				tostring(url) .. "/Game/Badge/IsBadgeDisabled.ashx?BadgeID=%d&PlaceID=%d&" .. tostring(access)
			)
		end
		do
			local _with_0 = game:GetService "FriendService"
			_with_0:SetMakeFriendUrl(
				tostring(servicesUrl) .. "/Friend/CreateFriend?firstUserId=%d&secondUserId=%d&" .. tostring(access)
			)
			_with_0:SetBreakFriendUrl(
				tostring(servicesUrl) .. "/Friend/BreakFriend?firstUserId=%d&secondUserId=%d&" .. tostring(access)
			)
			_with_0:SetGetFriendsUrl(tostring(servicesUrl) .. "/Friend/AreFriends?userId=%d&" .. tostring(access))
		end
	end
	game:GetService("BadgeService"):SetIsBadgeLegalUrl ""
	do
		local _with_0 = game:GetService "InsertService"
		_with_0:SetBaseSetsUrl(tostring(url) .. "/game/tools/insertasset?nsets=10&type=base")
		_with_0:SetUserSetsUrl(tostring(url) .. "/game/tools/insertasset?nsets=20&type=user&userid=%d")
		_with_0:SetCollectionUrl(tostring(url) .. "/game/tools/insertasset?sid=%d")
		_with_0:SetAssetUrl(tostring(url) .. "/Asset/?id=%d")
		_with_0:SetAssetVersionUrl(tostring(url) .. "/Asset/?assetversionid=%d")
	end
	pcall(function()
		return loadfile(tostring(url) .. "/Game/LoadPlaceInfo.ashx?PlaceId=" .. tostring(placeId))()
	end)
	pcall(function()
		if access then
			return loadfile(
				tostring(url)
					.. "/Game/PlaceSpecificScript.ashx?PlaceId="
					.. tostring(placeId)
					.. "&"
					.. tostring(access)
			)()
		end
	end)
end
pcall(function()
	return game:GetService("NetworkServer"):SetIsPlayerAuthenticationRequired(true)
end)
settings().Diagnostics.LuaRamLimit = 0
if (placeId ~= nil) and (killID ~= nil) and (deathID ~= nil) and (url ~= nil) then
	local createDeathMonitor
	createDeathMonitor = function(player)
		if player.Character then
			local humanoid = waitForChild(player.Character, "Humanoid")
			return humanoid.Died:connect(function()
				return onDied(player, humanoid)
			end)
		end
	end
	game:GetService("Players").ChildAdded:connect(function(player)
		createDeathMonitor(player)
		return player.Changed:connect(function(property)
			if property == "Character" then
				return createDeathMonitor(player)
			end
		end)
	end)
end
game:GetService("Players").PlayerAdded:connect(function(player)
	print("Player " .. tostring(player.userId) .. " added")
	if url and access and placeId and player and player.userId then
		game:HttpGet(
			tostring(url)
				.. "/Game/ClientPresence.ashx?action=connect&"
				.. tostring(access)
				.. "&PlaceID="
				.. tostring(placeId)
				.. "&UserID="
				.. tostring(player.userId)
		)
		return game:HttpGet(
			tostring(url)
				.. "/Game/PlaceVisit.ashx?UserID="
				.. tostring(player.userId)
				.. "&AssociatedPlaceID="
				.. tostring(placeId)
				.. "&"
				.. tostring(access)
		)
	end
end)
game:GetService("Players").PlayerRemoving:connect(function(player)
	print("Player " .. tostring(player.userId) .. " leaving")
	if url and access and placeId and player and player.userId then
		return game:HttpGet(
			tostring(url)
				.. "/Game/ClientPresence.ashx?action=disconnect&"
				.. tostring(access)
				.. "&PlaceID="
				.. tostring(placeId)
				.. "&UserID="
				.. tostring(player.userId)
		)
	end
end)
if (placeId ~= nil) and (url ~= nil) then
	wait()
	game:Load(tostring(url) .. "/asset/?id=" .. tostring(placeId))
end
if _MAP_LOCATION_EXISTS then
	wait()
	game:Load "_MAP_LOCATION"
end
ns:Start(_SERVER_PORT, sleeptime)
game:GetService("Visit"):SetPing("_SERVER_PRESENCE_URL", 30)
if timeout then
	scriptContext:SetTimeout(timeout)
end
scriptContext.ScriptsDisabled = false
local reset = ";mc"
return game.Players.PlayerAdded:connect(function(player)
	return player.Chatted:connect(function(msg)
		if msg == reset then
			if player.Character then
				player.Character.Humanoid.Health = 0
			end
		end
	end)
end)
