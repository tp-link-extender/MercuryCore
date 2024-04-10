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
local toolbarbutton = toolbar:CreateButton("Builder", "Builder", "builder.png")
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
local GetCell = c.GetCell
local WorldToCellPreferSolid = c.WorldToCellPreferSolid
local CellCenterToWorld = c.CellCenterToWorld
local AutoWedge = c.AutowedgeCells
local WorldToCellPreferEmpty = c.WorldToCellPreferEmpty
local GetWaterCell = c.GetWaterCell
local SetWaterCell = c.SetWaterCell

-----------------
--DEFAULT VALUES-
-----------------

-- Stores selection properties.
local selectionProps = {
	isWater = nil, -- True if what will be built is water.
	waterForce = nil, -- Water force.
	waterDirection = nil, -- Water direction.
	terrainMaterial = 0, -- Terrain material to use
}

-- What color to use for the mouse highlighter.
local mouseHighlightColor = BrickColor.new "Lime green"

-- Used to create a highlighter that follows the mouse.
-- It is a class mouse highlighter.  To use, call MouseHighlighter.Create(mouse) where mouse is the mouse to track.
local MouseHighlighter = {}
MouseHighlighter.__index = MouseHighlighter

local PlaneIntersection, UpdatePosition

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

	-- Do a line/plane intersection.  The line starts at the camera.  The plane is at y == 0, normal(0, 1, 0)
	--
	-- vectorPos - End point of the line.
	--
	-- Return:
	-- success - Value is true if there was a plane intersection, false if not.
	-- cellPos - Value is the terrain cell intersection point if there is one, vectorPos if there isn't.
	function PlaneIntersection(vectorPos)
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

	-- Update where the highlighter is displayed.
	-- position - Where to display the highlighter, in world space.
	function UpdatePosition(position)
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
mouseHighlighter:DisablePreview()

------
--GUI-
------
--screengui
local g = Instance.new "ScreenGui"
g.Name = "BuilderGui"
g.Parent = CoreGui

-- UI gui load.  Required for sliders.
local RbxGui = LoadLibrary "RbxGui"

-- Store properties here.
local properties = { autoWedgeEnabled = false }

-- Gui frame for the plugin.
local builderPropertiesDragBar, builderFrame, builderHelpFrame, builderCloseEvent =
	RbxGui.CreatePluginFrame(
		"Builder",
		UDim2.new(0, 123, 0, 40),
		UDim2.new(0, 0, 0, 0),
		false,
		g
	)
builderPropertiesDragBar.Visible = false
builderCloseEvent.Event:connect(function()
	Off()
end)

builderHelpFrame.Size = UDim2.new(0, 160, 0, 85)

local helpText = [[
Clicking terrain adds a single block into the selection box shown. The terrain material and type will be the same as the cell that was clicked on.]]

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
	Parent = builderHelpFrame,
}

CreateStandardLabel(
	"AddText",
	UDim2.new(0, 8, 0, 10),
	UDim2.new(0, 67, 0, 14),
	"Click to add terrain.",
	builderFrame
)

-- Function to connect to the mouse button 1 down event.  This is what will run when the user clicks.
-- Adding and autowedging done here.
-- mouse 	- Mouse data.
local function onClicked()
	if not on then
		return
	end

	local cellPos = WorldToCellPreferEmpty(
		c,
		Vector3.new(mouse.Hit.x, mouse.Hit.y, mouse.Hit.z)
	)
	local x = cellPos.x
	local y = cellPos.y
	local z = cellPos.z

	local solidCellPos = WorldToCellPreferSolid(
		c,
		Vector3.new(mouse.Hit.x, mouse.Hit.y, mouse.Hit.z)
	)

	local celMat = GetCell(c, solidCellPos.x, solidCellPos.y, solidCellPos.z)
	local success = false

	if celMat.Value > 0 then
		selectionProps.terrainMaterial = celMat.Value
		selectionProps.isWater, selectionProps.waterForce, selectionProps.waterDirection =
			GetWaterCell(c, solidCellPos.X, solidCellPos.Y, solidCellPos.Z)
	else
		if 0 == selectionProps.terrainMaterial then
			-- It was nothing, give it a default type and the plane intersection.
			selectionProps.isWater = false
			selectionProps.terrainMaterial = 1
		end

		success, cellPos = PlaneIntersection(
			Vector3.new(mouse.Hit.x, mouse.Hit.y, mouse.Hit.z)
		)
		if not success then
			cellPos = solidCellPos
		end

		x = cellPos.x
		y = cellPos.y
		z = cellPos.z
	end

	if selectionProps.isWater and 17 == selectionProps.terrainMaterial then
		SetWaterCell(
			c,
			x,
			y,
			z,
			selectionProps.waterForce,
			selectionProps.waterDirection
		)
	else
		SetCell(c, x, y, z, selectionProps.terrainMaterial, 0, 0)
	end

	if properties.autoWedgeEnabled then
		AutoWedge(
			c,
			Region3int16.new(
				Vector3int16.new(x - 1, y - 1, z - 1),
				Vector3int16.new(x + 1, y + 1, z + 1)
			)
		)
	end

	-- Mark undo point.
	ChangeHistoryService:SetWaypoint "Builder"

	UpdatePosition(mouse.Hit)
end

mouse.Button1Down:connect(onClicked)

mouseHighlighter.OnClicked = onClicked

-- Run when the popup is activated.
function On()
	if not c then
		return
	end
	plugin:Activate(true)
	toolbarbutton:SetActive(true)
	builderPropertiesDragBar.Visible = true
	on = true
end

-- Run when the popup is deactivated.
function Off()
	toolbarbutton:SetActive(false)
	on = false

	-- Hide the popup gui.
	builderPropertiesDragBar.Visible = false
	mouseHighlighter:DisablePreview()
end

plugin.Deactivation:connect(function()
	Off()
end)

loaded = true
