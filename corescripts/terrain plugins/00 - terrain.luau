--!strict
while not game do
	wait()
end

local ChangeHistoryService = game:GetService "ChangeHistoryService"
local CoreGui = game:GetService "CoreGui"

local CreateStandardButton = require "../Modules/Terrain/CreateStandardButton"
local CreateStandardLabel = require "../Modules/Terrain/CreateStandardLabel"
local News = require "../Modules/New"
local New = News.New
local Hydrate = News.Hydrate

---------------
--PLUGIN SETUP-
---------------
local loaded = false
local on = false

local On, Off

local plugin = PluginManager():CreatePlugin()
local toolbar = plugin:CreateToolbar "Terrain"
local toolbarbutton =
	toolbar:CreateButton("Generator", "Terrain Generator", "terrain.png")
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
local SetCells = c.SetCells
local AutoWedge = c.AutowedgeCells
local CellCenterToWorld = c.CellCenterToWorld

-- Create a set of terrain options. Contains everything needed to now how to generate terrain.
local TerrainOptions = {}
TerrainOptions.__index = TerrainOptions

-- This will create with default options.
function TerrainOptions.Create()
	local options = {}
	setmetatable(options, TerrainOptions)

	-- Offset to create terrain at.
	options.xpos = 0
	options.zpos = 0

	-- X width
	options.width = 512

	-- Z length
	options.length = 512

	-- Amplitude, how high hills can be.  The higher the number the higher a hill can be.
	options.a = 30

	-- Frequency, how often hills occur.  The higher the number the more hills.
	options.f = 8

	-- How deep water should be.  0 means no water.
	options.waterHeight = 0

	-- How how the base of the world should be.  0 means no base.
	options.baseHeight = 1

	-- What material type terrain will be.
	options.terrainMaterial = 1

	-- Display the location.
	return options
end

-- Stores the current terrain options to set/display.
local terrainOptions = TerrainOptions.Create()

-- This will store a copy of terrainOptions when the generate button is pressed.
-- This will then be used for the generation instead of terrainOptions.  This way terrainOptions can be changed while generating without messing up what is being generated.
local generateOptions

-- Create a deep copy of a table.
-- Copies the elements.
function CopyTable(object)
	local holdTable = {}
	local function Copy(object2)
		if type(object2) ~= "table" then
			return object2
		elseif holdTable[object2] then
			return holdTable[object2]
		end
		local clone = {}
		holdTable[object2] = clone
		for index, value in pairs(object2) do
			clone[Copy(index)] = Copy(value)
		end
		return setmetatable(clone, getmetatable(object2))
	end
	return Copy(object)
end

-- Creates a copy of terrain options data.
--
-- Return:
-- Value is a new terrain options set with the old terrain options data.
function TerrainOptions:Clone(_)
	return CopyTable(self)
end

-----------------
--DEFAULT VALUES-
-----------------
-- Stores the conformation popup when confirming a choice.  If not nil then some actions should be blocked.
local ConfirmationPopupObject

-- If true, the clear terrain conformation won't be shown.
local hideClearConformation = false

-- If true, the genearte terrain conformation won't be shown.
local hideGenerateConformation = false

------
--GUI-
------
--screengui
local g = New "ScreenGui" {
	Name = "TerrainCreatorGui",
	Parent = CoreGui,
}

-- UI gui load.  Required for sliders.
local RbxGui = LoadLibrary "RbxGui"

-- Gui frame for the plugin.
local terrainPropertiesDragBar, terrainFrame, terrainHelpFrame, terrainCloseEvent =
	RbxGui.CreatePluginFrame(
		"Terrain Generator",
		UDim2.new(0, 186, 0, 428),
		UDim2.new(0, 0, 0, 0),
		false,
		g
	)
terrainPropertiesDragBar.Visible = false
terrainCloseEvent.Event:connect(function()
	Off()
end)

terrainHelpFrame.Size = UDim2.new(0, 300, 0, 350)

local function helpText()
	return New "TextLabel" {
		Font = Enum.Font.ArialBold,
		FontSize = Enum.FontSize.Size12,
		TextColor3 = Color3.new(227 / 255, 227 / 255, 227 / 255),
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		BackgroundTransparency = 1,
		TextWrapped = true,
		Parent = terrainHelpFrame,
	}
end

local helpText1 = [[Create terrain with hills, water.
X-Offset and Z-Offset:
Center point of terrain that will be created.
Terrain must be in a specific region.  If part of the terrain is outside that region, it won't be created.

Width: Terrain size in the X direction

Length: Terrain size in the Z direction

Amplitude:
Maximum height of hills.
]]
local helpText2 = [[Frequency:
How often hills are made.

Base Height:
How high the base of terrain should be.

Water Height:
How high water should be.  Terrain will overwrite water.
]]
local helpText3 = [[
			
Generate Button:
Create the terrain.

Clear Button:
Remove all terrain.
]]

Hydrate(helpText()) {
	Name = "HelpText",
	Position = UDim2.new(0, 4, 0, 4),
	Size = UDim2.new(1, -8, 0, 157),
	Text = helpText1,
	Parent = terrainHelpFrame,
	Hydrate(helpText()) {
		Name = "HelpSecondText",
		Position = UDim2.new(0, 0, 1, 0),
		Size = UDim2.new(1, 0, 0, 180),
		Text = helpText2,
		Hydrate(helpText()) {
			Name = "HelpThirdText",
			Position = UDim2.new(0, 0, 0.6, 0),
			Size = UDim2.new(1, 0, 0, 180),
			Text = helpText3,
		},
	},
}

-- Used to create a highlighter.
-- A highlighter is a open, rectuangular area displayed in 3D.
local Highlighter = {}
Highlighter.__index = Highlighter

-- Create a highlighter object.
--
-- position - Where the highlighter should be displayed.  If nil, the highlighter will not be shown immediatly.
-- ID       - Number ID to use for the box.
-- color	-- Color to use for the highlighter.  Something like BrickColor.new("Really red")
function Highlighter.Create(_, ID, color)
	-- This will be the created highlighter.
	local highlighter = {}

	-- How high to show the highlighter.
	highlighter.height = 0
	highlighter.width = 0
	highlighter.length = 0

	highlighter.x = 0
	highlighter.y = 0
	highlighter.z = 0

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
		Name = "box" .. ID,
		Archivable = false,
		Color = color,
		Adornee = highlighter.selectionPart,
	}
	setmetatable(highlighter, Highlighter)

	return highlighter
end

-- Hide the highlighter.
function Highlighter:DisablePreview()
	self.selectionBox.Parent = nil
end

-- Show the highlighter.
function Highlighter:EnablePreview()
	self.selectionBox.Parent = CoreGui -- This will make it not show up in workspace.
end

-- Update where the highlighter is displayed.
-- cellPos - Where to display the highlighter, in cells.
function Highlighter:UpdatePosition(cellPos: Vector3)
	if not cellPos then
		self:DisablePreview()
		return
	end

	local regionToSelect

	self.x = cellPos.x
	self.y = cellPos.y
	self.z = cellPos.z

	local width, length, height =
		self.width :: number, self.length :: number, self.height :: number

	local lowVec = CellCenterToWorld(
		c,
		cellPos.x - width / 2,
		cellPos.y - 1,
		cellPos.z - length / 2
	)
	local highVec = CellCenterToWorld(
		c,
		cellPos.x + width / 2,
		cellPos.y + height,
		cellPos.z + length / 2
	)
	regionToSelect = Region3.new(lowVec, highVec)

	self.selectionPart.Size = regionToSelect.Size - Vector3.new(-4, 4, -4)
	self.selectionPart.CFrame = regionToSelect.CFrame
end

-- Set the dimensions of the highlighter.
-- Updates the display size.
-- length - Length of the area (z direction)
-- width  - Width of the area (x direction)
-- height - Height of the area (y direction)
function Highlighter:UpdateDimensions(
	length: number,
	width: number,
	height: number
)
	self.length = length
	self.width = width
	self.height = height
	self:UpdatePosition(Vector3.new(self.x, self.y, self.z))
end

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
local function CreateStandardSlider(
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

	Hydrate(sliderGui) {
		Name = name,
		Parent = parent,
		Position = pos,
		Size = UDim2.new(1, 0, 0, 20),
	}
	Hydrate(sliderGui.Bar) {
		Size = UDim2.new(1, -21, 0, 5),
		Position = lengthBarPos,
	}

	if funcOnChange then
		sliderPosition.Changed:connect(function()
			funcOnChange(sliderPosition)
		end)
	end

	if initValue then
		sliderPosition.Value = initValue
	end

	return sliderGui, sliderPosition
end

local cancelValues = {
	cancelAction = false, -- Used to cancel currently occuring actions.  If set to true then terrain generation will stop.
	progressBar = nil, -- Will store the progress bar when needed.
	setAmountFunc = nil, -- Stores a function tied to the progres bar that sets the progress bar precentage done.
	bindForCancel = nil,
} -- Stores a function bind that will be set with the function to run when the cancel button is pressed in the progress bar.

-- Load the progress bar to display when drawing a river.
-- text - Text to display.
local function LoadProgressBar(text)
	if cancelValues.progressBar then
		print "Tried to start the progress bar when it was already running."
		return
	end

	cancelValues.isDrawing = true

	-- Start the progress bar.
	cancelValues.progressBar, cancelValues.setAmountFunc, cancelValues.bindForCancel =
		RbxGui.CreateLoadingFrame(text)

	cancelValues.progressBar.Position =
		UDim2.new(0.5, -cancelValues.progressBar.Size.X.Offset / 2, 0, 15)
	cancelValues.progressBar.Parent = g

	cancelValues.bindForCancel.Event:connect(function(_)
		cancelValues.cancelActions = true -- Set the flag that everything should stop.

		coroutine.yield()
	end)
end

-- Unload the progress bar.
local function UnloadProgressBar()
	cancelValues.isDrawing = false
	cancelValues.cancelActions = false

	if nil ~= cancelValues.progressBar then
		cancelValues.progressBar.Parent = nil
		cancelValues.progressBar = nil
		cancelValues.setAmountFunc = nil
		cancelValues.bindForCancel = nil
	end
end

-- Slider for controlling the x offset to generate terrain at.
local offsetXLabel = CreateStandardLabel(
	"offsetXLabel",
	UDim2.new(0, 8, 0, 10),
	UDim2.new(0, 67, 0, 14),
	"",
	terrainFrame
)
local _, offsetXSliderPosition = CreateStandardSlider(
	"offsetXSliderGui",
	UDim2.new(0, 1, 0, 26),
	UDim2.new(0, 10, 0.5, -2),
	128,
	function(offsetXSliderPosition2)
		terrainOptions.xpos = (offsetXSliderPosition2.Value - 1) * 4 - 252
		offsetXLabel.Text = "X-Offset: " .. terrainOptions.xpos
	end,
	nil,
	terrainFrame
)
offsetXSliderPosition.Value = (terrainOptions.xpos + 252) / 4 + 1

-- Slider for controlling the z offset to generate terrain at.
local offsetZLabel = CreateStandardLabel(
	"OffsetZLabel",
	UDim2.new(0, 8, 0, 51),
	UDim2.new(0, 67, 0, 14),
	"",
	terrainFrame
)
local _, offsetZSliderPosition = CreateStandardSlider(
	"OffsetZSliderGui",
	UDim2.new(0, 1, 0, 67),
	UDim2.new(0, 10, 0.5, -2),
	128,
	function(offsetZSliderPosition2)
		terrainOptions.zpos = (offsetZSliderPosition2.Value - 1) * 4 - 252
		offsetZLabel.Text = "Z-Offset: " .. terrainOptions.zpos
	end,
	nil,
	terrainFrame
)
offsetZSliderPosition.Value = (terrainOptions.zpos + 252) / 4 + 1

-----------------------
--FUNCTION DEFINITIONS-
-----------------------

-- makes a column of blocks from 1 up to height at location (x,z) in cluster c
local function coordHeight(x, z, height)
	SetCells(
		c,
		Region3int16.new(
			Vector3int16.new(x, 1, z),
			Vector3int16.new(x, height, z)
		),
		terrainOptions.terrainMaterial,
		0,
		0
	)
end

-- makes a heightmap for a layer of mountains (width x depth)
-- with a width frequency wf and depthfrequency df (width should be divisible by wf, depth should be divisible by df) (for unsquished results, width/wf = depth/df)
-- with a range of amplitudes between 0 and a
local function mountLayer(width, depth, wf, df, a)
	local heightmap = {}
	for i = 0, width - 1 do
		heightmap[i] = {}
		for k = 0, depth - 1 do
			heightmap[i][k] = 0
		end
	end
	math.randomseed(tick())
	local corners = {}
	for i = 0, wf do
		corners[i] = {}
		for k = 0, df do
			corners[i][k] = a * math.random()
		end
	end
	for i = 0, wf do
		corners[i][0] = 0
		corners[i][math.floor(df)] = 0
	end
	for k = 0, df do
		corners[0][k] = 0
		corners[math.floor(wf)][k] = 0
	end

	for i = 0, width - (width / wf), width / wf do
		for k = 0, depth - (depth / df), depth / df do
			local c1 = corners[i / (width / wf)][k / (depth / df)]
			local c2 =
				corners[i / (width / wf)][(k + depth / df) / (depth / df)]
			local c3 =
				corners[(i + width / wf) / (width / wf)][k / (depth / df)]
			local c4 =
				corners[(i + width / wf) / (width / wf)][(k + depth / df) / (depth / df)]
			for x = i, i + (width / wf) - 1 do
				for z = k, k + (depth / df) - 1 do
					local avgc1c3 = (
						math.abs(x - i) * c3
						+ math.abs(x - (i + width / wf)) * c1
					) / (width / wf)
					local avgc2c4 = (
						math.abs(x - i) * c4
						+ math.abs(x - (i + width / wf)) * c2
					) / (width / wf)
					local avg = math.floor(
						(
							math.abs(z - k) * avgc2c4
							+ math.abs(z - (k + depth / df)) * avgc1c3
						) / (depth / df)
					)
					if avg > 100 then
						print(avg)
						avg = 1
					end
					heightmap[x][z] = avg
				end
			end
		end
	end
	return heightmap
end

-- makes a shell around block at coordinate x, z using heightmap
local function makeShell(x, z, heightmap, shellheightmap)
	local originalheight = heightmap[x][z]
	for i = x - 1, x + 1 do
		for k = z - 1, z + 1 do
			if shellheightmap[i][k] < originalheight then
				for h = originalheight, shellheightmap[i][k] - 2, -1 do
					if h > 0 then
						SetCell(
							c,
							i,
							h,
							k,
							terrainOptions.terrainMaterial,
							0,
							0
						)
					end
				end
				shellheightmap[i][k] = originalheight
			end
		end
	end
	return shellheightmap
end

-- Set the camera to look at the terrain from a distance so that all terrain will be in view.
-- centerX, centerZ - Center coordinate of land.  This doesn't take into account clipping.
-- length, width    - Land dimensions.
local function SetCamera(centerX, centerZ, length, width, height)
	local currCamera = workspace.CurrentCamera
	local cameraPos = Vector3.new(0, 400, 1600)
	local cameraFocus = Vector3.new(0, height * 4, 0)

	-- Nothing set so use the default.
	if centerX then
		local scale = 0
		local lengthScale = 0
		local widthScale = 0

		if length <= 64 then
			lengthScale = 0.35
		elseif length <= 128 then
			lengthScale = 0.5
		elseif length <= 256 then
			lengthScale = 0.7
		else
			lengthScale = 1.3
		end

		if width <= 64 then
			widthScale = 0.35
		elseif width <= 256 then
			widthScale = 0.4
		else
			widthScale = 0.7
		end

		scale = widthScale > lengthScale and widthScale or lengthScale

		local distance = Vector3.new(0, (200 * scale) + 200, (1100 * scale))
		cameraPos =
			Vector3.new(centerX + distance.X, distance.Y, centerZ + distance.Z)
		cameraFocus = Vector3.new(centerX, height * 4, centerZ)
	end

	currCamera.CoordinateFrame =
		CFrame.new(cameraPos.X, cameraPos.Y, cameraPos.Z)
	currCamera.Focus = CFrame.new(cameraFocus.X, cameraFocus.Y, cameraFocus.Z)
end

-- Create terrain based on the current properties.
local function GenerateTerrain()
	toolbarbutton:SetActive(false)

	generateOptions = terrainOptions:Clone()

	Off()

	-- Create the progress bar that will track terrain creation completion.
	LoadProgressBar "Generating Terrain"

	--Generate Terrain
	-- offset terrain additionally by whatever the smallest cell is
	--xpos2 = generateOptions.xpos + workspace.Terrain.MaxExtents.Min.X
	--zpos2 = generateOptions.zpos + workspace.Terrain.MaxExtents.Min.Z
	local xpos2 = generateOptions.xpos - generateOptions.width / 2
	local zpos2 = generateOptions.zpos - generateOptions.length / 2

	-- Reposition to get a good view.
	SetCamera(
		generateOptions.xpos,
		generateOptions.zpos,
		generateOptions.length,
		generateOptions.width,
		math.max(generateOptions.baseHeight, generateOptions.a / 2)
	)

	--make 3 layers of mountains (you can change the frequency and amplitude of each layer and add or remove layers as you see fit (but don't forget to add the new layers to the loop below)
	local a1 = mountLayer(
		generateOptions.width,
		generateOptions.length,
		generateOptions.f * generateOptions.width / 512,
		generateOptions.f * generateOptions.length / 512,
		3 / 5 * generateOptions.a
	)
	local a2 = mountLayer(
		generateOptions.width,
		generateOptions.length,
		2 * generateOptions.f * generateOptions.width / 512,
		2 * generateOptions.f * generateOptions.length / 512,
		2 / 5 * generateOptions.a
	)
	local heightmap = {}
	for x = 0, generateOptions.width - 1 do
		heightmap[x + xpos2] = {}
		for z = 0, generateOptions.length - 1 do
			heightmap[x + xpos2][z + zpos2] = a1[x][z] + a2[x][z]
		end
	end
	local shellheightmap = {}
	for x = 0, generateOptions.width - 1 do
		shellheightmap[x + xpos2] = {}
		for z = 0, generateOptions.length - 1 do
			shellheightmap[x + xpos2][z + zpos2] =
				heightmap[x + xpos2][z + zpos2]
		end
	end
	local gprogress = 0
	local k = 1 + zpos2

	local waitCount = 0

	-- Fill in the edges that don't get done in the terrain calculations.
	if 0 ~= generateOptions.waterHeight then
		SetCells(
			c,
			Region3int16.new(
				Vector3int16.new(xpos2, 1, zpos2),
				Vector3int16.new(
					xpos2,
					generateOptions.waterHeight,
					zpos2 + generateOptions.length - 1
				)
			),
			Enum.CellMaterial.Water,
			0,
			0
		)
		SetCells(
			c,
			Region3int16.new(
				Vector3int16.new(xpos2 + generateOptions.width - 1, 1, zpos2),
				Vector3int16.new(
					xpos2 + generateOptions.width - 1,
					generateOptions.waterHeight,
					zpos2 + generateOptions.length - 1
				)
			),
			Enum.CellMaterial.Water,
			0,
			0
		)
		SetCells(
			c,
			Region3int16.new(
				Vector3int16.new(xpos2, 1, zpos2),
				Vector3int16.new(
					xpos2 + generateOptions.width - 1,
					generateOptions.waterHeight,
					zpos2
				)
			),
			Enum.CellMaterial.Water,
			0,
			0
		)
		SetCells(
			c,
			Region3int16.new(
				Vector3int16.new(xpos2, 1, zpos2 + generateOptions.length - 1),
				Vector3int16.new(
					xpos2 + generateOptions.width - 1,
					generateOptions.waterHeight,
					zpos2 + generateOptions.length - 1
				)
			),
			Enum.CellMaterial.Water,
			0,
			0
		)
	end
	if 0 ~= generateOptions.baseHeight then
		SetCells(
			c,
			Region3int16.new(
				Vector3int16.new(xpos2, 0, zpos2),
				Vector3int16.new(
					xpos2,
					generateOptions.baseHeight,
					zpos2 + generateOptions.length - 1
				)
			),
			terrainOptions.terrainMaterial,
			0,
			0
		)
		SetCells(
			c,
			Region3int16.new(
				Vector3int16.new(xpos2 + generateOptions.width - 1, 0, zpos2),
				Vector3int16.new(
					xpos2 + generateOptions.width - 1,
					generateOptions.baseHeight,
					zpos2 + generateOptions.length - 1
				)
			),
			terrainOptions.terrainMaterial,
			0,
			0
		)
		SetCells(
			c,
			Region3int16.new(
				Vector3int16.new(xpos2, 0, zpos2),
				Vector3int16.new(
					xpos2 + generateOptions.width - 1,
					generateOptions.baseHeight,
					zpos2
				)
			),
			terrainOptions.terrainMaterial,
			0,
			0
		)
		SetCells(
			c,
			Region3int16.new(
				Vector3int16.new(xpos2, 0, zpos2 + generateOptions.length - 1),
				Vector3int16.new(
					xpos2 + generateOptions.width - 1,
					generateOptions.baseHeight,
					zpos2 + generateOptions.length - 1
				)
			),
			terrainOptions.terrainMaterial,
			0,
			0
		)
	end

	while k < generateOptions.length - 1 + zpos2 do
		for x = 1 + xpos2, generateOptions.width - 2 + xpos2 do
			-- End on cancel.
			if cancelValues.cancelActions then
				ChangeHistoryService:SetWaypoint "CancelGenerate"
				UnloadProgressBar()
				return
			end

			-- Create water.
			if 0 ~= generateOptions.waterHeight then
				SetCells(
					c,
					Region3int16.new(
						Vector3int16.new(x, 1, k),
						Vector3int16.new(x, generateOptions.waterHeight, k)
					),
					Enum.CellMaterial.Water,
					0,
					0
				)
			end

			-- Create the base for terrain.
			if 0 ~= generateOptions.baseHeight then
				SetCells(
					c,
					Region3int16.new(
						Vector3int16.new(x, 0, k),
						Vector3int16.new(x, generateOptions.baseHeight, k)
					),
					terrainOptions.terrainMaterial,
					0,
					0
				)
			end

			coordHeight(x, k, heightmap[x][k])
			shellheightmap = makeShell(x, k, heightmap, shellheightmap)
		end
		k = k + 1
		gprogress = gprogress + 2 / (generateOptions.length * 3)

		-- Update the amount completed.
		cancelValues.setAmountFunc(gprogress)

		if waitCount > 5 then
			waitCount = 0
			wait(0.01)
		else
			waitCount = waitCount + 1
		end
	end
	k = 1 + zpos2
	waitCount = 0
	local maxHeight = -1
	local oldK = k
	while k < generateOptions.length - 1 + zpos2 do
		for x = 1 + xpos2, generateOptions.width - 2 + xpos2 do
			-- End on cancel.
			if cancelValues.cancelActions then
				ChangeHistoryService:SetWaypoint "GenerateGenerate"
				UnloadProgressBar()
				return
			end

			local height = shellheightmap[x][k]
			if height == nil then
				height = -1
			end
			if height > maxHeight then
				maxHeight = height
			end
		end
		k = k + 1
		gprogress = gprogress + 1 / (generateOptions.length * 3)

		-- Update the amount completed.
		cancelValues.setAmountFunc(gprogress)

		if waitCount > 10 then
			waitCount = 0
			AutoWedge(
				c,
				Region3int16.new(
					Vector3int16.new(1 + xpos2, 0, oldK),
					Vector3int16.new(
						generateOptions.width - 2 + xpos2,
						maxHeight,
						k
					)
				)
			)
			oldK = k + 1
			maxHeight = -1
			wait()
		else
			waitCount = waitCount + 1
		end
		if k == generateOptions.length - 2 + zpos2 then
			AutoWedge(
				c,
				Region3int16.new(
					Vector3int16.new(1 + xpos2, 0, oldK),
					Vector3int16.new(
						generateOptions.width - 2 + xpos2,
						maxHeight,
						k
					)
				)
			)
		end
	end

	-- Clean up the progress bar.
	UnloadProgressBar()
	--Generate Terrain End
	ChangeHistoryService:SetWaypoint "Generate"
end

local ConfirmationPopup

-- Unload the conformation popup if it exists.
-- Does nothing if the popup isn't set.
local function ClearConformation()
	if ConfirmationPopupObject then
		ConfirmationPopupObject:Clear()
		ConfirmationPopupObject = nil
	end
end

-- Function used by the generate button.  Prompts the user first.
-- Will not show if disabled or terrain is being processed.
local function ConfirmGenerateTerrain()
	-- Only do if something isn't already being processed.
	if cancelValues.progressBar or ConfirmationPopupObject then
		return
	elseif hideGenerateConformation then
		GenerateTerrain()
		return
	end

	ConfirmationPopupObject = ConfirmationPopup.Create(
		"Generate Terrain?",
		"Generate",
		"Cancel",
		function()
			ClearConformation()
			GenerateTerrain()
		end,
		ClearConformation,
		function()
			hideGenerateConformation = not hideGenerateConformation
			return not hideGenerateConformation
		end
	)
end

-- Clears all terrain.
-- Clearing is immediate.
local function ClearTerrain()
	toolbarbutton:SetActive(false)
	Off()

	--Erase Terrain
	LoadProgressBar "Clearing Terrain"

	wait()
	c:Clear()

	--Erase Terrain End
	UnloadProgressBar()
	ChangeHistoryService:SetWaypoint "Reset"
end

-- Function used by the clear button.  Prompts the user first.
-- Will not show if disabled or terrain is being processed.
local function ConfirmClearTerrain()
	-- Only do if something isn't already being processed.
	if cancelValues.progressBar or ConfirmationPopupObject then
		return
	elseif hideClearConformation then
		ClearTerrain()
		return
	end

	ConfirmationPopupObject = ConfirmationPopup.Create(
		"Clear Terrain?",
		"Clear",
		"Cancel",
		function()
			ClearConformation()
			ClearTerrain()
		end,
		ClearConformation,
		function()
			hideClearConformation = not hideClearConformation
			return not hideClearConformation
		end
	)
end

-- Used to create a highlighter.
-- A highlighter is a open, rectuangular area displayed in 3D.
ConfirmationPopup = {}
ConfirmationPopup.__index = ConfirmationPopup

-- Create a confirmation popup.
--
-- confirmText       - What to display in the popup.
-- confirmButtonText - What to display in the popup.
-- declineButtonText - What to display in the popup.
-- confirmFunction   - Function to run on confirmation.
-- declineFunction   - Function to run when declining.
--
-- Return:
-- Value a table with confirmation gui and options.
function ConfirmationPopup.Create(
	confirmText,
	confirmButtonText,
	declineButtonText,
	confirmFunction,
	declineFunction
)
	local popup = {
		confirmButton = nil, -- Hold the button to confirm a choice.
		declineButton = nil, -- Hold the button to decline a choice.
		confirmationFrame = nil, -- Hold the conformation frame.
		confirmationText = nil, -- Hold the text label to display the conformation message.
		confirmationHelpText = nil, -- Hold the text label to display the conformation message help.
	}

	popup.confirmationFrame = New "Frame" {
		Name = "ConfirmationFrame",
		Size = UDim2.new(0, 280, 0, 140),
		Position = UDim2.new(
			0.5,
			-popup.confirmationFrame.Size.X.Offset / 2,
			0.5,
			-popup.confirmationFrame.Size.Y.Offset / 2
		),
		Style = Enum.FrameStyle.RobloxRound,
		Parent = g,
	}

	popup.confirmLabel = Hydrate(
		CreateStandardLabel(
			"ConfirmLabel",
			UDim2.new(0, 0, 0, 15),
			UDim2.new(1, 0, 0, 24),
			confirmText,
			popup.confirmationFrame
		)
	) {
		FontSize = Enum.FontSize.Size18,
		TextXAlignment = Enum.TextXAlignment.Center,
	}

	-- Confirm
	popup.confirmButton = CreateStandardButton(
		"ConfirmButton",
		UDim2.new(0.5, -120, 1, -50),
		confirmButtonText,
		confirmFunction,
		popup.confirmationFrame
	)

	-- Decline
	popup.declineButton = CreateStandardButton(
		"DeclineButton",
		UDim2.new(0.5, 0, 1, -50),
		declineButtonText,
		declineFunction,
		popup.confirmationFrame
	)

	setmetatable(popup, ConfirmationPopup)

	return popup
end

-- Clear the popup, free up assets.
function ConfirmationPopup:Clear()
	if self.confirmButton then
		self.confirmButton.Parent = nil
	end

	if self.declineButton then
		self.declineButton.Parent = nil
	end

	if self.confirmationFrame then
		self.confirmationFrame.Parent = nil
	end

	if self.confirmLabel then
		self.confirmLabel.Parent = nil
	end

	self.confirmButton = nil
	self.declineButton = nil
	self.conformationFrame = nil
	self.conformText = nil
end

--------------------------------------------------------------------------------------------
-- Create Gui Interfaces
--------------------------------------------------------------------------------------------

local maxXZExtentsLog = c.MaxExtents.Max.X > 512 and 6 or 4
local maxYExtents = math.min(c.MaxExtents.Max.Y, 256)

-- Slider for controlling the width of the terran area.  Terran is created in a region this wide.
local widthLabel = CreateStandardLabel(
	"WidthLabel",
	UDim2.new(0, 8, 0, 92),
	UDim2.new(0, 67, 0, 14),
	"",
	terrainFrame
)
-- local _, _ widthSliderGui, widthSliderPosition =
CreateStandardSlider(
	"WidthSliderGui",
	UDim2.new(0, 1, 0, 108),
	UDim2.new(0, 10, 0.5, -2),
	maxXZExtentsLog,
	function(widthSliderPosition2)
		terrainOptions.width = math.pow(2, widthSliderPosition2.Value + 5)
		widthLabel.Text = "Width: " .. terrainOptions.width
	end,
	4,
	terrainFrame
)

-- Slider for controlling the length of the terran area.  Terran is created in a region this long.
local lengthLabel = CreateStandardLabel(
	"LengthLabel",
	UDim2.new(0, 8, 0, 133),
	UDim2.new(0, 67, 0, 14),
	"",
	terrainFrame
)
-- local _, _ lengthSliderGui, lengthSliderPosition =
CreateStandardSlider(
	"LengthSliderGui",
	UDim2.new(0, 1, 0, 149),
	UDim2.new(0, 10, 0.5, -2),
	maxXZExtentsLog,
	function(lengthSliderPosition2)
		terrainOptions.length = math.pow(2, lengthSliderPosition2.Value + 5)
		lengthLabel.Text = "Length: " .. terrainOptions.length
	end,
	4,
	terrainFrame
)

-- Slider for controlling the amplitude of hills.
local amplitudeLabel = CreateStandardLabel(
	"AmplitudeLabel",
	UDim2.new(0, 8, 0, 174),
	UDim2.new(0, 67, 0, 14),
	"",
	terrainFrame
)
local _, amplitudeSliderPosition = CreateStandardSlider(
	"AmplitudeSliderGui",
	UDim2.new(0, 1, 0, 190),
	UDim2.new(0, 10, 0.5, -2),
	62,
	function(amplitudeSliderPosition2)
		terrainOptions.a = amplitudeSliderPosition2.Value + 1
		amplitudeLabel.Text = "Amplitude: " .. terrainOptions.a
	end,
	nil,
	terrainFrame
)
amplitudeSliderPosition.Value = terrainOptions.a - 1

-- Slider for controlling the frequency of hills.
local frequencyLabel = CreateStandardLabel(
	"FrequencyLabel",
	UDim2.new(0, 8, 0, 215),
	UDim2.new(0, 67, 0, 14),
	"",
	terrainFrame
)
local _, frequencySliderPosition = CreateStandardSlider(
	"FrequencySliderGui",
	UDim2.new(0, 1, 0, 231),
	UDim2.new(0, 10, 0.5, -2),
	8,
	function(frequencySliderPosition2)
		terrainOptions.f = math.pow(2, frequencySliderPosition2.Value - 1)
		frequencyLabel.Text = "Frequency: " .. terrainOptions.f
	end,
	nil,
	terrainFrame
)
frequencySliderPosition.Value = 4

-- Slider for controlling the baseHeight, how deep the base terrain should be.
local baseHeightLabel = CreateStandardLabel(
	"BaseHeightLabel",
	UDim2.new(0, 8, 0, 256),
	UDim2.new(0, 67, 0, 14),
	"",
	terrainFrame
)
local _, baseHeightSliderPosition = CreateStandardSlider(
	"BaseHeightSliderGui",
	UDim2.new(0, 1, 0, 272),
	UDim2.new(0, 10, 0.5, -2),
	maxYExtents,
	function(baseHeightSliderPosition2)
		terrainOptions.baseHeight = baseHeightSliderPosition2.Value - 1
		baseHeightLabel.Text = "Base Height: " .. terrainOptions.baseHeight
	end,
	nil,
	terrainFrame
)
baseHeightSliderPosition.Value = terrainOptions.baseHeight + 1

-- Slider for controlling the waterHeight, how much water to fill.
local waterHeightLabel = CreateStandardLabel(
	"WaterHeightLabel",
	UDim2.new(0, 8, 0, 297),
	UDim2.new(0, 67, 0, 14),
	"",
	terrainFrame
)
local _, waterHeightSliderPosition = CreateStandardSlider(
	"WaterHeightSliderGui",
	UDim2.new(0, 1, 0, 313),
	UDim2.new(0, 10, 0.5, -2),
	maxYExtents,
	function(waterHeightSliderPosition2)
		terrainOptions.waterHeight = waterHeightSliderPosition2.Value - 1
		waterHeightLabel.Text = "Water Height: " .. terrainOptions.waterHeight
	end,
	nil,
	terrainFrame
)
waterHeightSliderPosition.Value = terrainOptions.waterHeight + 1

-- Button to generate terrain using the current settings.
CreateStandardButton(
	"GenerateButton",
	UDim2.new(0.5, -75, 0, 343),
	"Generate",
	ConfirmGenerateTerrain,
	terrainFrame,
	UDim2.new(0, 150, 0, 40)
)

-- Button to clear terrain using.  All terrain will be removed.
CreateStandardButton(
	"ClearButton",
	UDim2.new(0.5, -75, 0, 385),
	"Clear",
	ConfirmClearTerrain,
	terrainFrame,
	UDim2.new(0, 150, 0, 40)
)

-- Run when the popup is activated.
function On()
	if not c then
		return
	end
	plugin:Activate(true)
	toolbarbutton:SetActive(true)
	terrainPropertiesDragBar.Visible = true
	on = true
end

-- Run when the popup is deactivated.
function Off()
	toolbarbutton:SetActive(false)
	ClearConformation()
	on = false

	-- Hide the popup gui.
	terrainPropertiesDragBar.Visible = false
end

plugin.Deactivation:connect(function()
	Off()
end)

loaded = true
