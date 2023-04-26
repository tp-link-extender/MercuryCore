-- MultiplayerSharedScript.lua inserted here ------ Prepended to Join.lua --
pcall(function()
	return game:SetPlaceID(_PLACE_ID, false)
end)
local isTouchDevice = Game:GetService("UserInputService").TouchEnabled
settings()["Game Options"].CollisionSoundEnabled = true
pcall(function()
	settings().Rendering.EnableFRM = true
end)
pcall(function()
	settings().Physics.Is30FpsThrottleEnabled = false
end)
pcall(function()
	settings()["Task Scheduler"].PriorityMethod = Enum.PriorityMethod.AccumulatedError
end)
pcall(function()
	settings().Physics.PhysicsEnvironmentalThrottle = Enum.EnviromentalPhysicsThrottle.DefaultAuto
end)
local threadSleepTime = ...
if threadSleepTime == nil then
	threadSleepTime = 15
end
local test = _IS_STUDIO_JOIN
print("! Joining game '_PLACE_ID' place _PLACE_ID at _SERVER_ADDRESS")
game:GetService("ChangeHistoryService"):SetEnabled(false)
game:GetService("ContentProvider"):SetThreadPool(16)
do
	local _with_0 = game:GetService("InsertService")
	_with_0:SetBaseSetsUrl("http://www.roblox.com/Game/Tools/InsertAsset.ashx?nsets=10&type=base")
	_with_0:SetUserSetsUrl("http://www.roblox.com/Game/Tools/InsertAsset.ashx?nsets=20&type=user&userid=%d")
	_with_0:SetCollectionUrl("http://www.roblox.com/Game/Tools/InsertAsset.ashx?sid=%d")
	_with_0:SetAssetUrl("http://banland.xyz/Asset/?id=%d")
	_with_0:SetAssetVersionUrl("http://www.roblox.com/Asset/?assetversionid=%d")
end
do
	local _with_0 = game:GetService("SocialService")
pcall(function()
		return _with_0:SetFriendUrl("http://banland.xyz/Game/LuaWebService/HandleSocialRequest.ashx?method=IsFriendsWith&playerid=%d&userid=%d")
	end)
pcall(function()
		return _with_0:SetBestFriendUrl("http://banland.xyz/Game/LuaWebService/HandleSocialRequest.ashx?method=IsBestFriendsWith&playerid=%d&userid=%d")
	end)
pcall(function()
		return _with_0:SetGroupUrl("http://banland.xyz/Game/LuaWebService/HandleSocialRequest.ashx?method=IsInGroup&playerid=%d&groupid=%d")
	end)
pcall(function()
		return _with_0:SetGroupRankUrl("http://banland.xyz/Game/LuaWebService/HandleSocialRequest.ashx?method=GetGroupRank&playerid=%d&groupid=%d")
	end)
pcall(function()
		return _with_0:SetGroupRoleUrl("http://banland.xyz/Game/LuaWebService/HandleSocialRequest.ashx?method=GetGroupRole&playerid=%d&groupid=%d")
	end)
end
pcall(function()
	return game:GetService("GamePassService"):SetPlayerHasPassUrl("http://banland.xyz/Game/GamePass/GamePassHandler.ashx?Action=HasPass&UserID=%d&PassID=%d")
end)
pcall(function()
	return game:GetService("MarketplaceService"):SetProductInfoUrl("https://banland.xyz/marketplace/productinfo?assetId=%d")
end)
pcall(function()
	return game:GetService("MarketplaceService"):SetPlayerOwnsAssetUrl("https://banland.xyz/ownership/hasasset?userId=%d&assetId=%d")
end)
pcall(function()
	return game:SetCreatorID(_CREATOR_ID, Enum.CreatorType.User)
end)
pcall(function()
	return game:GetService("Players"):SetChatStyle(Enum.ChatStyle.ClassicAndBubble)
end)
local waitingForCharacter = false
pcall(function()
	if settings().Network.MtuOverride == 0 then
		settings().Network.MtuOverride = 1400
	end
end)
local client = game:GetService("NetworkClient")
local visit = game:GetService("Visit")
local setMessage
setMessage = function(message)
	return game:SetMessage((function()
		if not false then
			return message
		else
			return "Teleporting ..."
		end
	end)())
end
local showErrorWindow
showErrorWindow = function(message, _, _)
	return game:SetMessage(message)
end
local reportError
reportError = function(err, message)
	print("***ERROR*** " .. tostring(err))
	if not test then
		visit:SetUploadUrl("")
	end
	client:disconnect()
	wait(4)
	return showErrorWindow("Error: " .. tostring(err), message, "Other")
end
local onDisconnection
onDisconnection = function(_, lostConnection)
	if lostConnection then
		return showErrorWindow("You have lost the connection to the game", "LostConnection", "LostConnection")
	else
		return showErrorWindow("This game has shut down", "Kick", "Kick")
	end
end
local requestCharacter
requestCharacter = function(replicator)
	local connection
	connection = player.Changed:connect(function(property)
		if property == "Character" then
			game:ClearMessage()
			waitingForCharacter = false
			return connection:disconnect()
		end
	end)
	setMessage("Requesting character")
	local success, err
	success, err = pcall(function()
		replicator:RequestCharacter()
		setMessage("Waiting for character")
		waitingForCharacter = true
	end)
	if not success then
		reportError(err, "W4C")
		return
	end
end
local onConnectionAccepted
onConnectionAccepted = function(url, replicator)
	local connectResolved = true
	local waitingForMarker = true
	local success, err
	success, err = pcall(function()
		if not test then
			visit:SetPing("_PING_URL", 30)
		end
		if not false then
			game:SetMessageBrickCount()
		else
			setMessage("Teleporting ...")
		end
		replicator.Disconnection:connect(onDisconnection)
		local marker = replicator:SendMarker()
		return marker.Received:connect(function()
			waitingForMarker = false
			return requestCharacter(replicator)
		end)
	end)
	if not success then
		reportError(err, "ConnectionAccepted")
		return
	end
	while waitingForMarker do
		workspace:ZoomToExtents()
		wait(0.5)
	end
end
local onConnectionFailed
onConnectionFailed = function(_, err)
	return showErrorWindow("Failed to connect to the Game. (ID=" .. tostring(err) .. ")", "ID" .. tostring(err), "Other")
end
local onConnectionRejected
onConnectionRejected = function()
	connectionFailed:disconnect()
	return showErrorWindow("This game is not available. Please try another", "WrongVersion", "WrongVersion")
end
local idled = false
local onPlayerIdled
onPlayerIdled = function(time)
	if time > 20 * 60 then
		showErrorWindow(string.format("You were disconnected for being idle %d minutes", time / 60), "Idle", "Idle")
		client:disconnect()
		if not idled then
			idled = true
		end
	end
end
pcall(function()
	return settings().Diagnostics:LegacyScriptMode()
end)
local success, err = pcall(function()
	game:SetRemoteBuildMode(true)
	setMessage("Connecting to Server")
	client.ConnectionAccepted:connect(onConnectionAccepted)
	client.ConnectionRejected:connect(onConnectionRejected)
	connectionFailed = client.ConnectionFailed:connect(onConnectionFailed)
	client.Ticket = ""
	playerConnectSucces, player = pcall(function()
		return client:PlayerConnect(_USER_ID, "_SERVER_ADDRESS", _SERVER_PORT, 0, threadSleepTime)
	end)
	if not playerConnectSucces then
		player = game:GetService("Players"):CreateLocalPlayer(_USER_ID)
		client:Connect("_SERVER_ADDRESS", _SERVER_PORT, 0, threadSleepTime)
	end
	if not test then
		delay(300, function()
			while false do
pcall(function()
					return game:HttpPost("https://banland.xyz/auth/renew", "renew")
				end)
				wait(300)
			end
		end)
	end
	do
		local _with_0 = player
		_with_0:SetSuperSafeChat(false)
pcall(function()
			return _with_0:SetUnder13(false)
		end)
pcall(function()
			return _with_0:SetMembershipType(Enum.MembershipType._MEMBERSHIP_TYPE)
		end)
pcall(function()
			return _with_0:SetAccountAge(1)
		end)
	end
	player.Idled:connect(onPlayerIdled)
pcall(function()
		player.Name = [========[_USER_NAME]========]
	end)
	player.CharacterAppearance = "_CHAR_APPEARANCE"
	if not test then
		return visit:SetUploadUrl("")
	end
end)
if not success then
	reportError(err, "CreatePlayer")
end
if not test then
	loadfile(("")("", -1, 0))
end
pcall(function()
	return game:SetScreenshotInfo("")
end)
return pcall(function()
	return game:SetVideoInfo('<?xml version="1.0"?><entry xmlns="http://www.w3.org/2005/Atom" xmlns:media="http://search.yahoo.com/mrss/" xmlns:yt="http://gdata.youtube.com/schemas/2007"><media:group><media:title type="plain"><![CDATA[ROBLOX Place]]></media:title><media:description type="plain"><![CDATA[ For more games visit http://www.roblox.com]]></media:description><media:category scheme="http://gdata.youtube.com/schemas/2007/categories.cat">Games</media:category><media:keywords>ROBLOX, video, free game, online virtual world</media:keywords></media:group></entry>')
end)
