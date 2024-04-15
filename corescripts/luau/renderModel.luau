--!strict
-- Render script for models (and hats)

local ThumbnailGenerator = game:GetService "ThumbnailGenerator"
local RenderModule = require "../Modules/Render"
local Render = RenderModule(_BASE_URL, "_PING_URL", _THUMBNAIL_KEY) -- avoid ambiguous syntax after compilation

print(`[{game.JobId}] Starting new render for {_RENDER_TYPE} Id {_ASSET_ID}`)

for _, object in pairs(game:GetObjects(`{_BASE_URL}/asset?id={_ASSET_ID}`)) do
	pcall(function()
		object.Parent = workspace
	end)
end

local click = ThumbnailGenerator:Click("PNG", 1024, 1024, true, true) -- crop it

print(`[{game.JobId}] Rendered model`)

Render.Upload(`Completed\n{click}`)
