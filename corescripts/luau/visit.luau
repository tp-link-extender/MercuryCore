print "[Mercury]: Loaded Visit corescript"

local ChangeHistoryService = game:GetService "ChangeHistoryService"
local InsertService = game:GetService "InsertService"
local Players = game:GetService "Players"
local RunService = game:GetService "RunService"
local ScriptInformationProvider = game:GetService "ScriptInformationProvider"
local SocialService = game:GetService "SocialService"
local ContentProvider = game:GetService "ContentProvider"
local GamePassService = game:GetService "GamePassService"
local Visit = game:GetService "Visit"

local player

-- Prepended to Edit.lua and Visit.lua and Studio.lua and PlaySolo.lua--

pcall(function()
	return game:SetPlaceID(_PLACE_ID)
end)

local message = Instance.new "Message"

message.Parent = workspace
message.archivable = false

ScriptInformationProvider:SetAssetUrl "http://banland.xyz/Asset/"
ContentProvider:SetThreadPool(16)
pcall(function()
	InsertService:SetFreeModelUrl "http://banland.xyz/game/tools/insertasset?type=fm&q=%s&pg=%d&rs=%d"
end) -- Used for free model search (insert tool)
pcall(function()
	InsertService:SetFreeDecalUrl "http://banland.xyz/game/tools/insertasset?type=fd&q=%s&pg=%d&rs=%d"
end) -- Used for free decal search (insert tool)

settings().Diagnostics:LegacyScriptMode()

InsertService:SetBaseSetsUrl "http://banland.xyz/game/tools/insertasset?nsets=10&type=base"
InsertService:SetUserSetsUrl "http://banland.xyz/game/tools/insertasset?nsets=20&type=user&userid=%d"
InsertService:SetCollectionUrl "http://banland.xyz/game/tools/insertasset?sid=%d"
InsertService:SetAssetUrl "http://banland.xyz/asset?id=%d"
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
	game:SetCreatorID(0, Enum.CreatorType.User)
end)

pcall(function()
	game:SetScreenshotInfo ""
end)
pcall(function()
	game:SetVideoInfo ""
end)

pcall(function()
	settings().Rendering.EnableFRM = true
end)
pcall(function()
	settings()["Task Scheduler"].PriorityMethod =
		Enum.PriorityMethod.AccumulatedError
end)

ChangeHistoryService:SetEnabled(false)
pcall(function()
	Players:SetBuildUserPermissionsUrl "http://banland.xyz/Game/BuildActionPermissionCheck.ashx?assetId=0&userId=%d&isSolo=true"
end)

workspace:SetPhysicsThrottleEnabled(true)

local ok, err = pcall(function()
	message.Text = "Loading Game"

	pcall(function()
		Visit:SetUploadUrl ""
	end)

	message.Text = "Running"
	RunService:Run()

	message.Text = "Creating Player"

	player = Players:CreateLocalPlayer(0)

	player.CharacterAppearance = ""
	local propExists, canAutoLoadChar = false, false
	propExists = pcall(function()
		canAutoLoadChar = game.Players.CharacterAutoLoads
	end)

	if (propExists and canAutoLoadChar) or not propExists then
		player:LoadCharacter()
	end

	message.Text = "Setting GUI"
	player:SetSuperSafeChat(true)
	pcall(function()
		player:SetMembershipType(Enum.MembershipType.None)
	end)
	pcall(function()
		player:SetAccountAge(0)
	end)
end)

if ok then
	message.Parent = nil
else
	print(err)

	wait(5)
	message.Text = "Error on visit: " .. err
end
