print("[Mercury]: Loaded corescript 89449093")
if game.CoreGui.Version < 7 then
	return
end
local waitForChild
waitForChild = function(instance, name)
	while not instance:FindFirstChild(name) do
		instance.ChildAdded:wait()
	end
	return instance:FindFirstChild(name)
end
local waitForProperty
waitForProperty = function(instance, property)
	while not instance[property] do
		instance.Changed:wait()
	end
end
waitForChild(game, "Players")
if #game.Players:GetChildren() < 1 then
	game.Players.ChildAdded:wait()
end
waitForProperty(game.Players, "LocalPlayer")
local backpack = script.Parent
waitForChild(backpack, "Gear")
local screen = script.Parent.Parent
assert(screen:IsA("ScreenGui"))
waitForChild(backpack, "Tabs")
waitForChild(backpack.Tabs, "CloseButton")
local closeButton = backpack.Tabs.CloseButton
waitForChild(backpack.Tabs, "InventoryButton")
local inventoryButton = backpack.Tabs.InventoryButton
local wardrobeButton
if game.CoreGui.Version >= 8 then
	waitForChild(backpack.Tabs, "WardrobeButton")
	wardrobeButton = backpack.Tabs.WardrobeButton
end
waitForChild(backpack.Parent, "ControlFrame")
local backpackButton = waitForChild(backpack.Parent.ControlFrame, "BackpackButton")
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
local guiTweenSpeed = 0.25
local searchDefaultText = "Search..."
local tilde = "~"
local backquote = "`"
local backpackSize = UDim2.new(0, 600, 0, 400)
if robloxGui.AbsoluteSize.Y <= 320 then
	backpackSize = UDim2.new(0, 200, 0, 140)
end
local createPublicEvent
createPublicEvent = function(eventName)
	assert(eventName, "eventName is nil")
	assert(tostring(eventName), "eventName is not a string")
	local _with_0 = Instance.new("BindableEvent")
	_with_0.Name = tostring(eventName)
	_with_0.Parent = script
	return _with_0
end
local createPublicFunction
createPublicFunction = function(funcName, invokeFunc)
	assert(funcName, "funcName is nil")
	assert(tostring(funcName), "funcName is not a string")
	assert(invokeFunc, "invokeFunc is nil")
	assert(type(invokeFunc) == "function", "invokeFunc should be of type 'function'")
	local _with_0 = Instance.new("BindableFunction")
	_with_0.Name = tostring(funcName)
	_with_0.OnInvoke = invokeFunc
	_with_0.Parent = script
	return _with_0
end
local resizeEvent = createPublicEvent("ResizeEvent")
local backpackOpenEvent = createPublicEvent("BackpackOpenEvent")
local backpackCloseEvent = createPublicEvent("BackpackCloseEvent")
local tabClickedEvent = createPublicEvent("TabClickedEvent")
local searchRequestedEvent = createPublicEvent("SearchRequestedEvent")
local resetSearchBoxGui
resetSearchBoxGui = function()
	resetButton.Visible = false
	searchBox.Text = searchDefaultText
end
local resetSearch
resetSearch = function()
	resetSearchBoxGui()
	return searchRequestedEvent:Fire()
end
local deactivateBackpack
deactivateBackpack = function()
	backpack.Visible = false
	active = false
end
local initHumanoidDiedConnections
initHumanoidDiedConnections = function()
	if humanoidDiedCon then
		humanoidDiedCon:disconnect()
	end
	waitForProperty(game.Players.LocalPlayer, "Character")
	waitForChild(game.Players.LocalPlayer.Character, "Humanoid")
	humanoidDiedCon = game.Players.LocalPlayer.Character.Humanoid.Died:connect(deactivateBackpack)
end
local hideBackpack
hideBackpack = function()
	backpackIsOpen = false
	readyForNextEvent = false
	backpackButton.Selected = false
	resetSearch()
	backpackCloseEvent:Fire(currentTab)
	backpack.Tabs.Visible = false
	searchFrame.Visible = false
	backpack:TweenSizeAndPosition(UDim2.new(0, backpackSize.X.Offset, 0, 0), UDim2.new(0.5, -backpackSize.X.Offset / 2, 1, -85), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, guiTweenSpeed, true, function()
		game.GuiService:RemoveCenterDialog(backpack)
		backpack.Visible = false
		backpackButton.Selected = false
	end)
	return delay(guiTweenSpeed, function()
		game.GuiService:RemoveCenterDialog(backpack)
		backpack.Visible = false
		backpackButton.Selected = false
		readyForNextEvent = true
		canToggle = true
	end)
end
local showBackpack
showBackpack = function()
	game.GuiService:AddCenterDialog(backpack, Enum.CenterDialogType.PlayerInitiatedDialog, function()
		backpack.Visible = true
		backpackButton.Selected = true
	end, function()
		backpack.Visible = false
		backpackButton.Selected = false
	end)
	backpack.Visible = true
	backpackButton.Selected = true
	backpack:TweenSizeAndPosition(backpackSize, UDim2.new(0.5, -backpackSize.X.Offset / 2, 1, -backpackSize.Y.Offset - 88), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, guiTweenSpeed, true)
	return delay(guiTweenSpeed, function()
		backpack.Tabs.Visible = false
		searchFrame.Visible = true
		backpackOpenEvent:Fire(currentTab)
		canToggle = true
		readyForNextEvent = true
		backpackButton.Image = "http://www.roblox.com/asset/?id=97644093"
		backpackButton.Position = UDim2.new(0.5, -60, 1, -backpackSize.Y.Offset - 103)
	end)
end
local toggleBackpack
toggleBackpack = function()
	if not game.Players.LocalPlayer then
		return
	end
	if not game.Players.LocalPlayer["Character"] then
		return
	end
	if not canToggle then
		return
	end
	if not readyForNextEvent then
		return
	end
	readyForNextEvent = false
	canToggle = false
	backpackIsOpen = not backpackIsOpen
	if backpackIsOpen then
		loadoutBackground.Image = "http://www.roblox.com/asset/?id=97623721"
		loadoutBackground.Position = UDim2.new(-0.03, 0, -0.17, 0)
		loadoutBackground.Size = UDim2.new(1.05, 0, 1.25, 0)
		loadoutBackground.ZIndex = 2.0
		loadoutBackground.Visible = true
		return showBackpack()
	else
		backpackButton.Position = UDim2.new(0.5, -60, 1, -44)
		loadoutBackground.Visible = false
		backpackButton.Selected = false
		backpackButton.Image = "http://www.roblox.com/asset/?id=97617958"
		loadoutBackground.Image = "http://www.roblox.com/asset/?id=96536002"
		loadoutBackground.Position = UDim2.new(-0.1, 0, -0.1, 0)
		loadoutBackground.Size = UDim2.new(1.2, 0, 1.2, 0)
		hideBackpack()
		local clChildren = currentLoadout:GetChildren()
		for i = 1, #clChildren do
			if clChildren[i] and clChildren[i]:IsA("Frame") then
				local frame = clChildren[i]
				if #frame:GetChildren() > 0 then
					backpackButton.Position = UDim2.new(0.5, -60, 1, -108)
					backpackButton.Visible = true
					loadoutBackground.Visible = true
					if frame:GetChildren()[1]:IsA("ImageButton") then
						local imgButton = frame:GetChildren()[1]
						imgButton.Active = true
						imgButton.Draggable = false
					end
				end
			end
		end
	end
end
local activateBackpack
activateBackpack = function()
	initHumanoidDiedConnections()
	active = true
	backpack.Visible = backpackIsOpen
	if backpackIsOpen then
		return toggleBackpack()
	end
end
local closeBackpack
closeBackpack = function()
	if backpackIsOpen then
		return toggleBackpack()
	end
end
local setSelected
setSelected = function(tab)
	assert(tab)
	assert(tab:IsA("TextButton"))
	tab.BackgroundColor3 = Color3.new(1, 1, 1)
	tab.TextColor3 = Color3.new(0, 0, 0)
	tab.Selected = true
	tab.ZIndex = 3
	return tab
end
local setUnselected
setUnselected = function(tab)
	assert(tab)
	assert(tab:IsA("TextButton"))
	tab.BackgroundColor3 = Color3.new(0, 0, 0)
	tab.TextColor3 = Color3.new(1, 1, 1)
	tab.Selected = false
	tab.ZIndex = 1
	return tab
end
local updateTabGui
updateTabGui = function(selectedTab)
	assert(selectedTab)
	if selectedTab == "gear" then
		setSelected(inventoryButton)
		return setUnselected(wardrobeButton)
	elseif selectedTab == "wardrobe" then
		setSelected(wardrobeButton)
		return setUnselected(inventoryButton)
	end
end
local mouseLeaveTab
mouseLeaveTab = function(button)
	assert(button)
	assert(button:IsA("TextButton"))
	if button.Selected then
		return
	end
	button.BackgroundColor3 = Color3.new(0, 0, 0)
end
local mouseOverTab
mouseOverTab = function(button)
	assert(button)
	assert(button:IsA("TextButton"))
	if button.Selected then
		return
	end
	button.BackgroundColor3 = Color3.new(39 / 255, 39 / 255, 39 / 255)
end
local newTabClicked
newTabClicked = function(tabName)
	assert(tabName)
	tabName = string.lower(tabName)
	currentTab = tabName
	updateTabGui(tabName)
	tabClickedEvent:Fire(tabName)
	return resetSearch()
end
local trim
trim = function(s)
	return s:gsub("^%s*(.-)%s*$", "%1")
end
local doSearch
doSearch = function()
	local searchText = searchBox.Text
	if searchText == "" then
		resetSearch()
		return
	end
	searchText = trim(searchText)
	resetButton.Visible = true
	return searchRequestedEvent:Fire(searchText)
end
local backpackReady
backpackReady = function()
	readyForNextEvent = true
end
local coreGuiChanged
coreGuiChanged = function(coreGuiType, enabled)
	if coreGuiType == Enum.CoreGuiType.Backpack or coreGuiType == Enum.CoreGuiType.All then
		active = enabled
		disabledByDeveloper = not enabled
		do
			local _with_0 = game:GetService("GuiService")
			if disabledByDeveloper then
pcall(function()
					_with_0:RemoveKey(tilde)
					return _with_0:RemoveKey(backquote)
				end)
			else
				_with_0:AddKey(tilde)
				_with_0:AddKey(backquote)
			end
		end
		resetSearch()
		searchFrame.Visible = enabled and backpackIsOpen
		currentLoadout.Visible = enabled
		backpack.Visible = enabled
		backpackButton.Visible = enabled
	end
end
createPublicFunction("CloseBackpack", hideBackpack)
createPublicFunction("BackpackReady", backpackReady)
pcall(function()
	coreGuiChanged(Enum.CoreGuiType.Backpack, Game.StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Backpack))
	return Game.StarterGui.CoreGuiChangedSignal:connect(coreGuiChanged)
end)
inventoryButton.MouseButton1Click:connect(function()
	return newTabClicked("gear")
end)
inventoryButton.MouseEnter:connect(function()
	return mouseOverTab(inventoryButton)
end)
inventoryButton.MouseLeave:connect(function()
	return mouseLeaveTab(inventoryButton)
end)
if game.CoreGui.Version >= 8 then
	wardrobeButton.MouseButton1Click:connect(function()
		return newTabClicked("wardrobe")
	end)
	wardrobeButton.MouseEnter:connect(function()
		return mouseOverTab(wardrobeButton)
	end)
	wardrobeButton.MouseLeave:connect(function()
		return mouseLeaveTab(wardrobeButton)
	end)
end
closeButton.MouseButton1Click:connect(closeBackpack)
screen.Changed:connect(function(prop)
	if prop == "AbsoluteSize" then
		return resizeEvent:Fire(screen.AbsoluteSize)
	end
end)
do
	local _with_0 = game:GetService("GuiService")
	_with_0:AddKey(tilde)
	_with_0:AddKey(backquote)
	_with_0.KeyPressed:connect(function(key)
		if not active or disabledByDeveloper then
			return
		end
		if key == tilde or key == backquote then
			return toggleBackpack()
		end
	end)
end
backpackButton.MouseButton1Click:connect(function()
	if not active or disabledByDeveloper then
		return
	end
	return toggleBackpack()
end)
if game.Players.LocalPlayer["Character"] then
	activateBackpack()
end
game.Players.LocalPlayer.CharacterAdded:connect(activateBackpack)
searchBox.FocusLost:connect(function(enterPressed)
	if enterPressed or searchBox.Text ~= "" then
		return doSearch()
	elseif searchBox.Text == "" then
		return resetSearch()
	end
end)
searchButton.MouseButton1Click:connect(doSearch)
resetButton.MouseButton1Click:connect(resetSearch)
if searchFrame and robloxGui.AbsoluteSize.Y <= 320 then
	searchFrame.RobloxLocked = false
	return searchFrame:Destroy()
end
