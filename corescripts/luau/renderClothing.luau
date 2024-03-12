-- Render script for R6 clothing

local ThumbnailGenerator = game:GetService "ThumbnailGenerator"
local RenderModule = require "../Modules/Render.luau"
local Render = RenderModule(_BASE_URL, _PING_URL, _THUMBNAIL_KEY) -- avoid ambiguous syntax after compilation

Render.SetupAvatar(_RENDER_TYPE, _ASSET_ID, `/api/render/characterasset?id=`)

local click = ThumbnailGenerator:Click("PNG", 1680, 1680, true)

print(`[{game.JobId}] Successfully rendered, moving on...`)

Render.Upload(`Completed\n{click}`)
