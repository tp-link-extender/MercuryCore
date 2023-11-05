-- Avatar v1.1.0
-- This is the thumbnail script for R6 avatars. Straight up and down, with the right arm out if they have a gear.

local baseUrl = _BASE_URL
local thumbnailKey = _THUMBNAIL_KEY
local renderType = _RENDER_TYPE
local assetId = _ASSET_ID

local ThumbnailGenerator = game:GetService "ThumbnailGenerator"
local ContentProvider = game:GetService "ContentProvider"
local InsertService = game:GetService "InsertService"
local HttpService = game:GetService "HttpService"
local ScriptContext = game:GetService "ScriptContext"

pcall(function()
	ContentProvider:SetBaseUrl(baseUrl)
	InsertService:SetAssetUrl(baseUrl .. "/asset?id=%d")
	InsertService:SetAssetVersionUrl(baseUrl .. "/asset?assetversionid=%d")
end)

HttpService.HttpEnabled = true
ScriptContext.ScriptsDisabled = true

print(
	"["
		.. game.JobId
		.. "] Starting new render for "
		.. renderType
		.. " ID "
		.. assetId
)
game:HttpPost(
	baseUrl
		.. "/api/render/update?apiKey="
		.. thumbnailKey
		.. "&amp;taskID="
		.. game.JobId,
	'{"Status": "Rendering"}',
	true,
	"text/json"
)

local player = game:GetService("Players"):CreateLocalPlayer(0)
player.CharacterAppearance = baseUrl
	.. "/api/render/characterasset?id="
	.. assetId
	.. "&amp;apiKey="
	.. thumbnailKey
player:LoadCharacter(false)

-- Raise up the character's arm if they have gear.
local gear = player.Backpack:GetChildren()[1]
if gear then
	gear.Parent = player.Character
	player.Character.Torso["Right Shoulder"].CurrentAngle = math.rad(90)
end

local click = ThumbnailGenerator:Click("PNG", 420, 420, true)

local result = '{"Status": "Completed", "Click": "' .. tostring(click) .. '"}'
print("[" .. game.JobId .. "] Successfully rendered, moving on...")

while true do
	local ok, err = pcall(function()
		game:HttpPost(
			baseUrl
				.. "/api/render/update?apiKey="
				.. thumbnailKey
				.. "&amp;taskID="
				.. game.JobId,
			result,
			true,
			"text/json"
		)
	end)
	if ok then
		print("[" .. game.JobId .. "] Upload successful! Moving on...")
		break
	end
	print(
		"["
			.. game.JobId
			.. "] An error occurred! ("
			.. err
			.. "). Uploading again..."
	)
end
