-- Avatar v1.1.0
-- This is the thumbnail script for R6 avatars. Straight up and down, with the right arm out if they have a gear.

local baseUrl: string, thumbnailKey: string, renderType: string, assetId: number =
	...

local ThumbnailGenerator = game:GetService "ThumbnailGenerator"
local ContentProvider = game:GetService "ContentProvider"
local InsertService = game:GetService "InsertService"

pcall(function()
	ContentProvider:SetBaseUrl(baseUrl)
	InsertService:SetAssetUrl(baseUrl .. "/Asset/?id=%d")
	InsertService:SetAssetVersionUrl(baseUrl .. "/Asset/?assetversionid=%d")
end)

game:GetService("HttpService").HttpEnabled = true
game:GetService("ScriptContext").ScriptsDisabled = true

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
		.. "&amp;RenderJobID="
		.. game.JobId,
	'{"Status": 1}',
	true,
	"text/plain",
	true
)

local player = game:GetService("Players"):CreateLocalPlayer(0)
player.CharacterAppearance = baseUrl
	.. "/api/render/characterasset?id="
	.. assetId
player:LoadCharacter(false)

-- Raise up the character's arm if they have gear.
local gear = player.Backpack:GetChildren()[1]
if gear then
	gear.Parent = player.Character
	player.Character.Torso["Right Shoulder"].CurrentAngle = math.rad(90)
end

local click = ThumbnailGenerator:Click("PNG", 1024, 1024, true)

local result = '{"Status": 2, "Click": "' .. tostring(click) .. '"}'
print result
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
			"text/plain"
		)
	end)
	if not ok then
		print(
			"["
				.. game.JobId
				.. "] An error occurred! ("
				.. err
				.. "). Uploading again..."
		)
	else
		print("[" .. game.JobId .. "] Upload successful! Moving on...")
		break
	end
end
