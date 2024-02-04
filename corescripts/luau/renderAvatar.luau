-- Render script for R6 avatars

local ThumbnailGenerator = game:GetService "ThumbnailGenerator"
local Render = require "../Modules/Render.luau"(_BASE_URL, _THUMBNAIL_KEY)

local player =
	Render.SetupAvatar(_RENDER_TYPE, _ASSET_ID, `/asset/characterfetch?userID=`)

local clickBody = ThumbnailGenerator:Click("PNG", 1680, 1680, true)

print(`[{game.JobId}] Rendered bodyshot`)

player.Character.Torso["Right Shoulder"].CurrentAngle = 0

-- Headshot Camera
local CameraAngle = player.Character.Head.CFrame
local CameraPosition = CameraAngle
	+ CFrame.Angles(0, math.pi, 0).lookVector.unit * 2.75

local Camera = Instance.new "Camera"
Camera.Name = "ThumbnailCamera"
Camera.CameraType = Enum.CameraType.Scriptable
Camera.CoordinateFrame = CFrame.new(CameraPosition.p, CameraAngle.p)
Camera.FieldOfView = 52.5
Camera.Parent = player.Character
workspace.CurrentCamera = Camera

local clickHead = ThumbnailGenerator:Click("PNG", 300, 300, true)

print(`[{game.JobId}] Rendered headshot`)

Render.Upload(`Completed\n{clickBody}\n{clickHead}`)
