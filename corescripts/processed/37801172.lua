local a,b=game:GetService'ScriptContext',false pcall(function()b=game:GetService
'UserInputService'.TouchEnabled end)a:AddCoreScript(60595695,a,
'/Libraries/LibraryRegistration/LibraryRegistration')local function waitForChild
(c,d)while not c:FindFirstChild(d)do c.ChildAdded:wait()end end local c=game:
GetService'ScriptContext'c:AddCoreScript(59002209,c,'CoreScripts/Sections')
waitForChild(game:GetService'CoreGui','RobloxGui')local d=game:GetService
'CoreGui':FindFirstChild'RobloxGui'if not b then c:AddCoreScript(36868950,d,
'CoreScripts/ToolTip')c:AddCoreScript(46295863,d,'CoreScripts/Settings')else c:
AddCoreScript(153556783,d,'CoreScripts/TouchControls')end c:AddCoreScript(
39250920,d,'CoreScripts/MainBotChatScript')c:AddCoreScript(48488451,d,
'CoreScripts/PopupScript')c:AddCoreScript(48488398,d,
'CoreScripts/NotificationScript')c:AddCoreScript(97188756,d,
'CoreScripts/ChatScript')c:AddCoreScript(107893730,d,
'CoreScripts/PurchasePromptScript')if not b or d.AbsoluteSize.Y>600 then c:
AddCoreScript(48488235,d,'CoreScripts/PlayerListScript')else delay(5,function()
if d.AbsoluteSize.Y>=600 then c:AddCoreScript(48488235,d,
'CoreScripts/PlayerListScript')end end)end if game.CoreGui.Version>=3 and game.
PlaceId~=130815926 then c:AddCoreScript(53878047,d,
'CoreScripts/BackpackScripts/BackpackBuilder')waitForChild(d,'CurrentLoadout')
waitForChild(d,'Backpack')local e=d.Backpack if game.CoreGui.Version>=7 then c:
AddCoreScript(89449093,e,'CoreScripts/BackpackScripts/BackpackManager')end game:
GetService'ScriptContext':AddCoreScript(89449008,e,
'CoreScripts/BackpackScripts/BackpackGear')c:AddCoreScript(53878057,d.
CurrentLoadout,'CoreScripts/BackpackScripts/LoadoutScript')if game.CoreGui.
Version>=8 then c:AddCoreScript(-1,e,
'CoreScripts/BackpackScripts/BackpackWardrobe')end end local e=not not game.
Workspace:FindFirstChild'PSVariable'if e then game:GetService'ScriptContext':
AddCoreScript(64164692,game.Players.LocalPlayer,'BuildToolManager')end game.
Workspace.ChildAdded:connect(function(f)if f.Name=='PSVariable'and f:IsA
'BoolValue'then e=true game:GetService'ScriptContext':AddCoreScript(64164692,
game.Players.LocalPlayer,'BuildToolManager')end end)if b then c:AddCoreScript(
152908679,d,'CoreScripts/ContextActionTouch')waitForChild(d,'ControlFrame')
waitForChild(d.ControlFrame,'BottomLeftControl')d.ControlFrame.BottomLeftControl
.Visible=false waitForChild(d.ControlFrame,'TopLeftControl')d.ControlFrame.
TopLeftControl.Visible=false end