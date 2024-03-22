--!strict
-- Render script for meshes

local ThumbnailGenerator = game:GetService "ThumbnailGenerator"
local RenderModule = require "../Modules/Render"
local Render = RenderModule(_BASE_URL, _PING_URL, _THUMBNAIL_KEY) -- avoid ambiguous syntax after compilation
local New = (require "../Modules/New").New

print(`[{game.JobId}] Starting new render for {_RENDER_TYPE} Id {_ASSET_ID}`)

New "Part" {
	Parent = workspace,
	New "SpecialMesh" {
		MeshId = `{_BASE_URL}/asset?id={_ASSET_ID}`,
	},
}

local click = ThumbnailGenerator:Click("PNG", 1024, 1024, true)

print(`[{game.JobId}] Successfully rendered mesh`)

Render.Upload(`Completed\n{click}`)
