while game == nil do
	wait()
end

local ChangeHistoryService = game:GetService "ChangeHistoryService"
local CoreGui = game:GetService "CoreGui"

---------------
--PLUGIN SETUP-
---------------
local loaded = false
local on = false

local On, Off

local this = PluginManager():CreatePlugin()
local mouse = this:GetMouse()

local toolbar = this:CreateToolbar "Terrain"
local toolbarbutton = toolbar:CreateButton("Crater", "Crater", "craters.png")
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
local SetCell = c.SetCell
local GetCell = c.GetCell
local WorldToCellPreferSolid = c.WorldToCellPreferSolid
local AutoWedge = c.AutowedgeCell

-----------------
--DEFAULT VALUES-
-----------------
local r = 20
local d = 20
local craterDragBar, craterFrame, craterHelpFrame, craterCloseEvent = nil

-----------------------
--FUNCTION DEFINITIONS-
-----------------------

--makes a crater at point (x, y, z) in cluster c
--cd is the depth factor, a percent of the depth of a perfect sphere
function makeCrater(x, y, z, cr, cd)
	local heightmap = {}
	for i = x - (cr + 1), x + (cr + 1) do
		heightmap[i] = {}
	end

	for j = 0, cr + 1 do
		local cellschanged = false
		for i = x - (cr + 1), x + (cr + 1) do
			for k = z - (cr + 1), z + (cr + 1) do
				local distance = math.sqrt(
					math.pow(dist(x, z, i, k), 2)
						+ math.pow(y - (y - j * (100 / cd)), 2)
				)
				if distance < r then
					SetCell(c, i, y + j, k, 0, 0, 0)
					SetCell(c, i, y - j, k, 0, 0, 0)
					cellschanged = true
				elseif heightmap[i] and heightmap[i][k] == nil then
					local material, _, _ = GetCell(c, i, y - j, k)
					if material.Value > 0 then
						heightmap[i][k] = y - j
					end
				end
			end
		end
		if cellschanged == false then
			break
		end
		wait()
	end

	for ri = 0, cr do
		wait()

		local i = x - ri
		for k = z - cr, z + cr do
			local height = heightmap[i][k]
			if height == nil then
				height = -1
			end
			for h = height, 0, -1 do
				if not AutoWedge(c, i, h, k) then
					break
				end
			end
		end

		i = x + ri
		for k = z - cr, z + cr do
			local height = heightmap[i][k]
			if height == nil then
				height = -1
			end
			for h = height, 0, -1 do
				if not AutoWedge(c, i, h, k) then
					break
				end
			end
		end
	end
end

function dist(x1, y1, x2, y2)
	return math.sqrt(math.pow(x2 - x1, 2) + math.pow(y2 - y1, 2))
end

local debounce = false

mouse.Button1Down:connect(function()
	if not on or debounce then
		return
	end

	debounce = true

	local cellPos = WorldToCellPreferSolid(
		c,
		Vector3.new(mouse.Hit.x, mouse.Hit.y, mouse.Hit.z)
	)
	local x = cellPos.x
	local y = cellPos.y
	local z = cellPos.z

	makeCrater(x, y, z, r, d)

	debounce = false
	ChangeHistoryService:SetWaypoint "Crater"
end)

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
	if craterDragBar then
		craterDragBar.Visible = true
	end
	on = true
end

Off = function()
	if toolbarbutton then
		toolbarbutton:SetActive(false)
	end
	if craterDragBar then
		craterDragBar.Visible = false
	end
	on = false
end

------
--GUI-
------

--load library for with sliders
local RbxGui = LoadLibrary "RbxGui"

--screengui
local g = Instance.new "ScreenGui"
g.Name = "CraterGui"
g.Parent = CoreGui

craterDragBar, craterFrame, craterHelpFrame, craterCloseEvent =
	RbxGui.CreatePluginFrame(
		"Crater",
		UDim2.new(0, 141, 0, 100),
		UDim2.new(0, 0, 0, 0),
		false,
		g
	)
craterDragBar.Visible = false
craterCloseEvent.Event:connect(function()
	Off()
end)

craterHelpFrame.Size = UDim2.new(0, 200, 0, 170)
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
	[[Creates craters in existing terrain.  Click on a point in terrain to make a crater.

Radius:
Half of the width of the crater to be created.

Depth:
A percentage value, representing a perfect spherical crater. 0% is no crater, 100% will make a crater the same depth as the radius.
]]
helpText.Parent = craterHelpFrame

--current radius display label
local radl = Instance.new "TextLabel"
radl.Position = UDim2.new(0, 0, 0, 10)
radl.Size = UDim2.new(1, 0, 0, 14)
radl.Text = ""
radl.BackgroundColor3 = Color3.new(0.4, 0.4, 0.4)
radl.TextColor3 = Color3.new(0.95, 0.95, 0.95)
radl.Font = Enum.Font.ArialBold
radl.FontSize = Enum.FontSize.Size14
radl.BorderColor3 = Color3.new(0, 0, 0)
radl.TextXAlignment = Enum.TextXAlignment.Left
radl.BackgroundTransparency = 1
radl.Parent = craterFrame

--radius slider
local radSliderGui, radSliderPosition =
	RbxGui.CreateSlider(128, 0, UDim2.new(0, 10, 0, 32))
radSliderGui.Parent = craterFrame
local radBar = radSliderGui:FindFirstChild "Bar"
radBar.Size = UDim2.new(1, -20, 0, 5)
radSliderPosition.Changed:connect(function()
	r = radSliderPosition.Value
	radl.Text = " Radius: " .. r
end)
radSliderPosition.Value = r

--current depth factor display label
local dfl = Instance.new "TextLabel"
dfl.Position = UDim2.new(0, 0, 0, 50)
dfl.Size = UDim2.new(1, 0, 0, 14)
dfl.Text = ""
dfl.BackgroundColor3 = Color3.new(0.4, 0.4, 0.4)
dfl.TextColor3 = Color3.new(0.95, 0.95, 0.95)
dfl.Font = Enum.Font.ArialBold
dfl.FontSize = Enum.FontSize.Size14
dfl.BorderColor3 = Color3.new(0, 0, 0)
dfl.TextXAlignment = Enum.TextXAlignment.Left
dfl.BackgroundTransparency = 1
dfl.Parent = craterFrame

--depth factor slider
local dfSliderGui, dfSliderPosition =
	RbxGui.CreateSlider(100, 0, UDim2.new(0, 10, 0, 72))
dfSliderGui.Parent = craterFrame
local dfBar = dfSliderGui:FindFirstChild "Bar"
dfBar.Size = UDim2.new(1, -20, 0, 5)
dfSliderPosition.Changed:connect(function()
	d = dfSliderPosition.Value
	dfl.Text = " Depth: " .. d .. "%"
end)
dfSliderPosition.Value = d

this.Deactivation:connect(function()
	Off()
end)

--------------------------
--SUCCESSFUL LOAD MESSAGE-
--------------------------
loaded = true
