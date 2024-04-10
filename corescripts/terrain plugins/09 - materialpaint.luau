while not game do
	wait()
end

local ChangeHistoryService = game:GetService "ChangeHistoryService"
local CoreGui = game:GetService "CoreGui"

local News = require "../Modules/New"
local New = News.New
local Hydrate = News.Hydrate

---------------
--PLUGIN SETUP-
---------------
local loaded = false
local on = false

local On, Off
local mouseDown, mouseUp, mouseMove

local this = PluginManager():CreatePlugin()
local mouse = this:GetMouse()
mouse.Button1Down:connect(function()
	mouseDown(mouse)
end)
mouse.Button1Up:connect(function()
	mouseUp(mouse)
end)
mouse.Move:connect(function()
	mouseMove(mouse)
end)

local toolbar = this:CreateToolbar "Terrain"
local toolbarbutton = toolbar:CreateButton(
	"Material Brush",
	"Material Brush",
	"materialBrush.png"
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

-----------------------------
--LOCAL FUNCTION DEFINITIONS-
-----------------------------
local c = workspace.Terrain
local SetCell = c.SetCell
local SetWaterCell = c.SetWaterCell
-- local GetWaterCell = c.GetWaterCell
local GetCell = c.GetCell
local WorldToCellPreferSolid = c.WorldToCellPreferSolid
local CellCenterToWorld = c.CellCenterToWorld
local waterMaterial = 17

local brushTypes = { "Circular", "Square" }
-- local waterForceDirections = { "NegX", "X", "NegY", "Y", "NegZ", "Z" }
-- local waterForces = { "None", "Small", "Medium", "Strong", "Max" }

local mediumWaterForce = Enum.WaterForce.Medium

-----------------
--DEFAULT VALUES-
-----------------
local terrainSelectorGui, terrainSelected, radiusLabel, dragBar, closeEvent, helpFrame, currSelectionUpdate, currSelectionDestroy, lastCell, lastLastCell --, waterPanel
local dragging = false
-- local painting = false

--- exposed values to user via gui
local currentMaterial = Enum.CellMaterial.Grass
local radius = 3
local brushType = "Square"
-- local currWaterForceDirection = "NegX"
-- local currWaterForce = "None"

-- lua library load
local RbxGui = LoadLibrary "RbxGui"
local RbxUtil = LoadLibrary "RbxUtility"

-----------------------
--FUNCTION DEFINITIONS-
-----------------------
function paintWaterfall(setCells)
	if not setCells then
		return
	end
	for i = 1, #setCells do
		SetWaterCell(
			c,
			setCells[i].xPos,
			setCells[i].yPos,
			setCells[i].zPos,
			mediumWaterForce,
			Enum.WaterDirection.NegY
		)
	end
end

-- Factored out this stuff because I didn't like the mutability of the setCells arrays. - Heliodex

local function getSquareCell(x: number, y: number, z: number)
	-- local tempCellPos = Vector3.new(x, y, z)
	local oldMaterial, oldType, oldOrientation = GetCell(c, x, y, z)
	if oldMaterial.Value <= 0 then
		return nil
	end
	return {
		xPos = x,
		yPos = y,
		zPos = z,
		theType = oldType,
		orientation = oldOrientation,
	}
end

local function getSquare(cellPos)
	local setCells = {}
	local finalX = cellPos.x + radius - 1
	local finalZ = cellPos.z + radius - 1
	local finalY = cellPos.y + radius - 1

	for x = cellPos.x - radius + 1, finalX do
		for z = cellPos.z - radius + 1, finalZ do
			for y = cellPos.y - radius + 1, finalY do
				table.insert(setCells, getSquareCell(x, y, z))
			end
		end
	end

	return setCells
end

local function getCircularCell(
	x: number,
	y: number,
	z: number,
	cellPos,
	radiusSquared
)
	local tempCellPos = Vector3.new(x, y, z)
	local holdDist = tempCellPos - cellPos
	local distSq = (holdDist):Dot(holdDist)
	if distSq >= radiusSquared then
		return nil
	end
	local oldMaterial, oldType, oldOrientation = GetCell(c, x, y, z)
	if oldMaterial.Value <= 0 then
		return nil
	end
	return {
		xPos = x,
		yPos = y,
		zPos = z,
		theType = oldType,
		orientation = oldOrientation,
	}
end

local function getCircular(cellPos)
	local setCells = {}
	local finalX = cellPos.x + radius
	local finalZ = cellPos.z + radius
	local finalY = cellPos.y + radius

	for x = cellPos.x - radius, finalX do
		for z = cellPos.z - radius, finalZ do
			for y = cellPos.y - radius, finalY do
				table.insert(
					setCells,
					getCircularCell(x, y, z, cellPos, radius * radius)
				)
			end
		end
	end

	return setCells
end

local function getAffectedCells(startPos)
	if startPos and c then
		if brushType == "Circular" then
			return getCircular(startPos)
		elseif brushType == "Square" then
			return getSquare(startPos)
		end
	end

	return {}
end

local function directionIsDown(fromCell, toCell)
	if not toCell then
		return false
	end

	if toCell and fromCell then
		local direction = (toCell - fromCell).unit
		local absX, absY, absZ =
			math.abs(direction.X), math.abs(direction.Y), math.abs(direction.Z)
		if absY > absX and absY > absZ then
			return true
		end
	end

	local viableCells = getAffectedCells(toCell)
	if not viableCells or #viableCells < 2 then
		return false
	end

	local lowX, lowY, lowZ =
		viableCells[1].xPos, viableCells[1].yPos, viableCells[1].zPos
	local highX, highY, highZ = lowX, lowY, lowZ

	for i = 2, #viableCells do
		if viableCells[i].xPos < lowX then
			lowX = viableCells[i].xPos
		end
		if viableCells[i].xPos > highX then
			highX = viableCells[i].xPos
		end

		if viableCells[i].yPos < lowY then
			lowY = viableCells[i].yPos
		end
		if viableCells[i].yPos > highY then
			highY = viableCells[i].yPos
		end

		if viableCells[i].zPos < lowZ then
			lowZ = viableCells[i].zPos
		end
		if viableCells[i].zPos > highZ then
			highZ = viableCells[i].zPos
		end
	end

	local xRange, yRange, zRange =
		math.abs(highX - lowX), math.abs(highY - lowY), math.abs(highZ - lowZ)

	local xzPlaneArea = xRange * zRange
	local xyPlaneArea = xRange * yRange
	local yzPlaneArea = yRange * zRange

	return xyPlaneArea > xzPlaneArea or yzPlaneArea > xzPlaneArea
end

local function setWaterDirection(mouseCellPos, setCells)
	if not setCells or #setCells <= 0 then
		return
	elseif directionIsDown(lastCell, mouseCellPos) then
		paintWaterfall(setCells)
		return
	end

	local initX = setCells[1].xPos
	local initZ = setCells[1].zPos

	local endX = setCells[#setCells].xPos
	local endZ = setCells[#setCells].zPos

	local zWidth = math.abs(endZ - initZ)
	local zMiddle = math.ceil(zWidth / 2 + initZ)
	local xMiddle = math.ceil(zWidth / 2 + initX)

	local down = endX - initX
	local up, left, right = nil
	if down < 0 then
		down = Enum.WaterDirection.NegX
		up = Enum.WaterDirection.X
		left = Enum.WaterDirection.Z
		right = Enum.WaterDirection.NegZ
	else
		down = Enum.WaterDirection.X
		up = Enum.WaterDirection.NegX
		left = Enum.WaterDirection.NegZ
		right = Enum.WaterDirection.Z
	end

	if #setCells == 1 then
		if not mouseCellPos or not lastCell then
			return
		end

		local overallDirection = (mouseCellPos - lastCell).unit
		if
			math.abs(overallDirection.x) > math.abs(overallDirection.y)
			and math.abs(overallDirection.x) > math.abs(overallDirection.z)
		then
			if overallDirection.x > 0 then
				SetWaterCell(
					c,
					setCells[1].xPos,
					setCells[1].yPos,
					setCells[1].zPos,
					mediumWaterForce,
					Enum.WaterDirection.X
				)
			else
				SetWaterCell(
					c,
					setCells[1].xPos,
					setCells[1].yPos,
					setCells[1].zPos,
					mediumWaterForce,
					Enum.WaterDirection.NegX
				)
			end
		elseif
			math.abs(overallDirection.z) > math.abs(overallDirection.y)
			and math.abs(overallDirection.z) > math.abs(overallDirection.x)
		then
			if overallDirection.z > 0 then
				SetWaterCell(
					c,
					setCells[1].xPos,
					setCells[1].yPos,
					setCells[1].zPos,
					mediumWaterForce,
					Enum.WaterDirection.Z
				)
			else
				SetWaterCell(
					c,
					setCells[1].xPos,
					setCells[1].yPos,
					setCells[1].zPos,
					mediumWaterForce,
					Enum.WaterDirection.NegZ
				)
			end
		elseif
			math.abs(overallDirection.y) > math.abs(overallDirection.z)
			and math.abs(overallDirection.y) > math.abs(overallDirection.x)
		then
			if overallDirection.y > 0 then
				SetWaterCell(
					c,
					setCells[1].xPos,
					setCells[1].yPos,
					setCells[1].zPos,
					mediumWaterForce,
					Enum.WaterDirection.Y
				)
			else
				SetWaterCell(
					c,
					setCells[1].xPos,
					setCells[1].yPos,
					setCells[1].zPos,
					mediumWaterForce,
					Enum.WaterDirection.NegY
				)
			end
		end
		return
	end

	for i = 1, #setCells do
		if setCells[i].xPos == initX then
			SetWaterCell(
				c,
				setCells[i].xPos,
				setCells[i].yPos,
				setCells[i].zPos,
				mediumWaterForce,
				down
			)
		elseif setCells[i].xPos == endX then
			SetWaterCell(
				c,
				setCells[i].xPos,
				setCells[i].yPos,
				setCells[i].zPos,
				mediumWaterForce,
				up
			)
		else
			if setCells[i].zPos < zMiddle then
				SetWaterCell(
					c,
					setCells[i].xPos,
					setCells[i].yPos,
					setCells[i].zPos,
					mediumWaterForce,
					right
				)
			elseif setCells[i].zPos > zMiddle then
				SetWaterCell(
					c,
					setCells[i].xPos,
					setCells[i].yPos,
					setCells[i].zPos,
					mediumWaterForce,
					left
				)
			else
				if setCells[i].xPos < xMiddle then
					SetWaterCell(
						c,
						setCells[i].xPos,
						setCells[i].yPos,
						setCells[i].zPos,
						mediumWaterForce,
						down
					)
				elseif setCells[i].xPos > xMiddle then
					SetWaterCell(
						c,
						setCells[i].xPos,
						setCells[i].yPos,
						setCells[i].zPos,
						mediumWaterForce,
						up
					)
				end
			end
		end
	end

	return setCells
end

local function paintWith(
	fn: (
		Vector3
	) -> { xPos: number, yPos: number, zPos: number },
	cellPos: Vector3
)
	local setCells = fn(cellPos)

	if currentMaterial == waterMaterial then
		return
	end
	for i = 1, #setCells do
		SetCell(
			c,
			setCells[i].xPos,
			setCells[i].yPos,
			setCells[i].zPos,
			currentMaterial,
			setCells[i].theType,
			setCells[i].orientation
		)
	end

	return setCells
end

local function paint(startPos)
	if not (startPos and c) then
		return
	end

	local cellPos = startPos
	local setCells

	if brushType == "Circular" then
		setCells = paintWith(getCircular, cellPos)
	elseif brushType == "Square" then
		setCells = paintWith(getSquare, cellPos)
	end

	if currentMaterial == waterMaterial then
		return setWaterDirection(cellPos, setCells)
	end

	return setCells
end

local function calculateRegion(mouseR)
	local cellPos = WorldToCellPreferSolid(c, mouseR.Hit.p)

	local lowVec =
		Vector3.new(cellPos.x - radius, cellPos.y - radius, cellPos.z - radius)
	local highVec =
		Vector3.new(cellPos.x + radius, cellPos.y + radius, cellPos.z + radius)
	lowVec = CellCenterToWorld(c, lowVec.x, lowVec.y, lowVec.z)
	highVec = CellCenterToWorld(c, highVec.x, highVec.y, highVec.z)

	return Region3.new(
		lowVec + Vector3.new(2, 2, 2),
		highVec - Vector3.new(2, 2, 2)
	)
end

local function createSelection(mouseS, massSelection)
	currSelectionUpdate, currSelectionDestroy = RbxUtil.SelectTerrainRegion(
		calculateRegion(mouseS),
		BrickColor.new "Lime green",
		massSelection,
		game.CoreGui
	)
end

local function updateSelection(mouseS)
	if not currSelectionUpdate then
		createSelection(mouseS, radius > 4)
		return
	end
	currSelectionUpdate(calculateRegion(mouseS), BrickColor.new "Lime green")
end

local function setPositionDirectionality()
	if nil == lastCell then
		return
	elseif lastCell and not lastLastCell then
		-- no dragging occured, lets set our water to be stagnant or be a waterfall
		local cellsToSet = paint(lastCell)
		if directionIsDown(nil, lastCell) then
			paintWaterfall(cellsToSet)
		else
			for i = 1, #cellsToSet do
				SetWaterCell(
					c,
					cellsToSet[i].xPos,
					cellsToSet[i].yPos,
					cellsToSet[i].zPos,
					Enum.WaterForce.None,
					Enum.WaterDirection.NegX
				)
			end
		end
		return
	end

	if directionIsDown(lastLastCell, lastCell) then
		local cellsToSet = paint(lastCell)
		paintWaterfall(cellsToSet)
		return
	end

	local overallDirection = (lastCell - lastLastCell).unit
	local cellsToSet = paint(lastCell)

	local absX, absY, absZ =
		math.abs(overallDirection.X),
		math.abs(overallDirection.Y),
		math.abs(overallDirection.Z)
	local direction

	if absX > absY and absX > absZ then
		direction = overallDirection.X > 0 and Enum.WaterDirection.X
			or Enum.WaterDirection.NegX
	elseif absY > absX and absY > absZ then
		direction = overallDirection.Y > 0 and Enum.WaterDirection.Y
			or Enum.WaterDirection.NegY
	elseif absZ > absX and absZ > absY then
		direction = overallDirection.Z > 0 and Enum.WaterDirection.Z
			or Enum.WaterDirection.NegZ
	end

	if not direction then -- this should never be hit, but just in case
		direction = Enum.WaterDirection.NegX
	end

	for i = 1, #cellsToSet do
		SetWaterCell(
			c,
			cellsToSet[i].xPos,
			cellsToSet[i].yPos,
			cellsToSet[i].zPos,
			mediumWaterForce,
			direction
		)
	end
end

function mouseDown(mouseD)
	if not (on and mouseD.Target == workspace.Terrain) then
		return
	end

	dragging = true
	if not (mouseD and mouseD.Hit and mouseD.Target == workspace.Terrain) then
		return
	end

	local newCell = WorldToCellPreferSolid(c, mouseD.Hit.p)
	if not newCell then
		return
	elseif
		currentMaterial == waterMaterial
		and directionIsDown(lastCell, newCell)
	then
		paintWaterfall(paint(newCell))
	end
	lastCell = newCell
end

function mouseUp(_)
	dragging = false

	-- we need to fix directionality on last cell set (if water)
	if currentMaterial == waterMaterial then
		setPositionDirectionality()
	end

	ChangeHistoryService:SetWaypoint "MaterialPaint"

	lastLastCell = nil
	lastCell = nil
end

local function moveTowardsGoal(direction: string, currPos, goalPos, currCell)
	if currPos == goalPos then
		return currCell
	end

	if currPos < goalPos then
		if direction == "X" then
			currCell = Vector3.new(currCell.X + 1, currCell.Y, currCell.Z)
		elseif direction == "Y" then
			currCell = Vector3.new(currCell.X, currCell.Y + 1, currCell.Z)
		elseif direction == "Z" then
			currCell = Vector3.new(currCell.X, currCell.Y, currCell.Z + 1)
		end
	elseif currPos > goalPos then
		if direction == "X" then
			currCell = Vector3.new(currCell.X - 1, currCell.Y, currCell.Z)
		elseif direction == "Y" then
			currCell = Vector3.new(currCell.X, currCell.Y - 1, currCell.Z)
		elseif direction == "Z" then
			currCell = Vector3.new(currCell.X, currCell.Y, currCell.Z - 1)
		end
	end

	return currCell
end

local function interpolateOneDim(direction, currPos, goalPos, currCell)
	if currPos ~= goalPos then
		currCell = moveTowardsGoal(direction, currPos, goalPos, currCell)
		paint(currCell)
	end

	return currCell
end

local function paintBetweenPoints(lastCellP, newCell)
	local currCell = lastCellP

	while
		currCell.X ~= newCell.X
		or currCell.Z ~= newCell.Z
		or currCell.Y ~= newCell.Y
	do
		currCell = interpolateOneDim("X", currCell.X, newCell.X, currCell)
		currCell = interpolateOneDim("Z", currCell.Z, newCell.Z, currCell)
		currCell = interpolateOneDim("Y", currCell.Y, newCell.Y, currCell)
	end
end

local function destroySelection()
	if currSelectionUpdate then
		currSelectionUpdate = nil
	end
	if currSelectionDestroy then
		currSelectionDestroy()
		currSelectionDestroy = nil
	end
end

function mouseMove(mouseM)
	if not on then
		return
	elseif mouseM.Target == workspace.Terrain then
		if lastCell == WorldToCellPreferSolid(c, mouseM.Hit.p) then
			return
		end
		updateSelection(mouseM)
		local newCell = WorldToCellPreferSolid(c, mouseM.Hit.p)

		if not dragging then
			return
		end
		-- local painting = true
		paint(newCell)
		if lastCell and newCell and (lastCell - newCell).magnitude > 1 then
			paintBetweenPoints(lastCell, newCell)
		end
		lastLastCell = lastCell
		lastCell = newCell
		-- painting = false
	else
		destroySelection()
	end
end

function On()
	if not c then
		return
	end
	this:Activate(true)
	toolbarbutton:SetActive(true)

	dragBar.Visible = true
	on = true
end

function Off()
	toolbarbutton:SetActive(false)

	destroySelection()
	dragBar.Visible = false
	on = false
end

------
--GUI-
------

--screengui
local g = New "ScreenGui" {
	Name = "MaterialPainterGui",
	Parent = CoreGui,
}

local containerFrame
dragBar, containerFrame, helpFrame, closeEvent = RbxGui.CreatePluginFrame(
	"Material Brush",
	UDim2.new(0, 163, 0, 285),
	UDim2.new(0, 0, 0, 0),
	false,
	g
)
dragBar.Visible = false

-- End dragging if it goes over the gui frame.
containerFrame.MouseEnter:connect(function()
	dragging = false
end)
dragBar.MouseEnter:connect(function()
	dragging = false
end)

helpFrame.Size = UDim2.new(0, 200, 0, 250)
helpFrame.ZIndex = 3

local helpText =
	[[Changes existing terrain blocks to the specified material.  Simply hold the mouse down and drag to 'paint' the terrain (only cells inside the selection box will be affected).

Size: 
The size of the brush we paint terrain with.

Brush Type: 
The shape we paint terrain with inside of our selection box.

Material Selection: 
The terrain material we will paint.]]

New "TextLabel" {
	Name = "TextHelp",
	Font = Enum.Font.ArialBold,
	FontSize = Enum.FontSize.Size12,
	TextColor3 = Color3.new(1, 1, 1),
	Size = UDim2.new(1, -6, 1, -6),
	-- Position = UDim2.new(0, 3, 0, 3), -- lellel new supremacy - Heliodex
	TextXAlignment = Enum.TextXAlignment.Left,
	TextYAlignment = Enum.TextYAlignment.Top,
	Position = UDim2.new(0, 4, 0, 4),
	BackgroundTransparency = 1,
	TextWrapped = true,
	ZIndex = 4,
	Text = helpText,
	Parent = helpFrame,
}

closeEvent.Event:connect(function()
	Off()
end)

terrainSelectorGui, terrainSelected = RbxGui.CreateTerrainMaterialSelector(
	UDim2.new(1, -10, 0, 184),
	UDim2.new(0, 5, 1, -190)
)
Hydrate(terrainSelectorGui) {
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	Parent = containerFrame,
}
terrainSelected.Event:connect(function(newMaterial)
	currentMaterial = newMaterial
end)

-- Purpose:
-- Retrive the size text to display for a given radius, where 1 == 1 block and 2 == 3 blocks, etc.
local function SizeText(radiusT: number)
	return "Size: " .. (((radiusT - 1) * 2) + 1)
end

local function makeRadiusLabel()
	return New "TextLabel" {
		Size = UDim2.new(1, -3, 0, 14),
		TextColor3 = Color3.new(0.95, 0.95, 0.95),
		Font = Enum.Font.ArialBold,
		FontSize = Enum.FontSize.Size14,
		BorderColor3 = Color3.new(0, 0, 0),
		BackgroundTransparency = 1,
		TextXAlignment = Enum.TextXAlignment.Left,
	}
end

--current radius display label
radiusLabel = Hydrate(makeRadiusLabel()) {
	Name = "RadiusLabel",
	Text = SizeText(radius),
	Position = UDim2.new(0, 10, 0, 5),
	Parent = containerFrame,
}

--radius slider
local radSliderGui, radSliderPosition =
	RbxGui.CreateSlider(6, 0, UDim2.new(0, 0, 0, 18))
Hydrate(radSliderGui) {
	Size = UDim2.new(1, -2, 0, 20),
	Position = UDim2.new(0, 0, 0, 24),
	Parent = containerFrame,
}
Hydrate(radSliderGui.Bar) {
	Size = UDim2.new(1, -20, 0, 5),
	Position = UDim2.new(0, 10, 0.5, -3),
}

radSliderPosition.Value = radius
radSliderPosition.Changed:connect(function()
	radius = radSliderPosition.Value
	radiusLabel.Text = SizeText(radius)
	destroySelection()
end)

local brushTypeChanged = function(newBrush)
	brushType = newBrush
end
-- brush type drop-down
local brushDropDown, forceSelection =
	RbxGui.CreateDropDownMenu(brushTypes, brushTypeChanged)
forceSelection "Square"

Hydrate(brushDropDown) {
	Size = UDim2.new(1, -10, 0.01, 25),
	Position = UDim2.new(0, 5, 0, 65),
	Parent = containerFrame,
}
Hydrate(makeRadiusLabel()) {
	Name = "BrushLabel",
	Text = "Brush Type",
	Position = UDim2.new(0, 10, 0, 50),
	Parent = containerFrame,
}

this.Deactivation:connect(function()
	Off()
end)

--------------------------
--SUCCESSFUL LOAD MESSAGE-
--------------------------
loaded = true
