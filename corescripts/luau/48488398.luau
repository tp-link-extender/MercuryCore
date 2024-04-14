--!strict
-- CoreGui.RobloxGui.CoreScripts/NotificationScript
print "[Mercury]: Loaded corescript 48488398"

local GuiService = game:GetService "GuiService"
local Players = game:GetService "Players"
local TeleportService = game:GetService "TeleportService"

local BaseUrl = require "../Modules/BaseUrl"
local path = BaseUrl.path

local function waitForProperty(instance: Instance, property: string)
	while not instance[property] do
		instance.Changed:wait()
	end
end
local function waitForChild(instance: Instance, name: string)
	while not instance:FindFirstChild(name) do
		instance.ChildAdded:wait()
	end
end

type Popup = Frame & {
	AcceptButton: TextButton,
	OKButton: TextButton,
	DeclineButton: TextButton,
	PopupText: TextLabel,
	PopupImage: ImageLabel,
}

local gui = script.Parent :: ScreenGui

local function getPopup()
	return gui:FindFirstChild "Popup" :: Popup
end

waitForProperty(Players, "LocalPlayer")
waitForChild(gui, "Popup")
waitForChild(getPopup(), "AcceptButton")
getPopup().AcceptButton.Modal = true

local localPlayer = Players.LocalPlayer
local teleportUI

local friendRequestBlacklist = {}

local teleportEnabled = true

local function makePopupInvisible()
	if getPopup() then
		getPopup().Visible = false
	end
end

local function showOneButton()
	local popup = gui:FindFirstChild "Popup" :: Popup
	if not popup then
		return
	end
	popup.OKButton.Visible = true
	popup.DeclineButton.Visible = false
	popup.AcceptButton.Visible = false
end

local function showTwoButtons()
	local popup = gui:FindFirstChild "Popup" :: Popup
	if not popup then
		return
	end
	popup.OKButton.Visible = false
	popup.DeclineButton.Visible = true
	popup.AcceptButton.Visible = true
end

local function makeFriend(fromPlayer, toPlayer)
	local popup = gui:FindFirstChild "Popup" :: Popup
	if
		popup == nil -- there is no popup!
		or popup.Visible -- currently popping something, abort!
		or friendRequestBlacklist[fromPlayer] -- previously cancelled friend request, we don't want it!
	then
		return
	end

	popup.PopupText.Text = `Accept Friend Request from {fromPlayer.Name}?`
	popup.PopupImage.Image =
		path(`thumbs/avatar.ashx?userId={fromPlayer.userId}&x=352&y=352`)

	showTwoButtons()
	popup.Visible = true
	popup.AcceptButton.Text = "Accept"
	popup.DeclineButton.Text = "Decline"
	popup:TweenSize(
		UDim2.new(0, 330, 0, 350),
		Enum.EasingDirection.Out,
		Enum.EasingStyle.Quart,
		1,
		true
	)

	local yesCon, noCon

	yesCon = popup.AcceptButton.MouseButton1Click:connect(function()
		popup.Visible = false
		toPlayer:RequestFriendship(fromPlayer)
		if yesCon then
			yesCon:disconnect()
		end
		if noCon then
			noCon:disconnect()
		end
		popup:TweenSize(
			UDim2.new(0, 0, 0, 0),
			Enum.EasingDirection.Out,
			Enum.EasingStyle.Quart,
			1,
			true,
			makePopupInvisible()
		)
	end)

	noCon = popup.DeclineButton.MouseButton1Click:connect(function()
		popup.Visible = false
		toPlayer:RevokeFriendship(fromPlayer)
		friendRequestBlacklist[fromPlayer] = true
		print "pop up blacklist"
		if yesCon then
			yesCon:disconnect()
		end
		if noCon then
			noCon:disconnect()
		end
		popup:TweenSize(
			UDim2.new(0, 0, 0, 0),
			Enum.EasingDirection.Out,
			Enum.EasingStyle.Quart,
			1,
			true,
			makePopupInvisible()
		)
	end)
end

Players.FriendRequestEvent:connect(function(fromPlr, toPlr, event)
	local toPlayer = toPlr :: Player
	local fromPlayer = fromPlr :: Player
	-- if this doesn't involve me, then do nothing
	if fromPlayer ~= localPlayer and toPlayer ~= localPlayer then
		return
	elseif fromPlayer == localPlayer then
		if event == Enum.FriendRequestEvent.Accept then
			GuiService:SendNotification(
				"You are Friends",
				`With {toPlayer.Name}!`,
				path(`thumbs/avatar.ashx?userId={toPlayer.userId}&x=48&y=48`),
				5,
				function() end
			)
		end
	elseif toPlayer == localPlayer then
		if event == Enum.FriendRequestEvent.Issue then
			if friendRequestBlacklist[fromPlayer] then
				return
			end -- previously cancelled friend request, we don't want it!
			GuiService:SendNotification(
				"Friend Request",
				`From {fromPlayer.Name}`,
				path(`thumbs/avatar.ashx?userId={fromPlayer.userId}&x=48&y=48`),
				8,
				function()
					makeFriend(fromPlayer, toPlayer)
				end
			)
		elseif event == Enum.FriendRequestEvent.Accept then
			GuiService:SendNotification(
				"You are Friends",
				`With {fromPlayer.Name}!`,
				path(`thumbs/avatar.ashx?userId={fromPlayer.userId}&x=48&y=48`),
				5,
				function() end
			)
		end
	end
end)

local function showTeleportUI(message, timer)
	if teleportUI ~= nil then
		teleportUI:Destroy()
	end
	waitForChild(localPlayer, "PlayerGui")
	teleportUI = Instance.new "Message"
	teleportUI.Text = message
	teleportUI.Parent = localPlayer.PlayerGui
	if timer > 0 then
		wait(timer)
		teleportUI:Destroy()
	end
end

local function onTeleport(teleportState)
	if TeleportService.CustomizedTeleportUI == false then
		if teleportState == Enum.TeleportState.Started then
			showTeleportUI("Teleport started...", 0)
		elseif teleportState == Enum.TeleportState.WaitingForServer then
			showTeleportUI("Requesting server...", 0)
		elseif teleportState == Enum.TeleportState.InProgress then
			showTeleportUI("Teleporting...", 0)
		elseif teleportState == Enum.TeleportState.Failed then
			showTeleportUI(
				"Teleport failed. Insufficient privileges or target place does not exist.",
				3
			)
		end
	end
end

if teleportEnabled then
	localPlayer.OnTeleport:connect(onTeleport)

	function TeleportService.ErrorCallback(message)
		local popup = gui:FindFirstChild "Popup" :: Popup
		showOneButton()
		popup.PopupText.Text = message
		local clickCon
		clickCon = popup.OKButton.MouseButton1Click:connect(function()
			TeleportService:TeleportCancel()
			if clickCon then
				clickCon:disconnect()
			end
			GuiService:RemoveCenterDialog(gui:FindFirstChild "Popup" :: Popup)
			popup:TweenSize(
				UDim2.new(0, 0, 0, 0),
				Enum.EasingDirection.Out,
				Enum.EasingStyle.Quart,
				1,
				true,
				makePopupInvisible()
			)
		end)
		GuiService:AddCenterDialog(
			gui:FindFirstChild "Popup" :: Popup,
			Enum.CenterDialogType.QuitDialog,
			--ShowFunction
			function()
				showOneButton()
				gui:FindFirstChild("Popup").Visible = true
				popup:TweenSize(
					UDim2.new(0, 330, 0, 350),
					Enum.EasingDirection.Out,
					Enum.EasingStyle.Quart,
					1,
					true
				)
			end,
			--HideFunction
			function()
				popup:TweenSize(
					UDim2.new(0, 0, 0, 0),
					Enum.EasingDirection.Out,
					Enum.EasingStyle.Quart,
					1,
					true,
					makePopupInvisible()
				)
			end
		)
	end
	function TeleportService.ConfirmationCallback(message, placeId, spawnName)
		local popup = getPopup()
		popup.PopupText.Text = message
		popup.PopupImage.Image = ""

		local yesCon, noCon

		local function killCons()
			if yesCon then
				yesCon:disconnect()
			end
			if noCon then
				noCon:disconnect()
			end
			GuiService:RemoveCenterDialog(getPopup())
			popup:TweenSize(
				UDim2.new(0, 0, 0, 0),
				Enum.EasingDirection.Out,
				Enum.EasingStyle.Quart,
				1,
				true,
				makePopupInvisible()
			)
		end

		yesCon = popup.AcceptButton.MouseButton1Click:connect(function()
			killCons()
			local ok, err = pcall(function()
				TeleportService:TeleportImpl(placeId, spawnName)
			end)
			if not ok then
				showOneButton()
				popup.PopupText.Text = err
				local clickCon
				clickCon = popup.OKButton.MouseButton1Click:connect(function()
					if clickCon then
						clickCon:disconnect()
					end
					GuiService:RemoveCenterDialog(getPopup())
					popup:TweenSize(
						UDim2.new(0, 0, 0, 0),
						Enum.EasingDirection.Out,
						Enum.EasingStyle.Quart,
						1,
						true,
						makePopupInvisible()
					)
				end)
				GuiService:AddCenterDialog(
					getPopup(),
					Enum.CenterDialogType.QuitDialog,
					--ShowFunction
					function()
						showOneButton()
						getPopup().Visible = true
						popup:TweenSize(
							UDim2.new(0, 330, 0, 350),
							Enum.EasingDirection.Out,
							Enum.EasingStyle.Quart,
							1,
							true
						)
					end,
					--HideFunction
					function()
						popup:TweenSize(
							UDim2.new(0, 0, 0, 0),
							Enum.EasingDirection.Out,
							Enum.EasingStyle.Quart,
							1,
							true,
							makePopupInvisible()
						)
					end
				)
			end
		end)

		noCon = popup.DeclineButton.MouseButton1Click:connect(function()
			killCons()
			pcall(function()
				TeleportService:TeleportCancel()
			end)
		end)

		local centerDialogSuccess = pcall(function()
			GuiService:AddCenterDialog(
				gui:FindFirstChild "Popup",
				Enum.CenterDialogType.QuitDialog,
				--ShowFunction
				function()
					showTwoButtons()
					popup.AcceptButton.Text = "Leave"
					popup.DeclineButton.Text = "Stay"
					gui:FindFirstChild("Popup").Visible = true
					popup:TweenSize(
						UDim2.new(0, 330, 0, 350),
						Enum.EasingDirection.Out,
						Enum.EasingStyle.Quart,
						1,
						true
					)
				end,
				--HideFunction
				function()
					popup:TweenSize(
						UDim2.new(0, 0, 0, 0),
						Enum.EasingDirection.Out,
						Enum.EasingStyle.Quart,
						1,
						true,
						makePopupInvisible()
					)
				end
			)
		end)

		if centerDialogSuccess == false then
			gui:FindFirstChild("Popup").Visible = true
			popup.AcceptButton.Text = "Leave"
			popup.DeclineButton.Text = "Stay"
			popup:TweenSize(
				UDim2.new(0, 330, 0, 350),
				Enum.EasingDirection.Out,
				Enum.EasingStyle.Quart,
				1,
				true
			)
		end
		return true
	end
end
