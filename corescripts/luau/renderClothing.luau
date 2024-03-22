--!strict
-- Render script for R6 clothing

local ThumbnailGenerator = game:GetService "ThumbnailGenerator"
local RenderModule = require "../Modules/Render"
local SetupAvatar = require "../Modules/Render/SetupAvatar"
local Render = RenderModule(_BASE_URL, _PING_URL, _THUMBNAIL_KEY) -- avoid ambiguous syntax after compilation

SetupAvatar(
	_BASE_URL,
	_RENDER_TYPE,
	_ASSET_ID,
	"/api/render/characterasset?id="
)

local click = ThumbnailGenerator:Click("PNG", 1680, 1680, true)

print(`[{game.JobId}] Successfully rendered clothing`)

Render.Upload(`Completed\n{click}`)
