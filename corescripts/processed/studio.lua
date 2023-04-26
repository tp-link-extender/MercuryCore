print"[Mercury]: Loaded Studio corescript"
do
local _with_0=game:GetService"InsertService"
pcall(function()
return _with_0:SetFreeModelUrl"http://banland.xyz/Game/Tools/InsertAsset.ashx?type=fm&q=%s&pg=%d&rs=%d"
end)
pcall(function()
return _with_0:SetFreeDecalUrl"http://banland.xyz/Game/Tools/InsertAsset.ashx?type=fd&q=%s&pg=%d&rs=%d"
end)
game:GetService"ScriptInformationProvider":SetAssetUrl"http://banland.xyz/Asset/"
_with_0:SetBaseSetsUrl"http://banland.xyz/Game/Tools/InsertAsset.ashx?nsets=10&type=base"
_with_0:SetUserSetsUrl"http://banland.xyz/Game/Tools/InsertAsset.ashx?nsets=20&type=user&userid=%d"
_with_0:SetCollectionUrl"http://banland.xyz/Game/Tools/InsertAsset.ashx?sid=%d"
_with_0:SetAssetUrl"http://banland.xyz/Asset/?id=%d"
_with_0:SetAssetVersionUrl"http://www.roblox.com/Asset/?assetversionid=%d"
_with_0:SetTrustLevel(0)
end
do
local _with_0=game:GetService"SocialService"
pcall(function()
return _with_0:SetFriendUrl"http://banland.xyz/Game/LuaWebService/HandleSocialRequest.ashx?method=IsFriendsWith&playerid=%d&userid=%d"
end)
pcall(function()
return _with_0:SetBestFriendUrl"http://banland.xyz/Game/LuaWebService/HandleSocialRequest.ashx?method=IsBestFriendsWith&playerid=%d&userid=%d"
end)
pcall(function()
return _with_0:SetGroupUrl"http://banland.xyz/Game/LuaWebService/HandleSocialRequest.ashx?method=IsInGroup&playerid=%d&groupid=%d"
end)
pcall(function()
return _with_0:SetGroupRankUrl"http://banland.xyz/Game/LuaWebService/HandleSocialRequest.ashx?method=GetGroupRank&playerid=%d&groupid=%d"
end)
pcall(function()
return _with_0:SetGroupRoleUrl"http://banland.xyz/Game/LuaWebService/HandleSocialRequest.ashx?method=GetGroupRole&playerid=%d&groupid=%d"
end)
end
pcall(function()
return game:GetService"GamePassService":SetPlayerHasPassUrl"http://banland.xyz/Game/GamePass/GamePassHandler.ashx?Action=HasPass&UserID=%d&PassID=%d"
end)
do
local _with_0=game:GetService"MarketplaceService"
pcall(function()
return _with_0:SetProductInfoUrl"https://banland.xyz/marketplace/productinfo?assetId=%d"
end)
pcall(function()
return _with_0:SetDevProductInfoUrl"https://banland.xyz/marketplace/productDetails?productId=%d"
end)
pcall(function()
return _with_0:SetPlayerOwnsAssetUrl"https://banland.xyz/ownership/hasasset?userId=%d&assetId=%d"
end)
end
local result,_
result,_=pcall(function()
return game:GetService"ScriptContext":AddStarterScript(37801172)
end)
if not result then
return pcall(function()
return game:GetService"ScriptContext":AddCoreScript(37801172,game:GetService("ScriptContext","StarterScript"))
end)
end