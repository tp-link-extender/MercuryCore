local HttpService = game:GetService "HttpService"
local ScriptContext = game:GetService "ScriptContext"
local Players = game:GetService "Players"
local ContentProvider = game:GetService "ContentProvider"
local InsertService = game:GetService "InsertService"

local function post(url: string, body: string)
	-- We have to lie about the contentType to avoid being nuked by CORS from the website
	game:HttpPost(url, body, true, "text/json")
end

return function(baseUrl: string, pingUrl: string, thumbnailKey: string)
	local Render = {}

	function Render.SetupAvatar(
		renderType: string,
		assetId: string,
		characterAppearance: string
	)
		pcall(function()
			ContentProvider:SetBaseUrl(baseUrl)
			InsertService:SetAssetUrl(`{baseUrl}/asset?id=%d`)
			InsertService:SetAssetVersionUrl(
				`{baseUrl}/asset?assetversionid=%d`
			)
		end)

		HttpService.HttpEnabled = true
		ScriptContext.ScriptsDisabled = true

		print(
			`[{game.JobId}] Starting new render for {renderType} ID {assetId}`
		)
		post(
			`{pingUrl}/{game.JobId}?apiKey={thumbnailKey}`,
			"Rendering"
		)

		local player = Players:CreateLocalPlayer(0)
		player.CharacterAppearance = baseUrl .. characterAppearance .. assetId
		player:LoadCharacter(false)

		-- Raise up the character's arm if they have gear.
		local gear = player.Backpack:GetChildren()[1]
		if gear then
			gear.Parent = player.Character
			player.Character.Torso["Right Shoulder"].CurrentAngle = math.rad(90)
		end

		return player
	end

	function Render.Upload(result: string)
		for i = 1, 3 do
			local ok, err = pcall(function()
				post(
					`{pingUrl}/{game.JobId}?apiKey={thumbnailKey}`,
					result
				)
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
