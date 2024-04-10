while not game do
	wait()
end

local ChangeHistoryService = game:GetService "ChangeHistoryService"
local ContentProvider = game:GetService "ContentProvider"
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
local mouseDown, mouseUp

local this = PluginManager():CreatePlugin()
local mouse = this:GetMouse()
mouse.Button1Down:connect(function()
	mouseDown(mouse)
end)
mouse.Button1Up:connect(function()
	mouseUp(mouse)
end)

local toolbar = this:CreateToolbar "Terrain"
local toolbarbutton =
	toolbar:CreateButton("Flood Fill", "Flood Fill", "floodFill.png")
toolbarbutton.Click:connect(function()
	if on then
		Off()
	elseif loaded then
		On()
	end
end)

game:WaitForChild "Workspace"
game.Workspace:WaitForChild "Terrain"

-----------------------------
--LOCAL FUNCTION DEFINITIONS-
-----------------------------
local c = game.Workspace.Terrain
-- local WorldToCellPreferSolid = c.WorldToCellPreferSolid
local WorldToCellPreferEmpty = c.WorldToCellPreferEmpty
local CellCenterToWorld = c.CellCenterToWorld
local GetCell = c.GetCell
local SetCell = c.SetCell
-- local maxYExtents = c.MaxExtents.Max.Y

local emptyMaterial = Enum.CellMaterial.Empty
-- local waterMaterial = Enum.CellMaterial.Water

-- local floodFill

-----------------
--DEFAULT VALUES-
-----------------
local startCell
local processing = false

-- gui values
local screenGui
local dragBar, closeEvent, helpFrame --, lastCell
local progressBar, setProgressFunc, cancelEvent
local ConfirmationPopupObject

--- exposed values to user via gui
local currentMaterial = 1

-- load our libraries
local RbxGui = LoadLibrary "RbxGui"
-- local RbxUtil = LoadLibrary "RbxUtility"
ContentProvider:Preload "http://banland.xyz/asset?id=82741829"

------------------------- OBJECT DEFINITIONS ---------------------

-- helper function for objects
local function getClosestColorToTerrainMaterial(terrainValue)
	if terrainValue == 1 then
		return BrickColor.new "Bright green"
	elseif terrainValue == 2 then
		return BrickColor.new "Bright yellow"
	elseif terrainValue == 3 then
		return BrickColor.new "Bright red"
	elseif terrainValue == 4 then
		return BrickColor.new "Sand red"
	elseif terrainValue == 5 then
		return BrickColor.new "Black"
	elseif terrainValue == 6 then
		return BrickColor.new "Dark stone grey"
	elseif terrainValue == 7 then
		return BrickColor.new "Sand blue"
	elseif terrainValue == 8 then
		return BrickColor.new "Deep orange"
	elseif terrainValue == 9 then
		return BrickColor.new "Dark orange"
	elseif terrainValue == 10 then
		return BrickColor.new "Reddish brown"
	elseif terrainValue == 11 then
		return BrickColor.new "Light orange"
	elseif terrainValue == 12 then
		return BrickColor.new "Light stone grey"
	elseif terrainValue == 13 then
		return BrickColor.new "Sand green"
	elseif terrainValue == 14 then
		return BrickColor.new "Medium stone grey"
	elseif terrainValue == 15 then
		return BrickColor.new "Really red"
	elseif terrainValue == 16 then
		return BrickColor.new "Really blue"
	elseif terrainValue == 17 then
		return BrickColor.new "Bright blue"
	else
		return BrickColor.new "Bright green"
	end
end

-- Used to create a highlighter that follows the mouse.
-- It is a class mouse highlighter.  To use, call MouseHighlighter.Create(mouse) where mouse is the mouse to track.
local MouseHighlighter = {}
MouseHighlighter.__index = MouseHighlighter

local startTween, stopTween

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

	-- Hook the mouse up to check for movement.

	mouseH.Button1Down:connect(function()
		highlighter.mouseDown = true
	end)
	mouseH.Button1Up:connect(function()
		highlighter.mouseDown = false
	end)

	-- Create the part that the highlighter will be attached to.
	highlighter.selectionPart = Instance.new "Part"
	highlighter.selectionPart.Name = "SelectionPart"
	highlighter.selectionPart.Archivable = false
	highlighter.selectionPart.Transparency = 0.5
	highlighter.selectionPart.Anchored = true
	highlighter.selectionPart.Locked = true
	highlighter.selectionPart.CanCollide = false
	highlighter.selectionPart.FormFactor = Enum.FormFactor.Custom
	highlighter.selectionPart.Size = Vector3.new(4, 4, 4)
	highlighter.selectionPart.BottomSurface = 0
	highlighter.selectionPart.TopSurface = 0
	highlighter.selectionPart.BrickColor =
		getClosestColorToTerrainMaterial(currentMaterial)
	highlighter.selectionPart.Parent = game.Workspace

	local billboardGui = Instance.new "BillboardGui"
	billboardGui.Size = UDim2.new(5, 0, 5, 0)
	billboardGui.StudsOffset = Vector3.new(0, 2.5, 0)
	billboardGui.Parent = highlighter.selectionPart

	local imageLabel = Instance.new "ImageLabel"
	imageLabel.BackgroundTransparency = 1
	imageLabel.Size = UDim2.new(1, 0, 1, 0)
	imageLabel.Position = UDim2.new(-0.35, 0, -0.5, 0)
	imageLabel.Image = "http://banland.xyz/asset?id=82741829"
	imageLabel.Parent = billboardGui

	local lastTweenChange

	startTween = function()
		local tweenDown, tweenUp
		while tweenUp or tweenDown do
			wait(0.2)
		end
		lastTweenChange = tick()

		delay(0, function()
			local thisTweenStamp = lastTweenChange

			tweenDown = function()
				if
					imageLabel
					and imageLabel:IsDescendantOf(game.Workspace)
					and thisTweenStamp == lastTweenChange
				then
					imageLabel:TweenPosition(
						UDim2.new(-0.35, 0, -0.5, 0),
						Enum.EasingDirection.In,
						Enum.EasingStyle.Quad,
						0.4,
						true,
						tweenUp
					)
				end
			end
			tweenUp = function()
				if
					imageLabel
					and imageLabel:IsDescendantOf(game.Workspace)
					and thisTweenStamp == lastTweenChange
				then
					imageLabel:TweenPosition(
						UDim2.new(-0.35, 0, -0.7, 0),
						Enum.EasingDirection.Out,
						Enum.EasingStyle.Sine,
						0.4,
						true,
						tweenDown
					)
				end
			end

			tweenUp()
		end)
	end

	stopTween = function()
		lastTweenChange = tick()
	end

	mouseH.TargetFilter = highlighter.selectionPart
	setmetatable(highlighter, MouseHighlighter)

	-- Update where the highlighter is displayed.
	-- position - Where to display the highlighter, in world space.
	local function UpdatePosition(position)
		if not position then
			return
		elseif not mouseH.Target then
			stopTween()
			highlighter.selectionPart.Parent = nil
			return
		end

		if highlighter.selectionPart.Parent ~= game.Workspace then
			highlighter.selectionPart.Parent = game.Workspace
			startTween()
		end

		local vectorPos = Vector3.new(position.x, position.y, position.z)
		local cellPos = WorldToCellPreferEmpty(c, vectorPos)

		local regionToSelect

		local cellMaterial = GetCell(c, cellPos.x, cellPos.y, cellPos.z)
		local y = cellPos.y
		-- only select empty cells
		while cellMaterial ~= emptyMaterial do
			y = y + 1
			cellMaterial = GetCell(c, cellPos.x, y, cellPos.z)
		end
		cellPos = Vector3.new(cellPos.x, y, cellPos.z)

		local lowVec = CellCenterToWorld(c, cellPos.x, cellPos.y - 1, cellPos.z)
		local highVec =
			CellCenterToWorld(c, cellPos.x, cellPos.y + 1, cellPos.z)
		regionToSelect = Region3.new(lowVec, highVec)

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

				-- holdChange = cellPos - highlighter.lastUsedPoint

				-- Require terrain.
				if 0 == GetCell(c, cellPos.X, cellPos.Y, cellPos.Z).Value then
					return
				else
					highlighter.lastUsedPoint = cellPos
				end
			end
		end
	end

	-- Function to call when the mouse has moved. Updates where to display the highlighter.
	mouseH.Move:connect(function()
		if on and not processing then
			UpdatePosition(mouseH.Hit)
		end
	end)

	return highlighter
end

function MouseHighlighter:SetMaterial(newMaterial)
	self.selectionPart.BrickColor =
		getClosestColorToTerrainMaterial(newMaterial)
end

function MouseHighlighter:GetPosition()
	local position = self.selectionPart.CFrame.p
	return WorldToCellPreferEmpty(c, position)
end

-- Hide the highlighter.
function MouseHighlighter:DisablePreview()
	stopTween()
	self.selectionPart.Parent = nil
end

-- Show the highlighter.
function MouseHighlighter:EnablePreview()
	self.selectionPart.Parent = game.Workspace
	startTween()
end

-- Create the mouse movement highlighter.
local mouseHighlighter = MouseHighlighter.Create(mouse)
mouseHighlighter:DisablePreview()

-- Used to create a highlighter.
-- A highlighter is a open, rectuangular area displayed in 3D.
local ConfirmationPopup = {}
ConfirmationPopup.__index = ConfirmationPopup

-- Create a confirmation popup.
--
-- confirmText      - What to display in the popup.
-- textOffset       - Offset to position text at.
-- confirmFunction  - Function to run on confirmation.
-- declineFunction  - Function to run when declining.
--
-- Return:
-- Value a table with confirmation gui and options.
function ConfirmationPopup.Create(
	confirmText,
	confirmSmallText,
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
		Size = UDim2.new(0, 280, 0, 160),
		Position = UDim2.new(
			0.5,
			-popup.confirmationFrame.Size.X.Offset / 2,
			0.5,
			-popup.confirmationFrame.Size.Y.Offset / 2
		),
		Style = Enum.FrameStyle.RobloxRound,
		Parent = screenGui,
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

	popup.confirmationHelpText = Hydrate(
		CreateStandardLabel(
			"ConfirmSmallLabel",
			UDim2.new(0, 0, 0, 40),
			UDim2.new(1, 0, 0, 28),
			confirmSmallText,
			popup.confirmationFrame
		)
	) {
		FontSize = Enum.FontSize.Size14,
		TextWrap = true,
		Font = Enum.Font.Arial,
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
	if nil ~= self.confirmButton then
		self.confirmButton.Parent = nil
	end

	if nil ~= self.declineButton then
		self.declineButton.Parent = nil
	end

	if nil ~= self.confirmationFrame then
		self.confirmationFrame.Parent = nil
	end

	if nil ~= self.confirmLabel then
		self.confirmLabel.Parent = nil
	end

	self.confirmButton = nil
	self.declineButton = nil
	self.conformationFrame = nil
	self.conformText = nil
end

-----------------------
--FUNCTION DEFINITIONS-
-----------------------

-- function startLoadingFrame() end

-- Load the progress bar to display when drawing a river.
-- text - Text to display.
local function LoadProgressBar(text)
	processing = true

	-- Start the progress bar.
	progressBar, setProgressFunc, cancelEvent = RbxGui.CreateLoadingFrame(text)

	progressBar.Position = UDim2.new(0.5, -progressBar.Size.X.Offset / 2, 0, 15)
	progressBar.Parent = screenGui

	local loadingPercent = progressBar:FindFirstChild("LoadingPercent", true)
	if loadingPercent then
		loadingPercent.Parent = nil
	end
	local loadingBar = progressBar:FindFirstChild("LoadingBar", true)
	if loadingBar then
		loadingBar.Parent = nil
	end
	local cancelButton = progressBar:FindFirstChild("CancelButton", true)
	if cancelButton then
		cancelButton.Text = "Stop"
	end

	cancelEvent.Event:connect(function(_)
		processing = false
		-- spin = false
	end)

	local spinnerFrame = New "Frame" {
		Name = "Spinner",
		Size = UDim2.new(0, 80, 0, 80),
		Position = UDim2.new(0.5, -40, 0.5, -55),
		BackgroundTransparency = 1,
		Parent = progressBar,
	}

	local spinnerIcons = {}
	local spinnerNum = 1
	while spinnerNum <= 8 do
		local spinnerImage = New "ImageLabel" {
			Name = "Spinner" .. spinnerNum,
			Size = UDim2.new(0, 16, 0, 16),
			Position = UDim2.new(
				0.5 + 0.3 * math.cos(math.rad(45 * spinnerNum)),
				-8,
				0.5 + 0.3 * math.sin(math.rad(45 * spinnerNum)),
				-8
			),
			BackgroundTransparency = 1,
			Image = "http://banland.xyz/asset?id=45880710",
			Parent = spinnerFrame,
		}

		spinnerIcons[spinnerNum] = spinnerImage
		spinnerNum += 1
	end

	--Make it spin
	delay(0, function()
		local spinPos = 0
		while processing do
			local pos = 0

			while pos < 8 do
				if pos == spinPos or pos == ((spinPos + 1) % 8) then
					spinnerIcons[pos + 1].Image =
						"http://banland.xyz/asset?id=45880668"
				else
					spinnerIcons[pos + 1].Image =
						"http://banland.xyz/asset?id=45880710"
				end

				pos = pos + 1
			end
			spinPos = (spinPos + 1) % 8
			wait(0.2)
		end
	end)
end

-- Unload the progress bar.
local function UnloadProgressBar()
	processing = false

	if progressBar then
		progressBar.Parent = nil
		progressBar = nil
	end
	if setProgressFunc then
		setProgressFunc = nil
	end
	if cancelEvent then
		cancelEvent = nil
	end
end

local function floodFill(x, y, z)
	LoadProgressBar "Processing"
	breadthFill(x, y, z)
	UnloadProgressBar()
	ChangeHistoryService:SetWaypoint "FloodFill"
end

-- Function used when we try and flood fill.  Prompts the user first.
-- Will not show if disabled or terrain is being processed.
local function ConfirmFloodFill(x, y, z)
	-- Only do if something isn't already being processed.
	if processing then
		return
	end

	processing = true
	if ConfirmationPopupObject then
		return
	end

	ConfirmationPopupObject = ConfirmationPopup.Create(
		"Flood Fill At Selected Location?",
		"This operation may take some time.",
		"Fill",
		"Cancel",
		function()
			ConfirmationPopupObject:Clear()
			ConfirmationPopupObject = nil
			floodFill(x, y, z)
			ConfirmationPopupObject = nil
		end,
		function()
			ConfirmationPopupObject:Clear()
			ConfirmationPopupObject = nil
			processing = false
		end
	)
end

function mouseDown(mouseD)
	if on and mouseD.Target == game.Workspace.Terrain then
		startCell = mouseHighlighter:GetPosition()
	end
end

function mouseUp(_)
	if processing then
		return
	end

	local upCell = mouseHighlighter:GetPosition()
	if startCell == upCell then
		ConfirmFloodFill(upCell.x, upCell.y, upCell.z)
	end
end

local function getMaterial(x, y, z)
	local material = GetCell(c, x, y, z)
	return material
end

local function doBreadthFill(x, y, z)
	if getMaterial(x, y, z) ~= emptyMaterial then
		return
	end

	local yDepthChecks = {}
	local cellsToCheck = breadthFillHelper(x, y, z, yDepthChecks)
	local count = 0

	while cellsToCheck and #cellsToCheck > 0 do
		local cellCheckQueue = {}
		for i = 1, #cellsToCheck do
			if not processing then
				return
			end

			count = count + 1
			local newCellsToCheck = breadthFillHelper(
				cellsToCheck[i].xPos,
				cellsToCheck[i].yPos,
				cellsToCheck[i].zPos,
				yDepthChecks
			)
			if newCellsToCheck and #newCellsToCheck > 0 then
				for j = 1, #newCellsToCheck do
					table.insert(cellCheckQueue, {
						xPos = newCellsToCheck[j].xPos,
						yPos = newCellsToCheck[j].yPos,
						zPos = newCellsToCheck[j].zPos,
					})
				end
			end
			if count >= 3000 then
				wait()
				count = 0
			end
		end
		cellsToCheck = cellCheckQueue
	end

	return yDepthChecks
end

function breadthFill(x, y, z)
	local yDepthChecks = doBreadthFill(x, y, z)
	while yDepthChecks and #yDepthChecks > 0 do
		local newYChecks = {}
		for i = 1, #yDepthChecks do
			local currYDepthChecks = doBreadthFill(
				yDepthChecks[i].xPos,
				yDepthChecks[i].yPos,
				yDepthChecks[i].zPos
			)

			if
				not (processing and currYDepthChecks and #currYDepthChecks > 0)
			then
				return
			end

			for j = 1, #currYDepthChecks do
				table.insert(newYChecks, {
					xPos = currYDepthChecks[j].xPos,
					yPos = currYDepthChecks[j].yPos,
					zPos = currYDepthChecks[j].zPos,
				})
			end
		end
		yDepthChecks = newYChecks
	end
end

local function cellInTerrain(x, y, z)
	if x < c.MaxExtents.Min.X or x >= c.MaxExtents.Max.X then
		return false
	end

	if y < c.MaxExtents.Min.Y or y >= c.MaxExtents.Max.Y then
		return false
	end

	if z < c.MaxExtents.Min.Z or z >= c.MaxExtents.Max.Z then
		return false
	end

	return true
end

function breadthFillHelper(x, y, z, yDepthChecks)
	-- first, lets try and fill this cell
	if cellInTerrain(x, y, z) and getMaterial(x, y, z) == emptyMaterial then
		SetCell(c, x, y, z, currentMaterial, 0, 0)
	end

	local cellsToFill = {}
	if
		cellInTerrain(x + 1, y, z)
		and getMaterial(x + 1, y, z) == emptyMaterial
	then
		table.insert(cellsToFill, { xPos = x + 1, yPos = y, zPos = z })
	end
	if
		cellInTerrain(x - 1, y, z)
		and getMaterial(x - 1, y, z) == emptyMaterial
	then
		table.insert(cellsToFill, { xPos = x - 1, yPos = y, zPos = z })
	end
	if
		cellInTerrain(x, y, z + 1)
		and getMaterial(x, y, z + 1) == emptyMaterial
	then
		table.insert(cellsToFill, { xPos = x, yPos = y, zPos = z + 1 })
	end
	if
		cellInTerrain(x, y, z - 1)
		and getMaterial(x, y, z - 1) == emptyMaterial
	then
		table.insert(cellsToFill, { xPos = x, yPos = y, zPos = z - 1 })
	end
	if
		cellInTerrain(x, y - 1, z)
		and getMaterial(x, y - 1, z) == emptyMaterial
	then
		table.insert(yDepthChecks, { xPos = x, yPos = y - 1, zPos = z })
	end

	for i = 1, #cellsToFill do
		SetCell(
			c,
			cellsToFill[i].xPos,
			cellsToFill[i].yPos,
			cellsToFill[i].zPos,
			currentMaterial,
			0,
			0
		)
	end

	if #cellsToFill <= 0 then
		return nil
	end

	return cellsToFill
end

On = function()
	if not c then
		return
	elseif this then
		this:Activate(true)
	end
	if toolbarbutton then
		toolbarbutton:SetActive(true)
	end
	if dragBar then
		dragBar.Visible = true
	end

	on = true
end

Off = function()
	if toolbarbutton then
		toolbarbutton:SetActive(false)
	end
	if mouseHighlighter then
		mouseHighlighter:DisablePreview()
	end
	if dragBar then
		dragBar.Visible = false
	end

	on = false
end

mouseHighlighter.OnClicked = mouseUp

------
--GUI-
------
screenGui = Instance.new "ScreenGui"
screenGui.Name = "FloodFillGui"
screenGui.Parent = CoreGui

local containerFrame
dragBar, containerFrame, helpFrame, closeEvent = RbxGui.CreatePluginFrame(
	"Flood Fill",
	UDim2.new(0, 163, 0, 195),
	UDim2.new(0, 0, 0, 0),
	false,
	screenGui
)
dragBar.Visible = false

Hydrate(helpFrame) {
	Size = UDim2.new(0, 200, 0, 190),
	-- "This will be pdfs in 2024" - Heliodex
	New "TextLabel" {
		Name = "TextHelp",
		Font = Enum.Font.ArialBold,
		FontSize = Enum.FontSize.Size12,
		TextColor3 = Color3.new(1, 1, 1),
		Size = UDim2.new(1, -6, 1, -6),
		Position = UDim2.new(0, 3, 0, 3),
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		BackgroundTransparency = 1,
		TextWrap = true,
		Text = [[
Quickly replace empty terrain cells with a selected material.  Clicking the mouse will cause any empty terrain cells around the point clicked to be filled with the current material, and will also spread to surrounding empty cells (including any empty cells below, but not above).

Simply click on a different material to fill with that material.  The floating paint bucket and cube indicate where filling will start.
]],
	},
}

closeEvent.Event:connect(function()
	Off()
end)

local terrainSelectorGui, terrainSelected, forceTerrainMaterialSelection =
	RbxGui.CreateTerrainMaterialSelector(
		UDim2.new(1, -10, 0, 184),
		UDim2.new(0, 5, 0, 5)
	)
terrainSelectorGui.Parent = containerFrame
terrainSelectorGui.BackgroundTransparency = 1
terrainSelectorGui.BorderSizePixel = 0
terrainSelected.Event:connect(function(newMaterial)
	currentMaterial = newMaterial
	if mouseHighlighter then
		mouseHighlighter:SetMaterial(currentMaterial)
	end
end)
forceTerrainMaterialSelection(Enum.CellMaterial.Water)

this.Deactivation:connect(function()
	Off()
end)

--------------------------
--SUCCESSFUL LOAD MESSAGE-
--------------------------
loaded = true
