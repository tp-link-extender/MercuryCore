print("[Mercury]: Loaded corescript 37801172")
local scriptContext = game:GetService("ScriptContext")
local touchEnabled = false
pcall(function()
	touchEnabled = game:GetService("UserInputService").TouchEnabled
end)
scriptContext:AddCoreScript(60595695, scriptContext, "/Libraries/LibraryRegistration/LibraryRegistration")
local waitForChild
waitForChild = function(instance, name)
	while not instance:FindFirstChild(name) do
		instance.ChildAdded:wait()
	end
end
scriptContext = game:GetService("ScriptContext")
scriptContext:AddCoreScript(59002209, scriptContext, "CoreScripts/Sections")
waitForChild(game:GetService("CoreGui"), "RobloxGui")
local screenGui = game:GetService("CoreGui"):FindFirstChild("RobloxGui")
if not touchEnabled then
	scriptContext:AddCoreScript(36868950, screenGui, "CoreScripts/ToolTip")
	scriptContext:AddCoreScript(46295863, screenGui, "CoreScripts/Settings")
else
	scriptContext:AddCoreScript(153556783, screenGui, "CoreScripts/TouchControls")
end
scriptContext:AddCoreScript(39250920, screenGui, "CoreScripts/MainBotChatScript")
scriptContext:AddCoreScript(48488451, screenGui, "CoreScripts/PopupScript")
scriptContext:AddCoreScript(48488398, screenGui, "CoreScripts/NotificationScript")
scriptContext:AddCoreScript(97188756, screenGui, "CoreScripts/ChatScript")
scriptContext:AddCoreScript(107893730, screenGui, "CoreScripts/PurchasePromptScript")
if not touchEnabled or screenGui.AbsoluteSize.Y > 600 then
	scriptContext:AddCoreScript(48488235, screenGui, "CoreScripts/PlayerListScript")
else
	delay(5, function()
		if screenGui.AbsoluteSize.Y >= 600 then
			return scriptContext:AddCoreScript(48488235, screenGui, "CoreScripts/PlayerListScript")
		end
	end)
end
if game.CoreGui.Version >= 3 and game.PlaceId ~= 130815926 then
	scriptContext:AddCoreScript(53878047, screenGui, "CoreScripts/BackpackScripts/BackpackBuilder")
	waitForChild(screenGui, "CurrentLoadout")
	waitForChild(screenGui, "Backpack")
	local Backpack = screenGui.Backpack
	if game.CoreGui.Version >= 7 then
		scriptContext:AddCoreScript(89449093, Backpack, "CoreScripts/BackpackScripts/BackpackManager")
	end
	scriptContext:AddCoreScript(89449008, Backpack, "CoreScripts/BackpackScripts/BackpackGear")
	scriptContext:AddCoreScript(53878057, screenGui.CurrentLoadout, "CoreScripts/BackpackScripts/LoadoutScript")
	if game.CoreGui.Version >= 8 then
		scriptContext:AddCoreScript(-1, Backpack, "CoreScripts/BackpackScripts/BackpackWardrobe")
	end
end
local IsPersonalServer = not not game.Workspace:FindFirstChild("PSVariable")
if IsPersonalServer then
	scriptContext:AddCoreScript(64164692, game.Players.LocalPlayer, "BuildToolManager")
end
game.Workspace.ChildAdded:connect(function(nchild)
	if nchild.Name == "PSVariable" and nchild:IsA("BoolValue") then
		IsPersonalServer = true
		return scriptContext:AddCoreScript(64164692, game.Players.LocalPlayer, "BuildToolManager")
	end
end)
if touchEnabled then
	scriptContext:AddCoreScript(152908679, screenGui, "CoreScripts/ContextActionTouch")
	waitForChild(screenGui, "ControlFrame")
	waitForChild(screenGui.ControlFrame, "BottomLeftControl")
	screenGui.ControlFrame.BottomLeftControl.Visible = false
	waitForChild(screenGui.ControlFrame, "TopLeftControl")
	screenGui.ControlFrame.TopLeftControl.Visible = false
end
