while game == nil do
	wait(1 / 30)
end

---------------
--PLUGIN SETUP-
---------------
local loaded = false
local on = false

local On, Off

local this = PluginManager():CreatePlugin()
local mouse = this:GetMouse()
mouse.Button1Down:connect(function()
	onClicked(mouse)
end)
local toolbar = this:CreateToolbar "Terrain"
local toolbarbutton = toolbar:CreateButton("Roads", "Roads", "roads.png")
toolbarbutton.Click:connect(function()
	if on then
		Off()
	elseif loaded then
		On()
	end
end)

game:WaitForChild "Workspace"
game.Workspace:WaitForChild "Terrain"

-- Local function definitions
local c = game.Workspace.Terrain
local GetCell = c.GetCell
local WorldToCellPreferSolid = c.WorldToCellPreferSolid
local WorldToCellPreferEmpty = c.WorldToCellPreferEmpty
local SetCells = c.SetCells

-----------------
--DEFAULT VALUES-
-----------------
local x1 = 200
local y1 = 200
local x2 = 300
local y2 = 300
local h = 20
local mode = 0

local DefaultTerrainMaterial = 1

local roadDragBar, roadFrame, roadCloseEvent

-----------------------
--FUNCTION DEFINITIONS-
-----------------------

--makes a column of blocks from 0 up to height at location (x,z) in cluster c
function coordHeight(x, z, height)
	SetCells(
		c,
		Region3int16.new(Vector3int16.new(x, 1, z), Vector3int16.new(x, height, z)),
		DefaultTerrainMaterial,
		0,
		0
	)
end

function coordCheck(x, z, height)
	for hh = height, 0, -1 do
		local material, _, _ = GetCell(c, x, hh, z)
		if material.Value > 0 then
			return true
		elseif height == 0 then
			return false
		end
	end
end

function dist(dx1, dy1, dx2, dy2)
	return math.sqrt(math.pow(dx2 - dx1, 2) + math.pow(dy2 - dy1, 2))
end

function dist3d(dx1, dy1, dz1, dx2, dy2, dz2)
	return math.sqrt(math.pow(dist(dx1, dy1, dx2, dy2), 2) + math.pow(dz2 - dz1, 2))
end

--create a path between coordinates (x1,z1) and (x2,z2) at height h in cluster c
--a path is a road with height of 3 instead of 1, and it builds a bridge if there is no existing land under it
--if you want path to come from x direction, make it start at the place
--if you want it to come from z direction, make it end at the place
--if p is true, turns on pillars, otherwise pillars are off
function makePath(px1, pz1, px2, pz2, ph, pp)
	local incx, n
	if px2 < px1 then
		incx = -1
		n = 1
	else
		incx = 1
		n = -1
	end
	for x = px1, px2 + n, incx do
		SetCells(
			c,
			Region3int16.new(Vector3int16.new(x, h + 1, pz1 - 1), Vector3int16.new(x, ph + 3, pz1 + 1)),
			0,
			0,
			0
		)
		SetCells(
			c,
			Region3int16.new(Vector3int16.new(x, ph, pz1 - 1), Vector3int16.new(x, ph, pz1 + 1)),
			DefaultTerrainMaterial,
			0,
			0
		)
	end
	if pp then
		for x = px1, px2 + n, 16 * incx do
			if coordCheck(x, pz1, ph - 1) then
				coordHeight(x, pz1, ph - 1)
			end
			if coordCheck(x, pz1 - 1, ph - 1) then
				coordHeight(x, pz1 - 1, ph - 1)
			end
			if coordCheck(x, pz1 + 1, ph - 1) then
				coordHeight(x, pz1 + 1, ph - 1)
			end
		end
	end
	local incz, m
	if pz2 < pz1 then
		incz = -1
		m = 1
		n = 2
	else
		incz = 1
		m = -1
		n = -2
	end
	for z = pz1 + m, pz2 + n, incz do
		SetCells(
			c,
			Region3int16.new(Vector3int16.new(px2 - 1, ph + 1, z), Vector3int16.new(px2 + 1, ph + 3, z)),
			0,
			0,
			0
		)
		SetCells(
			c,
			Region3int16.new(Vector3int16.new(x2 - 1, ph, z), Vector3int16.new(px2 + 1, ph, z)),
			DefaultTerrainMaterial,
			0,
			0
		)
	end
	if pp then
		for z = pz1 + m, pz2 + n, 16 * incz do
			if coordCheck(px2, z, ph - 1) then
				coordHeight(px2, z, ph - 1)
			end
			if coordCheck(px2 - 1, z, ph - 1) then
				coordHeight(px2 - 1, z, ph - 1)
			end
			if coordCheck(px2 + 1, z, ph - 1) then
				coordHeight(px2 + 1, z, ph - 1)
			end
		end
	end

	game:GetService("ChangeHistoryService"):SetWaypoint "Roads"
end

-- Do a line/plane intersection.  The line starts at the camera.  The plane is at y == 0, normal(0, 1, 0)
--
-- vectorPos - End point of the line.
--
-- Return:
-- success - Value is true if there was a plane intersection, false if not.
-- cellPos - Value is the terrain cell intersection point if there is one, vectorPos if there isn't.
function PlaneIntersection(vectorPos)
	local currCamera = game.Workspace.CurrentCamera
	local startPos =
		Vector3.new(currCamera.CoordinateFrame.p.X, currCamera.CoordinateFrame.p.Y, currCamera.CoordinateFrame.p.Z)
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

function onClicked(mouseC)
	if on then
		local cellPos = WorldToCellPreferEmpty(c, Vector3.new(mouseC.Hit.x, mouseC.Hit.y, mouseC.Hit.z))
		local solidCell = WorldToCellPreferSolid(c, Vector3.new(mouseC.Hit.x, mouseC.Hit.y, mouseC.Hit.z))
		local success = false

		-- If nothing was hit, do the plane intersection.
		if 0 == GetCell(c, solidCell.X, solidCell.Y, solidCell.Z).Value then
			--print('Plane Intersection happens')
			success, cellPos = PlaneIntersection(Vector3.new(mouseC.Hit.x, mouseC.Hit.y, mouseC.Hit.z))
			if not success then
				cellPos = solidCell
			end
		end

		local x = cellPos.x
		local y = cellPos.y
		local z = cellPos.z

		if mode == 0 then
			x1 = x
			y1 = z
			h = y
			mode = 1

			-- first click determines default material
			local celMat = GetCell(c, x, y, z)
			if celMat.Value > 0 then
				DefaultTerrainMaterial = celMat.Value
			else
				if 0 == DefaultTerrainMaterial then
					DefaultTerrainMaterial = 1
				end
			end
		elseif mode == 1 then
			x2 = x
			y2 = z
			makePath(x1, y1, x2, y2, h, true)
			mode = 0
		end
	end
end

On = function()
	if not c then
		return
	end
	if this then
		this:Activate(true)
	end
	if toolbarbutton then
		toolbarbutton:SetActive(true)
	end
	if roadDragBar then
		roadDragBar.Visible = true
	end

	mode = 0
	on = true
end

Off = function()
	if toolbarbutton then
		toolbarbutton:SetActive(false)
	end
	if roadDragBar then
		roadDragBar.Visible = false
	end
	on = false
end

------
--GUI-
------

local RbxGui = LoadLibrary "RbxGui"

--screengui
local g = Instance.new "ScreenGui"
g.Name = "RoadGui"
g.Parent = game:GetService "CoreGui"

roadDragBar, roadFrame, roadHelpFrame, roadCloseEvent =
	RbxGui.CreatePluginFrame("Roads", UDim2.new(0, 141, 0, 80), UDim2.new(0, 0, 0, 0), false, g)
roadDragBar.Visible = false
roadCloseEvent.Event:connect(function()
	Off()
end)

local roadTextHelper = Instance.new "TextLabel"
roadTextHelper.Text = "Click once to set the starting point and again to set the endpoint of the road."
roadTextHelper.Font = Enum.Font.ArialBold
roadTextHelper.FontSize = Enum.FontSize.Size14
roadTextHelper.TextColor3 = Color3.new(1, 1, 1)
roadTextHelper.BackgroundTransparency = 1
roadTextHelper.Size = UDim2.new(1, -8, 1, -8)
roadTextHelper.Position = UDim2.new(0, 4, 0, 4)
roadTextHelper.TextXAlignment = Enum.TextXAlignment.Left
roadTextHelper.TextYAlignment = Enum.TextYAlignment.Top
roadTextHelper.TextWrap = true
roadTextHelper.Parent = roadFrame

roadHelpFrame.Size = UDim2.new(0, 200, 0, 150)
local helpText = Instance.new "TextLabel"
helpText.Font = Enum.Font.ArialBold
helpText.FontSize = Enum.FontSize.Size12
helpText.TextColor3 = Color3.new(1, 1, 1)
helpText.BackgroundTransparency = 1
helpText.TextWrap = true
helpText.Size = UDim2.new(1, -10, 1, -10)
helpText.Position = UDim2.new(0, 5, 0, 5)
helpText.TextXAlignment = Enum.TextXAlignment.Left
helpText.Text =
	[[Creates roads in existing terrain. Roads are created by setting a beginning point (first click on terrain) and an ending point (second click on terrain). The material of terrain is determined by the first click point. After the second click the tool resets and will create a new segment of road, not neccessarily connected to the first road segment created.]]
helpText.Parent = roadHelpFrame

this.Deactivation:connect(function()
	Off()
end)

--------------------------
--SUCCESSFUL LOAD MESSAGE-
--------------------------
loaded = true
