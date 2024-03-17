-- Script Context.StarterScript
print "[Mercury]: Loaded corescript 37801172"

local ScriptContext = game:GetService "ScriptContext"
local CoreGui = game:GetService "CoreGui"

-- Creates all neccessary scripts for the gui on initial load, everything except build tools
-- Please note that these are loaded in a specific order to diminish errors/perceived load time by user

-- library registration
ScriptContext:AddCoreScript(
	60595695,
	ScriptContext,
	"/Libraries/LibraryRegistration/LibraryRegistration"
)

local function waitForChild(instance, name)
	while not instance:FindFirstChild(name) do
		instance.ChildAdded:wait()
	end
end

waitForChild(CoreGui, "RobloxGui")
local screenGui = CoreGui:FindFirstChild "RobloxGui"

-- ToolTipper  (creates tool tips for gui)
ScriptContext:AddCoreScript(36868950, screenGui, "CoreScripts/ToolTip")
-- SettingsScript
ScriptContext:AddCoreScript(46295863, screenGui, "CoreScripts/Settings")

-- MainBotChatScript
ScriptContext:AddCoreScript(
	39250920,
	screenGui,
	"CoreScripts/MainBotChatScript"
)

-- Popup Script
ScriptContext:AddCoreScript(48488451, screenGui, "CoreScripts/PopupScript")
-- Friend Notification Script (probably can use this script to expand out to other notifications)
ScriptContext:AddCoreScript(
	48488398,
	screenGui,
	"CoreScripts/NotificationScript"
)
-- Chat script
ScriptContext:AddCoreScript(97188756, screenGui, "CoreScripts/ChatScript")
-- Purchase Prompt Script
ScriptContext:AddCoreScript(
	107893730,
	screenGui,
	"CoreScripts/PurchasePromptScript"
)

if screenGui.AbsoluteSize.Y > 600 then
	-- New Player List
	ScriptContext:AddCoreScript(
		48488235,
		screenGui,
		"CoreScripts/PlayerListScript"
	)
else
	delay(5, function()
		if screenGui.AbsoluteSize.Y >= 600 then
			-- New Player List
			ScriptContext:AddCoreScript(
				48488235,
				screenGui,
				"CoreScripts/PlayerListScript"
			)
		end
	end)
end

-- Backpack Builder, creates most of the backpack gui
ScriptContext:AddCoreScript(
	53878047,
	screenGui,
	"CoreScripts/BackpackScripts/BackpackBuilder"
)

waitForChild(screenGui, "CurrentLoadout")
waitForChild(screenGui, "Backpack")
local Backpack = screenGui.Backpack

-- Manager handles all big backpack state changes, other scripts subscribe to this and do things accordingly
ScriptContext:AddCoreScript(
	89449093,
	Backpack,
	"CoreScripts/BackpackScripts/BackpackManager"
)

-- Backpack Gear (handles all backpack gear tab stuff)
ScriptContext:AddCoreScript(
	89449008,
	Backpack,
	"CoreScripts/BackpackScripts/BackpackGear"
)
-- Loadout Script, used for gear hotkeys
ScriptContext:AddCoreScript(
	53878057,
	screenGui.CurrentLoadout,
	"CoreScripts/BackpackScripts/LoadoutScript"
)

local IsPersonalServer = not not game.Workspace:FindFirstChild "PSVariable"
if IsPersonalServer then
	ScriptContext:AddCoreScript(
		64164692,
		game.Players.LocalPlayer,
		"BuildToolManager"
	)
end
game.Workspace.ChildAdded:connect(function(nchild)
	if nchild.Name == "PSVariable" and nchild:IsA "BoolValue" then
		IsPersonalServer = true
		ScriptContext:AddCoreScript(
			64164692,
			game.Players.LocalPlayer,
			"BuildToolManager"
		)
	end
end)
