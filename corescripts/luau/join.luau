print "[Mercury]: Loaded Join corescript"
local InsertService = game:GetService "InsertService"
local ChangeHistoryService = game:GetService "ChangeHistoryService"
local ContentProvider = game:GetService "ContentProvider"
local SocialService = game:GetService "SocialService"
local GamePassService = game:GetService "GamePassService"
local MarketplaceService = game:GetService "MarketplaceService"
-- local UserInputService = game:GetService "UserInputService"
local Players = game:GetService "Players"
local Client = game:GetService "NetworkClient"
local Visit = game:GetService "Visit"

-- MultiplayerSharedScript.lua inserted here ------ Prepended to Join.lua --

pcall(function()
	game:SetPlaceID(_PLACE_ID, false)
end)

-- if we are on a touch device, no blocking http calls allowed! This can cause a crash on iOS
-- In general we need a long term strategy to remove blocking http calls from all platforms
-- local isTouchDevice = UserInputService.TouchEnabled

settings()["Game Options"].CollisionSoundEnabled = true
pcall(function()
	settings().Rendering.EnableFRM = true
end)
pcall(function()
	settings().Physics.Is30FpsThrottleEnabled = false
end)
pcall(function()
	settings()["Task Scheduler"].PriorityMethod =
		Enum.PriorityMethod.AccumulatedError
end)
pcall(function()
	settings().Physics.PhysicsEnvironmentalThrottle =
		Enum.EnviromentalPhysicsThrottle.DefaultAuto
end)

-- arguments ---------------------------------------
local threadSleepTime = ...

if threadSleepTime == nil then
	threadSleepTime = 15
end

local test = _IS_STUDIO_JOIN

print "! Joining game '_PLACE_ID' place _PLACE_ID at _SERVER_ADDRESS"

ChangeHistoryService:SetEnabled(false)
ContentProvider:SetThreadPool(16)
InsertService:SetBaseSetsUrl "http://banland.xyz/game/tools/insertasset?nsets=10&type=base"
InsertService:SetUserSetsUrl "http://banland.xyz/game/tools/insertasset?nsets=20&type=user&userid=%d"
InsertService:SetCollectionUrl "http://banland.xyz/game/tools/insertasset?sid=%d"
InsertService:SetAssetUrl "http://banland.xyz/Asset/?id=%d"
InsertService:SetAssetVersionUrl "http://banland.xyz/Asset/?assetversionid=%d"

pcall(function()
	SocialService:SetFriendUrl "http://banland.xyz/Game/LuaWebService/HandleSocialRequest.ashx?method=IsFriendsWith&playerid=%d&userid=%d"
end)
pcall(function()
	SocialService:SetBestFriendUrl "http://banland.xyz/Game/LuaWebService/HandleSocialRequest.ashx?method=IsBestFriendsWith&playerid=%d&userid=%d"
end)
pcall(function()
	SocialService:SetGroupUrl "http://banland.xyz/Game/LuaWebService/HandleSocialRequest.ashx?method=IsInGroup&playerid=%d&groupid=%d"
end)
pcall(function()
	SocialService:SetGroupRankUrl "http://banland.xyz/Game/LuaWebService/HandleSocialRequest.ashx?method=GetGroupRank&playerid=%d&groupid=%d"
end)
pcall(function()
	SocialService:SetGroupRoleUrl "http://banland.xyz/Game/LuaWebService/HandleSocialRequest.ashx?method=GetGroupRole&playerid=%d&groupid=%d"
end)
pcall(function()
	GamePassService:SetPlayerHasPassUrl "http://banland.xyz/Game/GamePass/GamePassHandler.ashx?Action=HasPass&UserID=%d&PassID=%d"
end)
pcall(function()
	MarketplaceService:SetProductInfoUrl "https://banland.xyz/marketplace/productinfo?assetId=%d"
end)
pcall(function()
	MarketplaceService:SetPlayerOwnsAssetUrl "https://banland.xyz/ownership/hasasset?userId=%d&assetId=%d"
end)
pcall(function()
	game:SetCreatorID(_CREATOR_ID, Enum.CreatorType.User)
end)

-- Bubble chat.  This is all-encapsulated to allow us to turn it off with a config setting
pcall(function()
	Players:SetChatStyle(Enum.ChatStyle.ClassicAndBubble)
end)

waitingForCharacter = false
pcall(function()
	if settings().Network.MtuOverride == 0 then
		settings().Network.MtuOverride = 1400
	end
end)

-- functions ---------------------------------------
function setMessage(message: string)
	-- todo: animated "..."
	game:SetMessage(message)
end

function showErrorWindow(message, _, _)
	game:SetMessage(message)
end

function reportError(err, message)
	print("***ERROR*** " .. err)
	if not test then
		Visit:SetUploadUrl ""
	end
	Client:Disconnect()
	wait(4)
	showErrorWindow("Error: " .. err, message, "Other")
end

-- called when the client connection closes
function onDisconnection(_, lostConnection)
	if lostConnection then
		showErrorWindow(
			"You have lost the connection to the game",
			"LostConnection",
			"LostConnection"
		)
	else
		showErrorWindow("This game has shut down", "Kick", "Kick")
	end
end

function requestCharacter(replicator)
	-- prepare code for when the Character appears
	local connection
	connection = player.Changed:connect(function(property)
		if property == "Character" then
			game:ClearMessage()
			waitingForCharacter = false
			connection:disconnect()
		end
	end)

	setMessage "Requesting character"

	local success, err = pcall(function()
		replicator:RequestCharacter()
		setMessage "Waiting for character"
		waitingForCharacter = true
	end)

	if not success then
		reportError(err, "W4C")
		return
	end
end

-- called when the client connection is established
function onConnectionAccepted(url, replicator)
	connectResolved = true

	local waitingForMarker = true

	local success, err = pcall(function()
		if not test then
			Visit:SetPing("_PING_URL", 30)
		end

		game:SetMessageBrickCount()

		replicator.Disconnection:connect(onDisconnection)

		-- Wait for a marker to return before creating the Player
		local marker = replicator:SendMarker()

		marker.Received:connect(function()
			waitingForMarker = false
			requestCharacter(replicator)
		end)
	end)

	if not success then
		reportError(err, "ConnectionAccepted")
		return
	end

	-- TODO: report marker progress

	while waitingForMarker do
		workspace:ZoomToExtents()
		wait(0.5)
	end
end

-- called when the client connection fails
function onConnectionFailed(_, error)
	showErrorWindow(
		"Failed to connect to the Game. (ID=" .. error .. ")",
		"ID" .. error,
		"Other"
	)
end

-- called when the client connection is rejected
function onConnectionRejected()
	connectionFailed:disconnect()
	showErrorWindow(
		"This game is not available. Please try another",
		"WrongVersion",
		"WrongVersion"
	)
end

local idled = false
function onPlayerIdled(time)
	if time > 20 * 60 then
		showErrorWindow(
			string.format(
				"You were disconnected for being idle %d minutes",
				time / 60
			),
			"Idle",
			"Idle"
		)
		Client:disconnect()
		if not idled then
			idled = true
		end
	end
end

-- main ------------------------------------------------------------

pcall(function()
	settings().Diagnostics:LegacyScriptMode()
end)
local success, err = pcall(function()
	game:SetRemoteBuildMode(true)

	setMessage "Connecting to Server"
	Client.ConnectionAccepted:connect(onConnectionAccepted)
	Client.ConnectionRejected:connect(onConnectionRejected)
	connectionFailed = Client.ConnectionFailed:connect(onConnectionFailed)
	Client.Ticket = ""

	local playerConnectSuccess, player = pcall(function()
		return Client:PlayerConnect(
			_USER_ID,
			"_SERVER_ADDRESS",
			_SERVER_PORT,
			0,
			threadSleepTime
		)
	end)
	if not playerConnectSuccess then
		--Old player connection scheme
		player = Players:CreateLocalPlayer(_USER_ID)
		Client:Connect("_SERVER_ADDRESS", _SERVER_PORT, 0, threadSleepTime)
	end

	player:SetSuperSafeChat(false)
	pcall(function()
		player:SetUnder13(false)
	end)
	pcall(function()
		player:SetMembershipType(Enum.MembershipType._MEMBERSHIP_TYPE)
	end)
	pcall(function()
		player:SetAccountAge(1)
	end)
	player.Idled:connect(onPlayerIdled)

	pcall(function()
		player.Name = [========[_USER_NAME]========]
	end)
	player.CharacterAppearance = "_CHAR_APPEARANCE"
	if not test then
		Visit:SetUploadUrl ""
	end
end)

if not success then
	reportError(err, "CreatePlayer")
end

if not test then
	-- TODO: Async get?
	loadfile ""("", -1, 0)
end

pcall(function()
	game:SetScreenshotInfo ""
end)
pcall(function()
	game:SetVideoInfo '<?xml version="1.0"?><entry xmlns="http://www.w3.org/2005/Atom" xmlns:media="http://search.yahoo.com/mrss/" xmlns:yt="http://gdata.youtube.com/schemas/2007"><media:group><media:title type="plain"><![CDATA[Mercury Place]]></media:title><media:description type="plain"><![CDATA[ For more games visit http://banland.xyz]]></media:description><media:category scheme="http://gdata.youtube.com/schemas/2007/categories.cat">Games</media:category><media:keywords>Mercury, video, free game, online virtual world</media:keywords></media:group></entry>'
end)
-- use single quotes here because the video info string may have unescaped double quotes
