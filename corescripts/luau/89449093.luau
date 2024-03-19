-- CoreGui.RobloxGui.Backpack.CoreScripts/BackpackScripts/Back (2?)
print "[Mercury]: Loaded corescript 89449093"

local News = require "../Modules/New"
local New = News.New
local Hydrate = News.Hydrate

local GuiService = game:GetService "GuiService"

-- basic functions
local function waitForChild(instance, name)
	while not instance:FindFirstChild(name) do
		instance.ChildAdded:wait()
	end
	return instance:FindFirstChild(name)
end
local function waitForProperty(instance, property)
	while not instance[property] do
		instance.Changed:wait()
	end
end

-- don't do anything if we are in an empty game
waitForChild(game, "Players")
if #game.Players:GetChildren() < 1 then
	game.Players.ChildAdded:wait()
end
-- make sure everything is loaded in before we do anything
-- get our local player
waitForProperty(game.Players, "LocalPlayer")

------------------------ Locals ------------------------------
local backpack = script.Parent :: GuiObject
waitForChild(backpack, "Gear")

local screen = backpack.Parent :: ScreenGui

waitForChild(backpack, "Tabs")
waitForChild(backpack.Tabs, "CloseButton")
local closeButton = backpack.Tabs.CloseButton

waitForChild(backpack.Tabs, "InventoryButton")
local inventoryButton: TextButton = backpack.Tabs.InventoryButton

waitForChild(backpack.Parent, "ControlFrame")
local backpackButton =
	waitForChild(backpack.Parent.ControlFrame, "BackpackButton")
local currentTab = "gear"

local searchFrame = waitForChild(backpack, "SearchFrame")
waitForChild(backpack.SearchFrame, "SearchBoxFrame")
local searchBox = waitForChild(backpack.SearchFrame.SearchBoxFrame, "SearchBox")
local searchButton = waitForChild(backpack.SearchFrame, "SearchButton")
local resetButton = waitForChild(backpack.SearchFrame, "ResetButton")

local robloxGui = waitForChild(Game.CoreGui, "RobloxGui")
local currentLoadout = waitForChild(robloxGui, "CurrentLoadout")
local loadoutBackground = waitForChild(currentLoadout, "Background")

local canToggle = true
local readyForNextEvent = true
local backpackIsOpen = false
local active = true
local disabledByDeveloper = false

local humanoidDiedCon

local guiTweenSpeed = 0.25 -- how quickly we open/close the backpack

local searchDefaultText = "Search..."
local tilde = "~"
local backtick = "`"

local backpackSize = UDim2.new(0, 600, 0, 400)

if robloxGui.AbsoluteSize.Y <= 320 then
	backpackSize = UDim2.new(0, 200, 0, 140)
end

------------------------ End Locals ---------------------------

---------------------------------------- Public Event Setup ----------------------------------------

function publicEvent(eventName: string)
	return New "BindableEvent" {
		Name = eventName,
		Parent = script,
	}
end

function publicFunction(funcName: string, invokeFunc: () -> ())
	return New "BindableFunction" {
		Name = funcName,
		OnInvoke = invokeFunc,
		Parent = script,
	}
end

-- Events
local resizeEvent = publicEvent "ResizeEvent"
local backpackOpenEvent = publicEvent "BackpackOpenEvent"
local backpackCloseEvent = publicEvent "BackpackCloseEvent"
local tabClickedEvent = publicEvent "TabClickedEvent"
local searchRequestedEvent = publicEvent "SearchRequestedEvent"
---------------------------------------- End Public Event Setup ----------------------------------------

--------------------------- Internal Functions ----------------------------------------

local function deactivateBackpack()
	backpack.Visible = false
	active = false
end

local function initHumanoidDiedConnections()
	if humanoidDiedCon then
		humanoidDiedCon:disconnect()
	end
	waitForProperty(game.Players.LocalPlayer, "Character")
	local localPlayer = game.Players.LocalPlayer
	waitForChild(localPlayer.Character, "Humanoid")
	humanoidDiedCon =
		localPlayer.Character.Humanoid.Died:connect(deactivateBackpack)
end

local function showBackpack()
	game.GuiService:AddCenterDialog(
		backpack,
		Enum.CenterDialogType.PlayerInitiatedDialog,
		function()
			backpack.Visible = true
			backpackButton.Selected = true
		end,
		function()
			backpack.Visible = false
			backpackButton.Selected = false
		end
	)
	backpack.Visible = true
	backpackButton.Selected = true
	backpack:TweenSizeAndPosition(
		backpackSize,
		UDim2.new(
			0.5,
			-backpackSize.X.Offset / 2,
			1,
			-backpackSize.Y.Offset - 88
		),
		Enum.EasingDirection.Out,
		Enum.EasingStyle.Quad,
		guiTweenSpeed,
		true
	)
	delay(guiTweenSpeed, function()
		backpack.Tabs.Visible = false
		searchFrame.Visible = true
		backpackOpenEvent:Fire(currentTab)
		canToggle = true
		readyForNextEvent = true
		backpackButton.Image = "http://banland.xyz/asset/?id=97644093"
		backpackButton.Position =
			UDim2.new(0.5, -60, 1, -backpackSize.Y.Offset - 103)
	end)
end

local function hideBackpack()
	backpackIsOpen = false
	readyForNextEvent = false
	backpackButton.Selected = false
	resetSearch()
	backpackCloseEvent:Fire(currentTab)
	backpack.Tabs.Visible = false
	searchFrame.Visible = false
	backpack:TweenSizeAndPosition(
		UDim2.new(0, backpackSize.X.Offset, 0, 0),
		UDim2.new(0.5, -backpackSize.X.Offset / 2, 1, -85),
		Enum.EasingDirection.Out,
		Enum.EasingStyle.Quad,
		guiTweenSpeed,
		true,
		function()
			game.GuiService:RemoveCenterDialog(backpack)
			backpack.Visible = false
			backpackButton.Selected = false
		end
	)
	delay(guiTweenSpeed, function()
		game.GuiService:RemoveCenterDialog(backpack)
		backpack.Visible = false
		backpackButton.Selected = false
		readyForNextEvent = true
		canToggle = true
	end)
end

local function toggleBackpack()
	if
		not (
			game.Players.LocalPlayer
			and game.Players.LocalPlayer.Character
			and canToggle
			and readyForNextEvent
		)
	then
		return
	end
	readyForNextEvent = false
	canToggle = false

	backpackIsOpen = not backpackIsOpen

	if backpackIsOpen then
		Hydrate(loadoutBackground) {
			Image = "http://banland.xyz/asset/?id=97623721",
			Position = UDim2.new(-0.03, 0, -0.17, 0),
			Size = UDim2.new(1.05, 0, 1.25, 0),
			ZIndex = 2.0,
			Visible = true,
		}
		showBackpack()
	else
		Hydrate(backpackButton) {
			Position = UDim2.new(0.5, -60, 1, -44),
			Selected = false,
			Image = "http://banland.xyz/asset/?id=97617958",
		}
		Hydrate(loadoutBackground) {
			Visible = false,
			Image = "http://banland.xyz/asset/?id=96536002",
			Position = UDim2.new(-0.1, 0, -0.1, 0),
			Size = UDim2.new(1.2, 0, 1.2, 0),
		}
		hideBackpack()

		local clChildren = currentLoadout:GetChildren()
		for i = 1, #clChildren do
			if clChildren[i] and clChildren[i]:IsA "Frame" then
				local frame = clChildren[i]
				if #frame:GetChildren() > 0 then
					backpackButton.Position = UDim2.new(0.5, -60, 1, -108)
					backpackButton.Visible = true
					loadoutBackground.Visible = true
					if frame:GetChildren()[1]:IsA "ImageButton" then
						local imgButton = frame:GetChildren()[1]
						imgButton.Active = true
						imgButton.Draggable = false
					end
				end
			end
		end
	end
end

local function activateBackpack()
	initHumanoidDiedConnections()
	active = true
	backpack.Visible = backpackIsOpen
	if backpackIsOpen then
		toggleBackpack()
	end
end

local function closeBackpack()
	if backpackIsOpen then
		toggleBackpack()
	end
end

local function updateTabGui(selectedTab: string)
	if selectedTab == "gear" then
		-- Selected
		Hydrate(inventoryButton) {
			BackgroundColor3 = Color3.new(1, 1, 1),
			TextColor3 = Color3.new(0, 0, 0),
			Selected = true,
			ZIndex = 3,
		}
	elseif selectedTab == "wardrobe" then
		-- Unselected
		Hydrate(inventoryButton) {
			BackgroundColor3 = Color3.new(0, 0, 0),
			TextColor3 = Color3.new(1, 1, 1),
			Selected = false,
			ZIndex = 1,
		}
	end
end

local function newTabClicked()
	updateTabGui(currentTab)
	tabClickedEvent:Fire(currentTab)
	resetSearch()
end

local function trim(s)
	return (s:gsub("^%s*(.-)%s*$", "%1"))
end

local function resetSearchBoxGui()
	resetButton.Visible = false
	searchBox.Text = searchDefaultText
end

local function doSearch()
	local searchText = searchBox.Text
	if searchText == "" then
		resetSearch()
		return
	end
	searchText = trim(searchText)
	resetButton.Visible = true
	searchRequestedEvent:Fire(searchText) -- todo: replace this with termtable when table passing is possible
end

function resetSearch()
	resetSearchBoxGui()
	searchRequestedEvent:Fire()
end

local backpackReady = function()
	readyForNextEvent = true
end

function coreGuiChanged(coreGuiType, enabled)
	if
		coreGuiType == Enum.CoreGuiType.Backpack
		or coreGuiType == Enum.CoreGuiType.All
	then
		active = enabled
		disabledByDeveloper = not enabled

		if disabledByDeveloper then
			pcall(function()
				GuiService:RemoveKey(tilde)
				GuiService:RemoveKey(backtick)
			end)
		else
			GuiService:AddKey(tilde)
			GuiService:AddKey(backtick)
		end

		resetSearch()
		searchFrame.Visible = enabled and backpackIsOpen

		currentLoadout.Visible = enabled
		backpack.Visible = enabled
		backpackButton.Visible = enabled
	end
end

--------------------------- End Internal Functions -------------------------------------

------------------------------ Public Functions Setup -------------------------------------
publicFunction("CloseBackpack", hideBackpack)
publicFunction("BackpackReady", backpackReady)

------------------------ Connections/Script Main -------------------------------------------

pcall(function()
	coreGuiChanged(
		Enum.CoreGuiType.Backpack,
		Game.StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Backpack)
	)
	Game.StarterGui.CoreGuiChangedSignal:connect(coreGuiChanged)
end)

inventoryButton.MouseButton1Click:connect(newTabClicked)
inventoryButton.MouseEnter:connect(function()
	if inventoryButton.Selected then
		return
	end

	inventoryButton.BackgroundColor3 = Color3.new(39 / 255, 39 / 255, 39 / 255)
end)
inventoryButton.MouseLeave:connect(function()
	if inventoryButton.Selected then
		return
	end

	inventoryButton.BackgroundColor3 = Color3.new(0, 0, 0)
end)

closeButton.MouseButton1Click:connect(closeBackpack)

screen.Changed:connect(function(prop)
	if prop == "AbsoluteSize" then
		resizeEvent:Fire(screen.AbsoluteSize)
	end
end)

-- GuiService key setup
GuiService:AddKey(tilde)
GuiService:AddKey(backtick)
GuiService.KeyPressed:connect(function(key)
	if not active or disabledByDeveloper then
		return
	elseif key == tilde or key == backtick then
		toggleBackpack()
	end
end)
backpackButton.MouseButton1Click:connect(function()
	if not active or disabledByDeveloper then
		return
	end
	toggleBackpack()
end)

if game.Players.LocalPlayer.Character then
	activateBackpack()
end

game.Players.LocalPlayer.CharacterAdded:connect(activateBackpack)

-- search functions
searchBox.FocusLost:connect(function(enterPressed)
	if enterPressed or searchBox.Text ~= "" then
		doSearch()
	elseif searchBox.Text == "" then
		resetSearch()
	end
end)
searchButton.MouseButton1Click:connect(doSearch)
resetButton.MouseButton1Click:connect(resetSearch)

if searchFrame and robloxGui.AbsoluteSize.Y <= 320 then
	searchFrame.RobloxLocked = false
	searchFrame:Destroy()
end
