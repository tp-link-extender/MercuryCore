--!strict
print "[Mercury]: Loaded Studio corescript"

local InsertService = game:GetService "InsertService"
local ScriptInformationProvider = game:GetService "ScriptInformationProvider"
local ScriptContext = game:GetService "ScriptContext"

pcall(function()
	InsertService:SetFreeModelUrl "http://banland.xyz/game/tools/insertasset?type=fm&q=%s&pg=%d&rs=%d"
end)
pcall(function()
	InsertService:SetFreeDecalUrl "http://banland.xyz/game/tools/insertasset?type=fd&q=%s&pg=%d&rs=%d"
end)

ScriptInformationProvider:SetAssetUrl "http://banland.xyz/asset/"
InsertService:SetBaseSetsUrl "http://banland.xyz/game/tools/insertasset?nsets=10&type=base"
InsertService:SetUserSetsUrl "http://banland.xyz/game/tools/insertasset?nsets=20&type=user&userid=%d"
InsertService:SetCollectionUrl "http://banland.xyz/game/tools/insertasset?sid=%d"
InsertService:SetAssetUrl "http://banland.xyz/asset?id=%d"
InsertService:SetAssetVersionUrl "http://banland.xyz/asset/?assetversionid=%d"
InsertService:SetTrustLevel(0)

if not pcall(function()
	ScriptContext:AddStarterScript(37801172)
end) then
	pcall(function()
		ScriptContext:AddCoreScript(37801172, ScriptContext, "StarterScript")
	end)
end
