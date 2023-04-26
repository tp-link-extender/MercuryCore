print("[Mercury]: Loaded Visit corescript")
if true then
pcall(function()
		return game:SetPlaceID(_PLACE_ID)
	end)
end
local visit = game:GetService("Visit")
local message = Instance.new("Message")
message.Parent = workspace
message.archivable = false
game:GetService("ScriptInformationProvider"):SetAssetUrl("http://banland.xyz/Asset/")
game:GetService("ContentProvider"):SetThreadPool(16)
pcall(function()
	return game:GetService("InsertService"):SetFreeModelUrl("http://www.roblox.com/Game/Tools/InsertAsset.ashx?type=fm&q=%s&pg=%d&rs=%d")
end)
pcall(function()
	return game:GetService("InsertService"):SetFreeDecalUrl("http://www.roblox.com/Game/Tools/InsertAsset.ashx?type=fd&q=%s&pg=%d&rs=%d")
end)
settings().Diagnostics:LegacyScriptMode()
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
	return game:SetCreatorID(0, Enum.CreatorType.User)
end)
pcall(function()
	return game:SetScreenshotInfo("")
end)
pcall(function()
	return game:SetVideoInfo("")
end)
pcall(function()
	settings().Rendering.EnableFRM = true
end)
pcall(function()
	settings()["Task Scheduler"].PriorityMethod = Enum.PriorityMethod.AccumulatedError
end)
game:GetService("ChangeHistoryService"):SetEnabled(false)
pcall(function()
	return game:GetService("Players"):SetBuildUserPermissionsUrl("http://banland.xyz//Game/BuildActionPermissionCheck.ashx?assetId=0&userId=%d&isSolo=true")
end)
workspace:SetPhysicsThrottleEnabled(true)
local addedBuildTools = false
local screenGui = game:GetService("CoreGui"):FindFirstChild("RobloxGui")
local doVisit
doVisit = function()
	message.Text = "Loading Game"
	if false then
		game:Load("")
pcall(function()
			return visit:SetUploadUrl("")
		end)
	else
pcall(function()
			return visit:SetUploadUrl("")
		end)
	end
	message.Text = "Running"
	game:GetService("RunService"):Run()
	message.Text = "Creating Player"
	if false then
		player = game:GetService("Players"):CreateLocalPlayer(1)
		player.Name = [====[Guest _GUEST_NUMBER]====]
	else
		player = game:GetService("Players"):CreateLocalPlayer(0)
	end
	player.CharacterAppearance = ""
	local propExists = false
	local canAutoLoadChar = false
	propExists = pcall(function()
		canAutoLoadChar = game.Players.CharacterAutoLoads
	end)
	if (propExists and canAutoLoadChar) or not propExists then
		player:LoadCharacter()
	end
	message.Text = "Setting GUI"
	player:SetSuperSafeChat(true)
pcall(function()
		return player:SetMembershipType(Enum.MembershipType.None)
	end)
pcall(function()
		return player:SetAccountAge(0)
	end)
	if false then
		message.Text = "Setting Ping"
		visit:SetPing("http://banland.xyz/Game/ClientPresence.ashx?version=old&PlaceID=_PLACE_ID", 300)
		message.Text = "Sending Stats"
		return game:HttpGet("")
	end
end
local success, err = pcall(doVisit)
if not addedBuildTools then
	do
		local _with_0 = Instance.new("StringValue")
		_with_0.Name = "PlayerName"
		_with_0.Value = player.Name
		_with_0.RobloxLocked = true
		_with_0.Parent = screenGui
	end
pcall(function()
		return game:GetService("ScriptContext"):AddCoreScript(59431535, screenGui, "BuildToolsScript")
	end)
	addedBuildTools = true
end
if success then
	message.Parent = nil
else
	print(err)
	if false then
pcall(function()
			return visit:SetUploadUrl("")
		end)
	end
	wait(5)
	message.Text = "Error on visit: " .. tostring(err)
	if false then
		return game:HttpPost("http://banland.xyz/Error/Lua.ashx?", "Visit.lua: " .. tostring(err))
	end
end
