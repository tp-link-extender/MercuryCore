print'[Mercury]: Loaded corescript 37801172'local a,b=game:GetService
'ScriptContext',false pcall(function()b=game:GetService'UserInputService'.
TouchEnabled end)a:AddCoreScript(60595695,a,
'/Libraries/LibraryRegistration/LibraryRegistration')local c c=function(d,e)
while not d:FindFirstChild(e)do d.ChildAdded:wait()end end a=game:GetService
'ScriptContext'a:AddCoreScript(59002209,a,'CoreScripts/Sections')c(game:
GetService'CoreGui','RobloxGui')local d=game:GetService'CoreGui':FindFirstChild
'RobloxGui'if not b then a:AddCoreScript(36868950,d,'CoreScripts/ToolTip')a:
AddCoreScript(46295863,d,'CoreScripts/Settings')else a:AddCoreScript(153556783,d
,'CoreScripts/TouchControls')end a:AddCoreScript(39250920,d,
'CoreScripts/MainBotChatScript')a:AddCoreScript(48488451,d,
'CoreScripts/PopupScript')a:AddCoreScript(48488398,d,
'CoreScripts/NotificationScript')a:AddCoreScript(97188756,d,
'CoreScripts/ChatScript')a:AddCoreScript(107893730,d,
'CoreScripts/PurchasePromptScript')if not b or d.AbsoluteSize.Y>600 then a:
AddCoreScript(48488235,d,'CoreScripts/PlayerListScript')else delay(5,function()
if d.AbsoluteSize.Y>=600 then return a:AddCoreScript(48488235,d,
'CoreScripts/PlayerListScript')end end)end if game.CoreGui.Version>=3 and game.
PlaceId~=130815926 then a:AddCoreScript(53878047,d,
'CoreScripts/BackpackScripts/BackpackBuilder')c(d,'CurrentLoadout')c(d,
'Backpack')local e=d.Backpack if game.CoreGui.Version>=7 then a:AddCoreScript(
89449093,e,'CoreScripts/BackpackScripts/BackpackManager')end a:AddCoreScript(
89449008,e,'CoreScripts/BackpackScripts/BackpackGear')a:AddCoreScript(53878057,d
.CurrentLoadout,'CoreScripts/BackpackScripts/LoadoutScript')if game.CoreGui.
Version>=8 then a:AddCoreScript(-1,e,
'CoreScripts/BackpackScripts/BackpackWardrobe')end end local e=not not game.
Workspace:FindFirstChild'PSVariable'if e then a:AddCoreScript(64164692,game.
Players.LocalPlayer,'BuildToolManager')end game.Workspace.ChildAdded:connect(
function(f)if f.Name=='PSVariable'and f:IsA'BoolValue'then e=true return a:
AddCoreScript(64164692,game.Players.LocalPlayer,'BuildToolManager')end end)if b
then a:AddCoreScript(152908679,d,'CoreScripts/ContextActionTouch')c(d,
'ControlFrame')c(d.ControlFrame,'BottomLeftControl')d.ControlFrame.
BottomLeftControl.Visible=false c(d.ControlFrame,'TopLeftControl')d.ControlFrame
.TopLeftControl.Visible=false end