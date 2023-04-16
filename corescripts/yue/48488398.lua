local waitForProperty
waitForProperty = function(instance, property)
	while not instance[property] do
		instance.Changed:wait()
	end
end
local waitForChild
waitForChild = function(instance, name)
	while not instance:FindFirstChild(name) do
		instance.ChildAdded:wait()
	end
end
waitForProperty(game.Players, "LocalPlayer")
waitForChild(script.Parent, "Popup")
waitForChild(script.Parent.Popup, "AcceptButton")
script.Parent.Popup.AcceptButton.Modal = true
local localPlayer = game.Players.LocalPlayer
local teleportUI
local friendRequestBlacklist = { }
local teleportEnabled = true
local showOneButton
showOneButton = function()
	local popup = script.Parent:FindFirstChild("Popup")
	if popup then
		popup.OKButton.Visible = true
		popup.DeclineButton.Visible = false
		popup.AcceptButton.Visible = false
	end
	return popup
end
local showTwoButtons
showTwoButtons = function()
	local popup = script.Parent:FindFirstChild("Popup")
	if popup then
		popup.OKButton.Visible = false
		popup.DeclineButton.Visible = true
		popup.AcceptButton.Visible = true
	end
	return popup
end
local makePopupInvisible
makePopupInvisible = function()
	if script.Parent.Popup then
		script.Parent.Popup.Visible = false
	end
end
local makeFriend
makeFriend = function(fromPlayer, toPlayer)
	local popup = script.Parent:FindFirstChild("Popup")
	if not (popup ~= nil) then
		return
	end
	if popup.Visible then
		return
	end
	if friendRequestBlacklist[fromPlayer] then
		return
	end
	popup.PopupText.Text = "Accept Friend Request from " .. tostring(fromPlayer.Name) .. "?"
	popup.PopupImage.Image = "http://www.roblox.com/thumbs/avatar.ashx?userId=" .. tostring(fromPlayer.userId) .. "&x=352&y=352"
	showTwoButtons()
	popup.Visible = true
	popup.AcceptButton.Text = "Accept"
	popup.DeclineButton.Text = "Decline"
	popup:TweenSize(UDim2.new(0, 330, 0, 350), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 1, true)
	local yesCon, noCon
	yesCon = popup.AcceptButton.MouseButton1Click:connect(function()
		popup.Visible = false
		toPlayer:RequestFriendship(fromPlayer)
		if yesCon ~= nil then
			yesCon:disconnect()
		end
		if noCon ~= nil then
			noCon:disconnect()
		end
		return popup:TweenSize(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 1, true, makePopupInvisible())
	end)
	noCon = popup.DeclineButton.MouseButton1Click:connect(function()
		popup.Visible = false
		toPlayer:RevokeFriendship(fromPlayer)
		friendRequestBlacklist[fromPlayer] = true
		print("pop up blacklist")
		if yesCon ~= nil then
			yesCon:disconnect()
		end
		if noCon ~= nil then
			noCon:disconnect()
		end
		return popup:TweenSize(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 1, true, makePopupInvisible())
	end)
end
game.Players.FriendRequestEvent:connect(function(fromPlayer, toPlayer, event)
	if fromPlayer ~= localPlayer and toPlayer ~= localPlayer then
		return
	end
	if fromPlayer == localPlayer then
		if event == Enum.FriendRequestEvent.Accept then
			return game:GetService("GuiService"):SendNotification("You are Friends", "With " .. tostring(toPlayer.Name) .. "!", "http://www.roblox.com/thumbs/avatar.ashx?userId=" .. tostring(toPlayer.userId) .. "&x=48&y=48", 5, function() end)
		end
	elseif toPlayer == localPlayer then
		if event == Enum.FriendRequestEvent.Issue then
			if friendRequestBlacklist[fromPlayer] then
				return
			end
			return game:GetService("GuiService"):SendNotification("Friend Request", "From " .. tostring(fromPlayer.Name), "http://www.roblox.com/thumbs/avatar.ashx?userId=" .. tostring(fromPlayer.userId) .. "&x=48&y=48", 8, function()
				return makeFriend(fromPlayer, toPlayer)
			end)
		elseif event == Enum.FriendRequestEvent.Accept then
			return game:GetService("GuiService"):SendNotification("You are Friends", "With " .. tostring(fromPlayer.Name) .. "!", "http://www.roblox.com/thumbs/avatar.ashx?userId=" .. tostring(fromPlayer.userId) .. "&x=48&y=48", 5, function() end)
		end
	end
end)
local showTeleportUI
showTeleportUI = function(message, timer)
	if teleportUI ~= nil then
		teleportUI:Remove()
	end
	waitForChild(localPlayer, "PlayerGui")
	local _with_0 = Instance.new("Message")
	_with_0.Text = message
	_with_0.Parent = localPlayer.PlayerGui
	if timer > 0 then
		wait(timer)
		_with_0:Remove()
	end
	return _with_0
end
local onTeleport
onTeleport = function(teleportState, _, _)
	if game:GetService("TeleportService").CustomizedTeleportUI == false then
		return showTeleportUI((function()
			if Enum.TeleportState.Started == teleportState then
				return "Teleport started...", 0
			elseif Enum.TeleportState.WaitingForServer == teleportState then
				return "Requesting server...", 0
			elseif Enum.TeleportState.InProgress == teleportState then
				return "Teleporting...", 0
			elseif Enum.TeleportState.Failed == teleportState then
				return "Teleport failed. Insufficient privileges or target place does not exist.", 3
			end
		end)())
	end
end
if teleportEnabled then
	localPlayer.OnTeleport:connect(onTeleport)
	game:GetService("TeleportService").ErrorCallback = function(message)
		local popup = script.Parent:FindFirstChild("Popup")
		showOneButton()
		popup.PopupText.Text = message
		local clickCon
		clickCon = popup.OKButton.MouseButton1Click:connect(function()
			game:GetService("TeleportService"):TeleportCancel()
			if clickCon then
				clickCon:disconnect()
			end
			game.GuiService:RemoveCenterDialog(script.Parent:FindFirstChild("Popup"))
			return popup:TweenSize(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 1, true, makePopupInvisible())
		end)
		return game.GuiService:AddCenterDialog(script.Parent:FindFirstChild("Popup", Enum.CenterDialogType.QuitDialog), function()
			showOneButton()
			script.Parent:FindFirstChild("Popup").Visible = true
			return popup:TweenSize(UDim2.new(0, 330, 0, 350), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 1, true)
		end, function()
			return popup:TweenSize(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 1, true, makePopupInvisible())
		end)
	end
	game:GetService("TeleportService").ConfirmationCallback = function(message, placeId, spawnName)
		local popup = script.Parent:FindFirstChild("Popup")
		popup.PopupText.Text = message
		popup.PopupImage.Image = ""
		local yesCon, noCon
		local killCons
		killCons = function()
			if yesCon ~= nil then
				yesCon:disconnect()
			end
			if noCon ~= nil then
				noCon:disconnect()
			end
			game.GuiService:RemoveCenterDialog(script.Parent:FindFirstChild("Popup"))
			return popup:TweenSize(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 1, true, makePopupInvisible())
		end
		yesCon = popup.AcceptButton.MouseButton1Click:connect(function()
			killCons()
			local success, err
			success, err = pcall(function()
				return game:GetService("TeleportService"):TeleportImpl(placeId, spawnName)
			end)
			if not success then
				showOneButton()
				popup.PopupText.Text = err
				local clickCon
				clickCon = popup.OKButton.MouseButton1Click:connect(function()
					if clickCon ~= nil then
						clickCon:disconnect()
					end
					game.GuiService:RemoveCenterDialog(script.Parent:FindFirstChild("Popup"))
					return popup:TweenSize(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 1, true, makePopupInvisible())
				end)
				return game.GuiService:AddCenterDialog(script.Parent:FindFirstChild("Popup", Enum.CenterDialogType.QuitDialog), function()
					showOneButton()
					script.Parent:FindFirstChild("Popup").Visible = true
					return popup:TweenSize(UDim2.new(0, 330, 0, 350), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 1, true)
				end, function()
					return popup:TweenSize(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 1, true, makePopupInvisible())
				end)
			end
		end)
		noCon = popup.DeclineButton.MouseButton1Click:connect(function()
			killCons()
			return pcall(function()
				return game:GetService("TeleportService"):TeleportCancel()
			end)
		end)
		local centerDialogSuccess = pcall(function()
			return game.GuiService:AddCenterDialog(script.Parent:FindFirstChild("Popup", Enum.CenterDialogType.QuitDialog), function()
				showTwoButtons()
				popup.AcceptButton.Text = "Leave"
				popup.DeclineButton.Text = "Stay"
				script.Parent:FindFirstChild("Popup").Visible = true
				return popup:TweenSize(UDim2.new(0, 330, 0, 350), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 1, true)
			end, function()
				return popup:TweenSize(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 1, true, makePopupInvisible())
			end)
		end)
		if centerDialogSuccess == false then
			script.Parent:FindFirstChild("Popup").Visible = true
			popup.AcceptButton.Text = "Leave"
			popup.DeclineButton.Text = "Stay"
			popup:TweenSize(UDim2.new(0, 330, 0, 350), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 1, true)
		end
		return true
	end
end
