--!strict
-- Render script for R6 avatars

local ThumbnailGenerator =
	game:GetService "ThumbnailGenerator" :: ThumbnailGenerator
local RenderModule = require "../Modules/Render"
local SetupAvatar = require "../Modules/Render/SetupAvatar"
local Render = RenderModule(_BASE_URL, _PING_URL, _THUMBNAIL_KEY) -- avoid ambiguous syntax after compilation
local New = require("../Modules/New").New

local player = SetupAvatar(
	_BASE_URL,
	_RENDER_TYPE,
	_ASSET_ID,
	"/asset/characterfetch?userID="
)

local clickBody = ThumbnailGenerator:Click("PNG", 1680, 1680, true)

print(`[{game.JobId}] Rendered bodyshot`)

player.Character.Torso["Right Shoulder"].CurrentAngle = 0

-- Headshot Camera
local CameraAngle = player.Character.Head.CFrame
local CameraPosition = CameraAngle
	+ CFrame.Angles(0, math.pi, 0).lookVector.Unit * 2.75

workspace.CurrentCamera = New "Camera" {
	Name = "ThumbnailCamera",
	CameraType = Enum.CameraType.Scriptable,
	CoordinateFrame = CFrame.new(CameraPosition.p, CameraAngle.p),
	FieldOfView = 52.5,
	Parent = player.Character,
}

local clickHead = ThumbnailGenerator:Click("PNG", 300, 300, true)

print(`[{game.JobId}] Rendered headshot`)

Render.Upload(`Completed\n{clickBody}\n{clickHead}`)
