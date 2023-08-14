print "[Mercury]: Loaded Studio corescript"
local MarketplaceService = game:GetService "MarketplaceService"
local InsertService = game:GetService "InsertService"
local SocialService = game:GetService "SocialService"
local GamePassService = game:GetService "GamePassService"
local ScriptInformationProvider = game:GetService "ScriptInformationProvider"
local ScriptContext = game:GetService "ScriptContext"
-- Setup studio cmd bar & load core scripts
pcall(function()
	InsertService:SetFreeModelUrl "http://banland.xyz/game/tools/insertasset?type=fm&q=%s&pg=%d&rs=%d"
end)
pcall(function()
	InsertService:SetFreeDecalUrl "http://banland.xyz/game/tools/insertasset?type=fd&q=%s&pg=%d&rs=%d"
end)

ScriptInformationProvider:SetAssetUrl "http://banland.xyz/Asset/"
InsertService:SetBaseSetsUrl "http://banland.xyz/game/tools/insertasset?nsets=10&type=base"
InsertService:SetUserSetsUrl "http://banland.xyz/game/tools/insertasset?nsets=20&type=user&userid=%d"
InsertService:SetCollectionUrl "http://banland.xyz/game/tools/insertasset?sid=%d"
InsertService:SetAssetUrl "http://banland.xyz/Asset/?id=%d"
InsertService:SetAssetVersionUrl "http://banland.xyz/Asset/?assetversionid=%d"
InsertService:SetTrustLevel(0)

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
	MarketplaceService:SetDevProductInfoUrl "https://banland.xyz/marketplace/productDetails?productId=%d"
end)
pcall(function()
	MarketplaceService:SetPlayerOwnsAssetUrl "https://banland.xyz/ownership/hasasset?userId=%d&assetId=%d"
end)

local result, _ = pcall(function()
	ScriptContext:AddStarterScript(37801172)
end)
if not result then
	pcall(function()
		ScriptContext:AddCoreScript(
			37801172,
			game:GetService "ScriptContext",
			"StarterScript"
		)
	end)
end
