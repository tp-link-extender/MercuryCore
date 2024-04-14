--!strict
print "[Mercury]: Loaded Studio corescript"

local InsertService = game:GetService "InsertService"
local ScriptInformationProvider =
	game:GetService "ScriptInformationProvider" :: ScriptInformationProvider
local ScriptContext = game:GetService "ScriptContext"

local BaseUrl = require "../Modules/BaseUrl"
local path = BaseUrl.path

pcall(function()
	InsertService:SetFreeModelUrl(
		path "game/tools/insertasset?type=fm&q=%s&pg=%d&rs=%d"
	)
end)
pcall(function()
	InsertService:SetFreeDecalUrl(
		path "game/tools/insertasset?type=fd&q=%s&pg=%d&rs=%d"
	)
end)

ScriptInformationProvider:SetAssetUrl(path "asset/")
InsertService:SetBaseSetsUrl(path "game/tools/insertasset?nsets=10&type=base")
InsertService:SetUserSetsUrl(
	path "game/tools/insertasset?nsets=20&type=user&userid=%d"
)
InsertService:SetCollectionUrl(path "game/tools/insertasset?sid=%d")
InsertService:SetAssetUrl(path "asset?id=%d")
InsertService:SetAssetVersionUrl(path "asset/?assetversionid=%d")
InsertService:SetTrustLevel(0)

if
	not pcall(function()
		print "Adding starter script (1)"
		ScriptContext:AddStarterScript(37801172)
	end)
then
	pcall(function()
		print "Adding starter script (2)"
		ScriptContext:AddCoreScript(37801172, ScriptContext, "StarterScript")
	end)
end
