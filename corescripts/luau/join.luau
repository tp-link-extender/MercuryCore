--!strict
print "[Mercury]: Loaded Join corescript"

local InsertService = game:GetService "InsertService"
local ChangeHistoryService = game:GetService "ChangeHistoryService"
local ContentProvider = game:GetService "ContentProvider"
local Players = game:GetService "Players"
local Client = game:GetService "NetworkClient"
local Visit = game:GetService "Visit"

local BaseUrl = require "../Modules/BaseUrl"
local path = BaseUrl.path

local player: Player
local connectionFailed: RBXScriptConnection

pcall(function()
	game:SetPlaceId(_PLACE_ID, false)
end)

-- if we are on a touch device, no blocking http calls allowed! This can cause a crash on iOS
-- In general we need a long term strategy to remove blocking http calls from all platforms
-- local isTouchDevice = UserInputService.TouchEnabled

settings()["Game Options"].CollisionSoundEnabled = true
pcall(function()
	settings().Rendering.EnableFRM = true
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
InsertService:SetBaseSetsUrl(path "game/tools/insertasset?nsets=10&type=base")
InsertService:SetUserSetsUrl(
	path "game/tools/insertasset?nsets=20&type=user&userid=%d"
)
InsertService:SetCollectionUrl(path "game/tools/insertasset?sid=%d")
InsertService:SetAssetUrl(path "asset?id=%d")
InsertService:SetAssetVersionUrl(path "asset?assetversionid=%d")

pcall(function()
	game:SetCreatorId(_CREATOR_ID, Enum.CreatorType.User)
end)

-- Bubble chat.  This is all-encapsulated to allow us to turn it off with a config setting
pcall(function()
	Players:SetChatStyle(Enum.ChatStyle.ClassicAndBubble)
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
	setMessage(
		lostConnection and "You have lost the connection to the game"
			or "This game has shut down"
	)
end

local function requestCharacter(replicator)
	-- prepare code for when the Character appears
	local connection: RBXScriptConnection
	connection = player.Changed:connect(function(property)
		if property == "Character" then
			loadingState += 1
			game:ClearMessage()
			connection:disconnect()
		end
	end)

	setLoadingMessage "Requesting character"

	local ok, err = pcall(function()
		replicator:RequestCharacter()
		setLoadingMessage "Waiting for character"
	end)

	if not ok then
		reportError(err)
		return
	end
end

-- called when the client connection is established
local function onConnectionAccepted(_, rep: Instance)
	local replicator = rep :: NetworkReplicator
	local waitingForMarker = true

	local ok, err = pcall(function()
		Visit:SetPing("_PING_URL", 30)

		loadingState += 1
		game:SetMessageBrickCount()

		replicator.Disconnection:connect(onDisconnection)

		-- Wait for a marker to return before creating the Player
		local marker = replicator:SendMarker() :: NetworkMarker

		marker.Received:connect(function()
			waitingForMarker = false
			requestCharacter(replicator)
		end)
	end)

	if not ok then
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
local function onConnectionFailed(_, code: number, reason: string)
	setMessage(`Failed to connect to the place. (ID {code}, {reason})`)
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
		Client:Disconnect()
	end
end

-- main ------------------------------------------------------------

settings().Diagnostics:LegacyScriptMode()
local ok, err = pcall(function()
	game:SetRemoteBuildMode(true)

	setLoadingMessage "Connecting to server"
	Client.ConnectionAccepted:connect(onConnectionAccepted)
	Client.ConnectionRejected:connect(onConnectionRejected)
	connectionFailed = Client.ConnectionFailed:connect(onConnectionFailed)
	Client.Ticket = ""

	player = Client:PlayerConnect(
		_USER_ID,
		"_SERVER_ADDRESS",
		_SERVER_PORT,
		0,
		threadSleepTime
	) :: Player
	player:SetSuperSafeChat(false)
	pcall(function()
		player:SetUnder13(false)
	end)
	pcall(function()
		player:SetMembershipType(_MEMBERSHIP_TYPE)
	end)
	pcall(function()
		player:SetAccountAge(1)
	end)
	player.Idled:connect(onPlayerIdled)

	pcall(function()
		player.Name = [========[_USER_NAME]========]
	end)
	player.CharacterAppearance = "_CHAR_APPEARANCE"
	Visit:SetUploadUrl ""
end)

if not ok then
	reportError(err)
end

pcall(function()
	game:SetScreenshotInfo ""
end)
pcall(function()
	game:SetVideoInfo '<?xml version="1.0"?><entry xmlns="http://w3.org/2005/Atom" xmlns:media="http://search.yahoo.com/mrss/" xmlns:yt="http://gdata.youtube.com/schemas/2007"><media:group><media:title type="plain"><![CDATA[Mercury Place]]></media:title><media:description type="plain"><![CDATA[ For more games visit http://banland.xyz]]></media:description><media:category scheme="http://gdata.youtube.com/schemas/2007/categories.cat">Games</media:category><media:keywords>Mercury, video, free game, online virtual world</media:keywords></media:group></entry>'
end)
-- use single quotes here because the video info string may have unescaped double quotes
