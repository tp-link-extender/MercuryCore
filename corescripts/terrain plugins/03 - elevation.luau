while not game do
	wait()
end

local ChangeHistoryService = game:GetService "ChangeHistoryService"
local CoreGui = game:GetService "CoreGui"

local CreateStandardLabel = require "../Modules/Terrain/CreateStandardLabel"
local New = require("../Modules/New").New

---------------
--PLUGIN SETUP-
---------------
local loaded = false
-- True if the plugin is on, false if not.
local on = false

local On, Off

local plugin = PluginManager():CreatePlugin()
local mouse = plugin:GetMouse()

local toolbar = plugin:CreateToolbar "Terrain"
local toolbarbutton = toolbar:CreateButton(
	"Elevation Adjuster",
	"Elevation Adjuster",
	"elevation.png"
)
toolbarbutton.Click:connect(function()
	if on then
		Off()
	elseif loaded then
		On()
	end
end)

game:WaitForChild "Workspace"
workspace:WaitForChild "Terrain"

local c = workspace.Terrain
local SetCell = c.SetCell
local SetWaterCell = c.SetWaterCell
local GetCell = c.GetCell
local GetWaterCell = c.GetWaterCell
local WorldToCellPreferSolid = c.WorldToCellPreferSolid
local WorldToCellPreferEmpty = c.WorldToCellPreferEmpty
local CellCenterToWorld = c.CellCenterToWorld
local AutoWedge = c.AutowedgeCell

-----------------
--DEFAULT VALUES-
-----------------
-- The ID number that represents water.
local waterMaterialID = 17

-- Elevation related options.  Contains everything needed for making the elevation.
local elevationOptions = {
	r = 0, -- Radius of the elevation area.  The larger it is, the wider the top of the elevation will be.
	s = 1, -- Slope of the elevation area.  The larger it is, the steeper the slope.
	defaultTerrainMaterial = 1, -- The material that the elevation should be made of.
	waterForce = nil, -- What force the material has if it is water.
	waterDirection = nil, -- What direction the material has if it is water.
	autowedge = true, -- Whether smoothing should be applied.  True if it should, false if not.
}

-- What color to use for the mouse highlighter.
local mouseHighlightColor = BrickColor.new "Lime green"

-- Do a line/plane intersection.  The line starts at the camera.  The plane is at y == 0, normal(0, 1, 0)
--
-- vectorPos - End point of the line.
--
-- Return:
-- success - Value is true if there was a plane intersection, false if not.
-- cellPos - Value is the terrain cell intersection point if there is one, vectorPos if there isn't.
local function PlaneIntersection(vectorPos)
	local currCamera = workspace.CurrentCamera
	local startPos = Vector3.new(
		currCamera.CoordinateFrame.p.X,
		currCamera.CoordinateFrame.p.Y,
		currCamera.CoordinateFrame.p.Z
	)
	local endPos = Vector3.new(vectorPos.X, vectorPos.Y, vectorPos.Z)
	local normal = Vector3.new(0, 1, 0)
	local p3 = Vector3.new(0, 0, 0)
	local startEndDot = normal:Dot(endPos - startPos)
	local cellPos = vectorPos
	local success = false

	if startEndDot ~= 0 then
		local t = normal:Dot(p3 - startPos) / startEndDot
		if t >= 0 and t <= 1 then
			local intersection = ((endPos - startPos) * t) + startPos
			cellPos = c:WorldToCell(intersection)
			success = true
		end
	end

	return success, cellPos
end

-- Used to create a highlighter that follows the mouse.
-- It is a class mouse highlighter.  To use, call MouseHighlighter.Create(mouse) where mouse is the mouse to track.
local MouseHighlighter = {}
MouseHighlighter.__index = MouseHighlighter

-- Create a mouse movement highlighter.
-- plugin - Plugin to get the mouse from.
function MouseHighlighter.Create(mouseUse)
	local highlighter = {}

	local mouseH = mouseUse
	highlighter.OnClicked = nil
	highlighter.mouseDown = false

	-- Store the last point used to draw.
	highlighter.lastUsedPoint = nil

	-- Will hold a part the highlighter will be attached to.  This will be moved where the mouse is.
	highlighter.selectionPart = nil

	-- Update where the highlighter is displayed.
	-- position - Where to display the highlighter, in world space.
	local function UpdatePosition(position)
		if not position then
			return
		end

		-- NOTE:
		-- Change this gui to be the one you want to use.
		highlighter.selectionBox.Parent = CoreGui

		local vectorPos = Vector3.new(position.x, position.y, position.z)
		local cellPos = WorldToCellPreferEmpty(c, vectorPos)
		local solidCell = WorldToCellPreferSolid(c, vectorPos)
		local success = false

		-- If nothing was hit, do the plane intersection.
		if 0 == GetCell(c, solidCell.X, solidCell.Y, solidCell.Z).Value then
			success, cellPos = PlaneIntersection(vectorPos)
			if not success then
				cellPos = solidCell
			end
		else
			highlighter.lastUsedPoint = cellPos
		end

		local regionToSelect

		local lowVec = CellCenterToWorld(c, cellPos.x, cellPos.y - 1, cellPos.z)
		local highVec =
			CellCenterToWorld(c, cellPos.x, cellPos.y + 1, cellPos.z)
		regionToSelect = Region3.new(lowVec, highVec)

		highlighter.selectionPart.Size = regionToSelect.Size
			- Vector3.new(-4, 4, -4)
		highlighter.selectionPart.CFrame = regionToSelect.CFrame

		if nil ~= highlighter.OnClicked and highlighter.mouseDown then
			if nil == highlighter.lastUsedPoint then
				highlighter.lastUsedPoint = WorldToCellPreferEmpty(
					c,
					Vector3.new(mouseH.Hit.x, mouseH.Hit.y, mouseH.Hit.z)
				)
			else
				cellPos = WorldToCellPreferEmpty(
					c,
					Vector3.new(mouseH.Hit.x, mouseH.Hit.y, mouseH.Hit.z)
				)
			end
		end
	end

	-- Function to call when the mouse has moved.  Updates where to display the highlighter.
	local function MouseMoved()
		if on then
			UpdatePosition(mouseH.Hit)
		end
	end

	-- Hook the mouse up to check for movement.
	mouseH.Move:connect(function()
		MouseMoved()
	end)

	mouseH.Button1Down:connect(function()
		highlighter.mouseDown = true
	end)
	mouseH.Button1Up:connect(function()
		highlighter.mouseDown = false
	end)

	-- Create the part that the highlighter will be attached to.
	highlighter.selectionPart = New "Part" {
		Name = "SelectionPart",
		Archivable = false,
		Transparency = 1,
		Anchored = true,
		Locked = true,
		CanCollide = false,
		FormFactor = Enum.FormFactor.Custom,
	}
	highlighter.selectionBox = New "SelectionBox" {
		Archivable = false,
		Color = mouseHighlightColor,
		Adornee = highlighter.selectionPart,
	}
	mouseH.TargetFilter = highlighter.selectionPart
	setmetatable(highlighter, MouseHighlighter)

	return highlighter
end

-- Hide the highlighter.
function MouseHighlighter:DisablePreview()
	self.selectionBox.Parent = nil
end

-- Show the highlighter.
function MouseHighlighter:EnablePreview()
	self.selectionBox.Parent = CoreGui -- This will make it not show up in workspace.
end

-- Create the mouse movement highlighter.
local mouseHighlighter = MouseHighlighter.Create(mouse)

------
--GUI-
------
--screengui
local g = Instance.new "ScreenGui"
g.Name = "ElevationGui"
g.Parent = CoreGui

-- UI gui load.  Required for sliders.
local RbxGui = LoadLibrary "RbxGui"

-- Create a standardized slider.
-- name  - Name to use for the slider.
-- pos   - Position to display the slider at.
-- steps - How many steps there are in the slider.
-- funcOnChange - Function to call when the slider changes.
-- initValue    - Initial value to set the slider to.  If nil the slider stays at the default.
-- parent       - What to set as the parent.
-- Return:
-- sliderGui      - Slider gui object.
-- sliderPosition - Object that can set the slider value.
function CreateStandardSlider(
	name,
	pos,
	lengthBarPos,
	steps,
	funcOnChange,
	initValue,
	parent
)
	local sliderGui, sliderPosition =
		RbxGui.CreateSlider(steps, 0, UDim2.new(0, 0, 0, 0))

	sliderGui.Name = name
	sliderGui.Parent = parent
	sliderGui.Position = pos
	sliderGui.Size = UDim2.new(1, 0, 0, 20)
	local lengthBar = sliderGui:FindFirstChild "Bar"
	lengthBar.Size = UDim2.new(1, -20, 0, 5)
	lengthBar.Position = lengthBarPos

	if nil ~= funcOnChange then
		sliderPosition.Changed:connect(function()
			funcOnChange(sliderPosition)
		end)
	end

	if nil ~= initValue then
		sliderPosition.Value = initValue
	end

	return sliderGui, sliderPosition
end

-- Gui frame for the plugin.
local elevationPropertiesDragBar, elevationFrame, elevationHelpFrame, elevationCloseEvent =
	RbxGui.CreatePluginFrame(
		"Elevation Adjuster",
		UDim2.new(0, 185, 0, 100),
		UDim2.new(0, 0, 0, 0),
		false,
		g
	)
elevationPropertiesDragBar.Visible = false
elevationCloseEvent.Event:connect(function()
	Off()
end)

elevationHelpFrame.Size = UDim2.new(0, 300, 0, 130)

local helpText = [[
Use to drag terrain up or down.  Hold the left mouse button down and drag the mouse up or down to create a mountain or valley.

Radius:
The larger it is, the wider the top of the elevation will be.

Slope:
The larger it is, the steeper the slope.]]

New "TextLabel" {
	Name = "HelpText",
	Font = Enum.Font.ArialBold,
	FontSize = Enum.FontSize.Size12,
	TextColor3 = Color3.new(227 / 255, 227 / 255, 227 / 255),
	TextXAlignment = Enum.TextXAlignment.Left,
	TextYAlignment = Enum.TextYAlignment.Top,
	Position = UDim2.new(0, 4, 0, 4),
	Size = UDim2.new(1, -8, 0, 177),
	BackgroundTransparency = 1,
	TextWrapped = true,
	Text = helpText,
	Parent = elevationHelpFrame,
}

-- Slider for controlling radius.
local radiusLabel = CreateStandardLabel(
	"RadiusLabel",
	UDim2.new(0, 8, 0, 10),
	UDim2.new(0, 67, 0, 14),
	"",
	elevationFrame
)
local _, radiusSliderPosition = CreateStandardSlider(
	"radiusSliderGui",
	UDim2.new(0, 1, 0, 26),
	UDim2.new(0, 10, 0.5, -2),
	11,
	function(radiusSliderPosition2)
		elevationOptions.r = radiusSliderPosition2.Value -- 1
		radiusLabel.Text = "Radius: " .. elevationOptions.r
	end,
	nil,
	elevationFrame
)
radiusSliderPosition.Value = 1

-- Slider for controlling the z offset to generate terrain at.
local slopeLabel = CreateStandardLabel(
	"SlopeLabel",
	UDim2.new(0, 8, 0, 51),
	UDim2.new(0, 67, 0, 14),
	"",
	elevationFrame
)
local _, slopeSliderPosition
_, slopeSliderPosition = CreateStandardSlider(
	"slopeSliderGui",
	UDim2.new(0, 1, 0, 67),
	UDim2.new(0, 10, 0.5, -2),
	16,
	function()
		elevationOptions.s = slopeSliderPosition.Value / 10 + 0.4
		slopeLabel.Text = "Slope: " .. elevationOptions.s
	end,
	nil,
	elevationFrame
)
slopeSliderPosition.Value = 1

-----------------------
--FUNCTION DEFINITIONS-
-----------------------

--find height at coordinate x, z
function findHeight(x, z)
	local h = 0
	local material, _, _ = GetCell(c, x, h + 1, z)
	while material.Value > 0 do
		h = h + 1
		material, _, _ = GetCell(c, x, h + 1, z)
	end
	return h
end

--makes a shell around block at coordinate x, z using heightmap
function makeShell(x, z, heightmap, shellheightmap)
	local originalheight = heightmap[x][z]
	for i = x - 1, x + 1 do
		for k = z - 1, z + 1 do
			if shellheightmap[i][k] < originalheight then
				for h = originalheight, shellheightmap[i][k] - 2, -1 do
					if h > 0 then
						if
							waterMaterialID
							== elevationOptions.defaultTerrainMaterial
						then
							SetWaterCell(
								c,
								i,
								h,
								k,
								elevationOptions.waterForce,
								elevationOptions.waterDirection
							)
						else
							SetCell(
								c,
								i,
								h,
								k,
								elevationOptions.defaultTerrainMaterial,
								0,
								0
							)
						end
					end
				end
				shellheightmap[i][k] = originalheight
			end
		end
	end
	return shellheightmap
end

local height

local oldheightmap = {}
local heightmap = {}

local function dist(x1, y1, x2, y2)
	return math.sqrt(math.pow(x2 - x1, 2) + math.pow(y2 - y1, 2))
end

-- elevates terrain at point (x, y, z) in cluster c
-- within radius r1 from x, z the elevation should become y + d
-- from radius r1 to r2 the elevation should be a gradient
local function elevate(x, y, z, r1, r2, d, range)
	for i = x - (range + 2), x + (range + 2) do
		if oldheightmap[i] == nil then
			oldheightmap[i] = {}
		end
		for k = z - (range + 2), z + (range + 2) do
			if oldheightmap[i][k] == nil then
				oldheightmap[i][k] = findHeight(i, k)
			end

			--figure out the height to make coordinate (i, k)
			local distance = dist(i, k, x, z)
			if distance < r1 then
				height = y + d
			elseif distance < r2 then
				height = math.floor(
					(y + d) * (1 - (distance - r1) / (r2 - r1))
						+ oldheightmap[i][k] * (distance - r1) / (r2 - r1)
				)
			else
				height = oldheightmap[i][k]
			end
			if height == 0 then
				height = -1
			end

			--heightmap[i][k] should be the current height of coordinate (i, k)
			if heightmap[i] == nil then
				heightmap[i] = {}
			end
			if heightmap[i][k] == nil then
				heightmap[i][k] = oldheightmap[i][k]
			end

			--the height is either greater than or less than the current height
			if height > heightmap[i][k] then
				for h = heightmap[i][k] - 2, height do
					SetCell(
						c,
						i,
						h,
						k,
						elevationOptions.defaultTerrainMaterial,
						0,
						0
					)
				end
				heightmap[i][k] = height
			elseif height < heightmap[i][k] then
				for h = heightmap[i][k], height + 1, -1 do
					SetCell(c, i, h, k, 0, 0, 0)
				end
				heightmap[i][k] = height
			end
		end
	end

	--copy heightmap into shellheightmap
	local shellheightmap = {}
	for i = x - (range + 2), x + (range + 2) do
		if shellheightmap[i] == nil then
			shellheightmap[i] = {}
		end
		for k = z - (range + 2), z + (range + 2) do
			shellheightmap[i][k] = heightmap[i][k]
		end
	end
	--shell everything
	for i = x - range, x + range do
		for k = z - range, z + range do
			if shellheightmap[i][k] ~= oldheightmap[i][k] then
				shellheightmap = makeShell(i, k, heightmap, shellheightmap)
			end
		end
	end

	for i = x - (range + 2), x + (range + 2) do
		for k = z - (range + 2), z + (range + 2) do
			heightmap[i][k] = shellheightmap[i][k]
		end
	end

	for k = z - (range + 1), z + (range + 1) do
		for i = x - (range + 1), x + (range + 1) do
			local height2 = heightmap[i][k]
			if height2 == nil then
				height2 = -1
			end

			-- Autowedge if enabled.
			if elevationOptions.autowedge then
				for h = height2, 1, -1 do
					if not AutoWedge(c, i, h, k) then
						break
					end
				end
			end
		end
	end
end

-- function dist3d(x1, y1, z1, x2, y2, z2)
-- 	return math.sqrt(math.pow(dist(x1, z1, x2, z2), 2) + math.pow(math.abs(y2 - y1) * 100 / d, 2))
-- end

local mousedown = false

-- Run when the mouse gets clicked.  If the click is on terrain, then it will be used as the starting point of the elevation area.
local function onClicked()
	if on then
		oldheightmap = {}
		heightmap = {}
		local cellPos = WorldToCellPreferEmpty(
			c,
			Vector3.new(mouse.Hit.x, mouse.Hit.y, mouse.Hit.z)
		)

		local solidCell = WorldToCellPreferSolid(
			c,
			Vector3.new(mouse.Hit.x, mouse.Hit.y, mouse.Hit.z)
		)
		local success = false

		-- If nothing was hit, do the plane intersection.
		if 0 == GetCell(c, solidCell.X, solidCell.Y, solidCell.Z).Value then
			--print('Plane Intersection happens')
			success, cellPos = PlaneIntersection(
				Vector3.new(mouse.Hit.x, mouse.Hit.y, mouse.Hit.z)
			)
			if not success then
				cellPos = solidCell
			end
		end

		local x = cellPos.X
		local y = cellPos.Y
		local z = cellPos.Z

		local celMat = GetCell(c, x, y, z)
		if celMat.Value > 0 then
			elevationOptions.defaultTerrainMaterial = celMat.Value
			_, elevationOptions.waterForce, elevationOptions.waterDirection =
				GetWaterCell(c, cellPos.X, cellPos.Y, cellPos.Z)
		else
			if 0 == elevationOptions.defaultTerrainMaterial then
				-- It was nothing, give it a default type and the plane intersection.
				elevationOptions.isWater = false
				elevationOptions.defaultTerrainMaterial = 1
			end
		end

		-- Hide the selection area while dragging.
		mouseHighlighter:DisablePreview()

		mousedown = true
		local originalY = mouse.Y
		local prevY = originalY
		local d = 0
		local range = 0
		while mousedown == true do
			if math.abs(mouse.Y - prevY) >= 5 then
				prevY = mouse.Y
				local r2 = elevationOptions.r
					+ math.floor(
						50
							* 1
							/ elevationOptions.s
							* math.abs(originalY - prevY)
							/ mouse.ViewSizeY
					)
				if r2 > range then
					range = r2
				end
				d = math.floor(50 * (originalY - prevY) / mouse.ViewSizeY)
				elevate(x, y, z, elevationOptions.r, r2, d, range)
			end
			wait()
		end
		ChangeHistoryService:SetWaypoint "Elevation"
	end
end

mouse.Button1Down:connect(onClicked)

mouseHighlighter.OnClicked = onClicked
mouse = plugin:GetMouse()
mouse.Button1Up:connect(function()
	mousedown = false
	mouseHighlighter:EnablePreview()
end)

-- Run when the popup is activated.
function On()
	if not c then
		return
	end
	plugin:Activate(true)
	toolbarbutton:SetActive(true)
	elevationPropertiesDragBar.Visible = true

	on = true
end

-- Run when the popup is deactivated.
function Off()
	toolbarbutton:SetActive(false)
	on = false

	-- Hide the popup gui.
	elevationPropertiesDragBar.Visible = false
	mouseHighlighter:DisablePreview()
end

plugin.Deactivation:connect(function()
	Off()
end)

loaded = true
