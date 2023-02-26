import type { RequestHandler } from './$types';
import { SignData } from '$lib/server/sign';

export const GET: RequestHandler = async () => {
    return new Response(
SignData(
`-- functions --------------------------
function onPlayerAdded(player)
-- override
end



-- MultiplayerSharedScript.lua inserted here ------ Prepended to Join.lua --

pcall(function() game:SetPlaceID(${1}, false) end)

-- if we are on a touch device, no blocking http calls allowed! This can cause a crash on iOS
-- In general we need a long term strategy to remove blocking http calls from all platforms
local isTouchDevice = Game:GetService("UserInputService").TouchEnabled

settings()["Game Options"].CollisionSoundEnabled = true
pcall(function() settings().Rendering.EnableFRM = true end)
pcall(function() settings().Physics.Is30FpsThrottleEnabled = false end)
pcall(function() settings()["Task Scheduler"].PriorityMethod = Enum.PriorityMethod.AccumulatedError end)
pcall(function() settings().Physics.PhysicsEnvironmentalThrottle = Enum.EnviromentalPhysicsThrottle.DefaultAuto end)

-- arguments ---------------------------------------
local threadSleepTime = ...

if threadSleepTime==nil then
threadSleepTime = 15
end

local test = ${true}

print("! Joining game '${1}' place ${1} at ${"heliodex.ddns.net"}")

game:GetService("ChangeHistoryService"):SetEnabled(false)
game:GetService("ContentProvider"):SetThreadPool(16)
game:GetService("InsertService"):SetBaseSetsUrl("http://www.roblox.com/Game/Tools/InsertAsset.ashx?nsets=10&type=base")
game:GetService("InsertService"):SetUserSetsUrl("http://www.roblox.com/Game/Tools/InsertAsset.ashx?nsets=20&type=user&userid=%d")
game:GetService("InsertService"):SetCollectionUrl("http://www.roblox.com/Game/Tools/InsertAsset.ashx?sid=%d")
game:GetService("InsertService"):SetAssetUrl("http://banland.xyz/Asset/?id=%d")
game:GetService("InsertService"):SetAssetVersionUrl("http://www.roblox.com/Asset/?assetversionid=%d")

pcall(function() game:GetService("SocialService"):SetFriendUrl("http://banland.xyz/Game/LuaWebService/HandleSocialRequest.ashx?method=IsFriendsWith&playerid=%d&userid=%d") end)
pcall(function() game:GetService("SocialService"):SetBestFriendUrl("http://banland.xyz/Game/LuaWebService/HandleSocialRequest.ashx?method=IsBestFriendsWith&playerid=%d&userid=%d") end)
pcall(function() game:GetService("SocialService"):SetGroupUrl("http://banland.xyz/Game/LuaWebService/HandleSocialRequest.ashx?method=IsInGroup&playerid=%d&groupid=%d") end)
pcall(function() game:GetService("SocialService"):SetGroupRankUrl("http://banland.xyz/Game/LuaWebService/HandleSocialRequest.ashx?method=GetGroupRank&playerid=%d&groupid=%d") end)
pcall(function() game:GetService("SocialService"):SetGroupRoleUrl("http://banland.xyz/Game/LuaWebService/HandleSocialRequest.ashx?method=GetGroupRole&playerid=%d&groupid=%d") end)
pcall(function() game:GetService("GamePassService"):SetPlayerHasPassUrl("http://banland.xyz/Game/GamePass/GamePassHandler.ashx?Action=HasPass&UserID=%d&PassID=%d") end)
pcall(function() game:GetService("MarketplaceService"):SetProductInfoUrl("https://banland.xyz/marketplace/productinfo?assetId=%d") end)
pcall(function() game:GetService("MarketplaceService"):SetPlayerOwnsAssetUrl("https://banland.xyz/ownership/hasasset?userId=%d&assetId=%d") end)
pcall(function() game:SetCreatorID(<?=$CreatorID?>, Enum.CreatorType.User) end)

-- Bubble chat.  This is all-encapsulated to allow us to turn it off with a config setting
pcall(function() game:GetService("Players"):SetChatStyle(Enum.ChatStyle.<?=$ChatStyle?>) end)

local waitingForCharacter = false
pcall( function()
if settings().Network.MtuOverride == 0 then
settings().Network.MtuOverride = 1400
end
end)


-- globals -----------------------------------------

client = game:GetService("NetworkClient")
visit = game:GetService("Visit")

-- functions ---------------------------------------
function setMessage(message)
-- todo: animated "..."
if not ${false} then
game:SetMessage(message)
else
-- hack, good enought for now
game:SetMessage("Teleporting ...")
end
end

function showErrorWindow(message, errorType, errorCategory)
game:SetMessage(message)
end

function reportError(err, message)
print("***ERROR*** " .. err)
if not test then visit:SetUploadUrl("") end
client:Disconnect()
wait(4)
showErrorWindow("Error: " .. err, message, "Other")
end

-- called when the client connection closes
function onDisconnection(peer, lostConnection)
if lostConnection then
showErrorWindow("You have lost the connection to the game", "LostConnection", "LostConnection")
else
showErrorWindow("This game has shut down", "Kick", "Kick")
end
end

function requestCharacter(replicator)

-- prepare code for when the Character appears
local connection
connection = player.Changed:connect(function (property)
if property=="Character" then
game:ClearMessage()
waitingForCharacter = false
connection:disconnect()
end
end)

setMessage("Requesting character")

local success, err = pcall(function()	
replicator:RequestCharacter()
setMessage("Waiting for character")
waitingForCharacter = true
end)

if not success then
reportError(err,"W4C")
return
end
end

-- called when the client connection is established
function onConnectionAccepted(url, replicator)
connectResolved = true

local waitingForMarker = true

local success, err = pcall(function()	
if not test then 
visit:SetPing("${"https://banland.xyz"}", 30) 
end

if not ${false} then
game:SetMessageBrickCount()
else
setMessage("Teleporting ...")
end

replicator.Disconnection:connect(onDisconnection)

-- Wait for a marker to return before creating the Player
local marker = replicator:SendMarker()

marker.Received:connect(function()
waitingForMarker = false
requestCharacter(replicator)
end)
end)

if not success then
reportError(err,"ConnectionAccepted")
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
showErrorWindow("Failed to connect to the Game. (ID=" .. error .. ")", "ID" .. error, "Other")
end

-- called when the client connection is rejected
function onConnectionRejected()
connectionFailed:disconnect()
showErrorWindow("This game is not available. Please try another", "WrongVersion", "WrongVersion")
end

idled = false
function onPlayerIdled(time)
if time > 20*60 then
showErrorWindow(string.format("You were disconnected for being idle %d minutes", time/60), "Idle", "Idle")
client:Disconnect()
if not idled then
idled = true
end
end
end


-- main ------------------------------------------------------------

pcall(function() settings().Diagnostics:LegacyScriptMode() end)
local success, err = pcall(function()	

game:SetRemoteBuildMode(true)

setMessage("Connecting to Server")
client.ConnectionAccepted:connect(onConnectionAccepted)
client.ConnectionRejected:connect(onConnectionRejected)
connectionFailed = client.ConnectionFailed:connect(onConnectionFailed)
client.Ticket = ""	

playerConnectSucces, player = pcall(function() return client:PlayerConnect(${1}, "${"127.0.0.1"}", ${53640}, 0, threadSleepTime) end)
if not playerConnectSucces then
--Old player connection scheme
player = game:GetService("Players"):CreateLocalPlayer(${1})
client:Connect("${"heliodex.ddns.net"}", ${53640}, 0, threadSleepTime)
end

-- negotiate an auth token
if not test then
delay(300, function()
while false do
pcall(function() game:HttpPost("https://banland.xyz/auth/renew", "renew") end)
wait(300)
end
end)
end

player:SetSuperSafeChat(${false})
pcall(function() player:SetUnder13(${false}) end)
pcall(function() player:SetMembershipType(Enum.MembershipType.${1}) end)
pcall(function() player:SetAccountAge(${1}) end)
player.Idled:connect(onPlayerIdled)

-- Overriden
onPlayerAdded(player)

pcall(function() player.Name = [========[${"Mercury 2"}]========] end)
player.CharacterAppearance = ""	
if not test then visit:SetUploadUrl("") end		
end)

if not success then
reportError(err,"CreatePlayer")
end

if not test then
-- TODO: Async get?
loadfile("")("", -1, 0)
end

pcall(function() game:SetScreenshotInfo("") end)
pcall(function() game:SetVideoInfo('<?xml version="1.0"?><entry xmlns="http://www.w3.org/2005/Atom" xmlns:media="http://search.yahoo.com/mrss/" xmlns:yt="http://gdata.youtube.com/schemas/2007"><media:group><media:title type="plain"><![CDATA[ROBLOX Place]]></media:title><media:description type="plain"><![CDATA[ For more games visit http://www.roblox.com]]></media:description><media:category scheme="http://gdata.youtube.com/schemas/2007/categories.cat">Games</media:category><media:keywords>ROBLOX, video, free game, online virtual world</media:keywords></media:group></entry>') end)
-- use single quotes here because the video info string may have unescaped double quotes`
    ));
};