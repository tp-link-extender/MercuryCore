--!strict

local HttpService = game:GetService "HttpService"
local ScriptContext = game:GetService "ScriptContext"
local ContentProvider = game:GetService "ContentProvider"
local InsertService = game:GetService "InsertService"

local function post(url: string, body: string)
	-- We have to lie about the contentType to avoid being nuked by CORS from the website
	game:HttpPost(url, body, true, "text/json")
end

return function(baseUrl: string, pingUrl: string, thumbnailKey: string)
	local Render = {}

	pcall(function()
		ContentProvider:SetBaseUrl(baseUrl)
		InsertService:SetAssetUrl(`{baseUrl}/asset?id=%d`)
		InsertService:SetAssetVersionUrl(`{baseUrl}/asset?assetversionid=%d`)
	end)

	HttpService.HttpEnabled = true
	ScriptContext.ScriptsDisabled = true

	post(`{pingUrl}/{game.JobId}?apiKey={thumbnailKey}`, "Rendering")

	function Render.Upload(result: string)
		for i = 1, 3 do
			local ok, err = pcall(function()
				post(`{pingUrl}/{game.JobId}?apiKey={thumbnailKey}`, result)
			end)
			if ok then
				print(`[{game.JobId}] Upload successful! Moving on...`)
				break
			elseif i == 3 then
				print(`[{game.JobId}] An error occurred! ({err}). Giving up...`)
				break
			end
			print(
				`[{game.JobId}] An error occurred! ({err}). Uploading again...`
			)
		end
	end

	return Render
end
