while not game do
	wait()
end

local ContentProvider = game:GetService "ContentProvider"
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

local this = PluginManager():CreatePlugin()
this.Deactivation:connect(function()
	Off()
end)

local toolbar = this:CreateToolbar "Terrain"
local toolbarbutton = toolbar:CreateButton(
	"Stamper",
	"Part Stamper - Toggle List (Shift + F)",
	"stamp.png"
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

-----------------
--DEFAULT VALUES-
-----------------
local currStampGui
local currStampId
local recentsFrame
local waterTypeChangedEvent
local waterForceAndDirection = { "None", "NegX" }

local setPanelVisibility
local getPanelVisibility

local stampControl
local lastStampModel

local keyCon

-- ids of users we want to load sets in from
local userSetIds =
	{ 11744447, 18881789, 18881808, 18881829, 18881853, 18881866 }
local recentButtonStack = {}

-- mouse management
local mouse

-- Libraries
local RbxStamper
local RbxGui

Spawn(function()
	RbxGui = LoadLibrary "RbxGui"
	RbxStamper = LoadLibrary "RbxStamper"
end)

local BaseUrl = ContentProvider.BaseUrl:lower()

-----------------------
--FUNCTION DEFINITIONS-
-----------------------

function getRbxGui()
	if not RbxGui then
		print "teh new rbxgui"
		RbxGui = LoadLibrary "RbxGui"
	end
	return RbxGui
end

function getRbxStamper()
	if not RbxStamper then
		print "teh new stamper"
		RbxStamper = LoadLibrary "RbxStamper"
	end
	return RbxStamper
end

function showLoadingDialog()
	currStampGui.LoadingFrame.LoadingText:TweenPosition(
		UDim2.new(0, 150, 0, 0),
		Enum.EasingDirection.Out,
		Enum.EasingStyle.Quad,
		2,
		true
	)
	currStampGui.LoadingFrame.Visible = true
end

function hideLoadingDialog()
	currStampGui.LoadingFrame.LoadingText:TweenPosition(
		UDim2.new(0, 0, 0, 0),
		Enum.EasingDirection.Out,
		Enum.EasingStyle.Quad,
		0.1,
		true
	)
	currStampGui.LoadingFrame.Visible = false
end

local stampCon

local function partSelected(name, id, terrainShape)
	if not (id and name) then
		return
	end

	currStampId = id

	if stampControl then
		stampControl.Destroy()
	end
	if stampCon then
		stampCon:disconnect()
		stampCon = nil
	end

	setPanelVisibility(false)

	showLoadingDialog()
	lastStampModel = getRbxStamper().GetStampModel(id, terrainShape)
	updateRecentParts(name, id, terrainShape)
	hideLoadingDialog()

	if lastStampModel.Name == "MegaClusterCube" then
		local clusterTag = lastStampModel:FindFirstChild "ClusterMaterial"
		-- we are going to stamp water, send info to stamper about this
		if
			clusterTag
			and clusterTag:isA "Vector3Value"
			and clusterTag.Value.X == 17
		then
			New "StringValue" {
				Name = "WaterForceTag",
				Value = waterForceAndDirection[1],
				Parent = lastStampModel,
			}
			New "StringValue" {
				Name = "WaterForceDirectionTag",
				Value = waterForceAndDirection[2],
				Parent = lastStampModel,
			}
		end
	end

	setupStamper(lastStampModel)
end

local function updateWaterInfo()
	if stampControl then
		stampControl.Destroy()
	end
	if stampCon then
		stampCon:disconnect()
		stampCon = nil
	end

	showLoadingDialog()
	lastStampModel = getRbxStamper().GetStampModel(currStampId)
	hideLoadingDialog()

	if lastStampModel.Name == "MegaClusterCube" then
		local clusterTag = lastStampModel:FindFirstChild "ClusterMaterial"
		-- we are going to stamp water, send info to stamper about this
		if clusterTag and clusterTag.Value.X == 17 then
			New "StringValue" {
				Name = "WaterForceTag",
				Value = waterForceAndDirection[1],
				Parent = lastStampModel,
			}
			New "StringValue" {
				Name = "WaterForceDirectionTag",
				Value = waterForceAndDirection[2],
				Parent = lastStampModel,
			}
		end
	end

	setupStamper(lastStampModel)
end

local function dialogClosed()
	if not lastStampModel then
		return
	elseif stampControl then
		stampControl.Destroy()
	end
	setupStamper(lastStampModel)
end

local function pickPart()
	if stampControl then
		stampControl.Destroy()
	end
	setPanelVisibility(true)
end

local function keyHandler(key)
	if key ~= "f" then
		return
	elseif getPanelVisibility() then
		-- handlePartShow
		setPanelVisibility(false)
		if lastStampModel then
			if stampControl then
				stampControl.Destroy()
			end
			setupStamper(lastStampModel)
		end
	else
		pickPart()
	end
end

function setupStamper(model)
	if not model then
		return
	end
	stampControl = getRbxStamper().SetupStamperDragger(model, mouse)
	if not stampControl then
		return
	end
	stampCon = stampControl.Stamped.Changed:connect(function()
		if stampControl.Stamped.Value then
			stampControl.ReloadModel()
		end
	end)
end

function updateRecentParts(newName, newId, newTerrainShape)
	if not newId then
		return
	end

	for i = 1, #recentButtonStack do
		if recentButtonStack[i].Id == newId then -- already have item, nothing to do
			return
		end
	end
	for i = #recentButtonStack - 1, 1, -1 do
		recentButtonStack[i + 1].Id = recentButtonStack[i].Id
		recentButtonStack[i + 1].Name = recentButtonStack[i].Name
		recentButtonStack[i + 1].TerrainShape =
			recentButtonStack[i].TerrainShape

		recentButtonStack[i + 1].Button.Image =
			recentButtonStack[i].Button.Image
	end

	recentButtonStack[1].Id = newId
	recentButtonStack[1].Name = newName
	recentButtonStack[1].TerrainShape = newTerrainShape
	recentButtonStack[1].Button.Image = BaseUrl
		.. "Game/Tools/ThumbnailAsset.ashx?fmt=png&wd=75&ht=75&aid="
		.. tostring(newId)
end

------
--GUI-
------

function createGui()
	--Insert Panel
	currStampGui, setPanelVisibility, getPanelVisibility, waterTypeChangedEvent =
		getRbxGui().CreateSetPanel(
			userSetIds,
			partSelected,
			dialogClosed,
			UDim2.new(0.8, 0, 0.9, 0),
			UDim2.new(0.1, 0, 0.05, 0),
			true
		)
	setPanelVisibility(false)

	currStampGui.Parent = CoreGui

	waterTypeChangedEvent.Event:connect(function(waterTable)
		waterForceAndDirection = waterTable
		updateWaterInfo()
	end)

	-- Loading Gui
	New "Frame" {
		Name = "LoadingFrame",
		Style = Enum.FrameStyle.RobloxRound,
		Size = UDim2.new(0, 350, 0, 60),
		Visible = false,
		Position = UDim2.new(0.5, -175, 0.5, -30),
		Parent = currStampGui,
		New "TextLabel" {
			Name = "LoadingText",
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 155, 1, 0),
			Font = Enum.Font.ArialBold,
			FontSize = Enum.FontSize.Size36,
			Text = "Loading...",
			TextColor3 = Color3.new(1, 1, 1),
			TextStrokeTransparency = 0,
		},
	}

	-- Recents Stack Gui
	recentsFrame = New "Frame" {
		BackgroundTransparency = 0.5,
		Name = "RecentsFrame",
		BackgroundColor3 = Color3.new(0, 0, 0),
		Size = UDim2.new(0, 50, 0, 150),
		Visible = false,
		Parent = currStampGui,
	}

	local function recentButton()
		return New "ImageButton" {
			Style = Enum.ButtonStyle.RobloxButton,
		}
	end

	for i = 1, 3 do
		recentButtonStack[i] = {}
		recentButtonStack[i].Name = nil
		recentButtonStack[i].Id = nil
		recentButtonStack[i].TerrainShape = nil
	end

	recentButtonStack[1].Button = Hydrate(recentButton()) {
		Name = "RecentButtonOne",
		Size = UDim2.new(0, 50, 0, 50),
		Parent = recentsFrame,
	}
	recentButtonStack[2].Button = Hydrate(recentButton()) {
		Name = "RecentButtonTwo",
		Position = UDim2.new(0, 0, 0, 50),
		Parent = recentsFrame,
	}
	recentButtonStack[3].Button = Hydrate(recentButton()) {
		Name = "RecentButtonThree",
		Position = UDim2.new(0, 0, 0, 100),
		Parent = recentsFrame,
	}

	local buttonClicked = false

	for i = 1, #recentButtonStack do
		recentButtonStack[i].Button.MouseButton1Click:connect(function()
			if buttonClicked then
				return
			end
			buttonClicked = true
			partSelected(
				recentButtonStack[i].Name,
				recentButtonStack[i].Id,
				recentButtonStack[i].TerrainShape
			)
			buttonClicked = false
		end)
	end
end

function On()
	if not workspace.Terrain then
		return
	elseif this then
		this:Activate(true)
		mouse = this:GetMouse()
	end

	if toolbarbutton then
		toolbarbutton:SetActive(true)
	end

	if not currStampGui then -- first load, lets make the gui
		createGui()
	end

	if setPanelVisibility then
		setPanelVisibility(true)
	end

	if recentsFrame then
		recentsFrame.Visible = true
	end

	if keyHandler then
		keyCon = mouse.KeyDown:connect(keyHandler)
	end

	on = true
end

function Off()
	if toolbarbutton then
		toolbarbutton:SetActive(false)
	end

	if stampControl then
		stampControl.Destroy()
	end

	if keyCon then
		keyCon:disconnect()
		keyCon = nil
	end

	if currStampGui and currStampGui:FindFirstChild "WaterFrame" then
		currStampGui.WaterFrame.Visible = false
	end

	if lastStampModel then
		lastStampModel:Destroy()
	end

	if setPanelVisibility then
		setPanelVisibility(false)
	end

	if recentsFrame then
		recentsFrame.Visible = false
	end

	on = false
end

--------------------------
--SUCCESSFUL LOAD MESSAGE-
--------------------------
loaded = true
