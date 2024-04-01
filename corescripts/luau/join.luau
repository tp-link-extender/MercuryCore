--!strict
print "[Graphictoria]: Loaded Join corescript"

local InsertService = game:GetService "InsertService"
local ChangeHistoryService = game:GetService "ChangeHistoryService"
local ContentProvider = game:GetService "ContentProvider"
local SocialService = game:GetService "SocialService"
local GamePassService = game:GetService "GamePassService"
local MarketplaceService = game:GetService "MarketplaceService"
local Players = game:GetService "Players"
local Client = game:GetService "NetworkClient"
local Visit = game:GetService "Visit"

local player, connectionFailed

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
-- (there aren't any)
local threadSleepTime = 15

-- local test = _IS_STUDIO_JOIN -- unused

print "! Joining game '_PLACE_ID' place _PLACE_ID at _SERVER_ADDRESS"

ChangeHistoryService:SetEnabled(false)
ContentProvider:SetThreadPool(16)
InsertService:SetBaseSetsUrl "http://banland.xyz/game/tools/insertasset?nsets=10&type=base"
InsertService:SetUserSetsUrl "http://banland.xyz/game/tools/insertasset?nsets=20&type=user&userid=%d"
InsertService:SetCollectionUrl "http://banland.xyz/game/tools/insertasset?sid=%d"
InsertService:SetAssetUrl "http://banland.xyz/asset?id=%d"
InsertService:SetAssetVersionUrl "http://banland.xyz/asset?assetversionid=%d"

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
	MarketplaceService:SetProductInfoUrl "http://banland.xyz/marketplace/productinfo?assetId=%d"
end)
pcall(function()
	MarketplaceService:SetPlayerOwnsAssetUrl "http://banland.xyz/ownership/hasasset?userId=%d&assetId=%d"
end)
pcall(function()
	game:SetCreatorID(_CREATOR_ID, Enum.CreatorType.User)
end)

-- Bubble chat.  This is all-encapsulated to allow us to turn it off with a config setting
pcall(function()
	Players:SetChatStyle(Enum.ChatStyle.ClassicAndBubble)
end)

pcall(function()
	if settings().Network.MtuOverride == 0 then
		settings().Network.MtuOverride = 1400
	end
end)

-- functions ---------------------------------------
local loadingState = 0
local function setLoadingMessage(message: string)
	local dots = ""
	loadingState += 1
	local currentLoadingState = loadingState
	Spawn(function()
		while loadingState == currentLoadingState do
			game:SetMessage(message .. dots)
			wait(0.3)
			dots ..= "."
			if dots == "...." then
				dots = ""
			end
		end
	end)
end

local function setMessage(message: string)
	loadingState += 1
	game:SetMessage(message)
end

local function reportError(err)
	print("***ERROR*** " .. err)
	Visit:SetUploadUrl ""
	Client:Disconnect()
	wait(4)
	setMessage("Error: " .. err)
end

-- called when the client connection closes
local function onDisconnection(_, lostConnection)
	if lostConnection then
		setMessage "You have lost the connection to the game"
	else
		setMessage "This game has shut down"
	end
end

local function requestCharacter(replicator)
	-- prepare code for when the Character appears
	local connection
	connection = player.Changed:connect(function(property)
		if property == "Character" then
			loadingState += 1
			game:ClearMessage()
			connection:disconnect()
		end
	end)

	setLoadingMessage "Requesting character"

	local success, err = pcall(function()
		replicator:RequestCharacter()
		setLoadingMessage "Waiting for character"
	end)

	if not success then
		reportError(err)
		return
	end
end

-- called when the client connection is established
local function onConnectionAccepted(_, replicator)
	local waitingForMarker = true

	local success, err = pcall(function()
		Visit:SetPing(_PING_URL, 30)

		loadingState += 1
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
		reportError(err)
		return
	end

	-- TODO: report marker progress

	while waitingForMarker do
		workspace:ZoomToExtents()
		wait(0.5)
	end
end

-- called when the client connection fails
local function onConnectionFailed(_, err)
	setMessage(`Failed to connect to the place. (ID={err})`)
end

-- called when the client connection is rejected
local function onConnectionRejected()
	connectionFailed:disconnect()
	setMessage "This place is not available. Please try another"
end

local function onPlayerIdled(idleTime)
	if idleTime > 20 * 60 then
		setMessage(
			string.format(
				"You were disconnected for being idle %d minutes",
				idleTime / 60
			)
		)
		Client:disconnect()
	end
end

-- main ------------------------------------------------------------

pcall(function()
	settings().Diagnostics:LegacyScriptMode()
end)
local success, err = pcall(function()
	game:SetRemoteBuildMode(true)

	setLoadingMessage "Connecting to server"
	Client.ConnectionAccepted:connect(onConnectionAccepted)
	Client.ConnectionRejected:connect(onConnectionRejected)
	connectionFailed = Client.ConnectionFailed:connect(onConnectionFailed)
	Client.Ticket = ""

	local playerConnectSuccess
	playerConnectSuccess, player = pcall(function()
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
	player.CharacterAppearance = _CHAR_APPEARANCE
	Visit:SetUploadUrl ""
end)

if not success then
	reportError(err)
end

-- TODO: Async get?
-- loadfile ""("", -1, 0) -- wtf

pcall(function()
	game:SetScreenshotInfo ""
end)
pcall(function()
	game:SetVideoInfo '<?xml version="1.0"?><entry xmlns="http://www.w3.org/2005/Atom" xmlns:media="http://search.yahoo.com/mrss/" xmlns:yt="http://gdata.youtube.com/schemas/2007"><media:group><media:title type="plain"><![CDATA[Graphictoria Place]]></media:title><media:description type="plain"><![CDATA[ For more games visit http://banland.xyz]]></media:description><media:category scheme="http://gdata.youtube.com/schemas/2007/categories.cat">Games</media:category><media:keywords>Graphictoria, video, free game, online virtual world</media:keywords></media:group></entry>'
end)
-- use single quotes here because the video info string may have unescaped double quotes
