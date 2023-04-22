print("[Mercury]: Loaded corescript 153556783")
local New
New = function(className, name, props)
	if not (props ~= nil) then
		props = name
		name = nil
	end
	local obj = Instance.new(className)
	if name then
		obj.Name = name
	end
	local parent
	for k, v in pairs(props) do
		if type(k) == "string" then
			if k == "Parent" then
				parent = v
			else
				obj[k] = v
			end
		elseif type(k) == "number" and type(v) == "userdata" then
			v.Parent = obj
		end
	end
	obj.Parent = parent
	return obj
end
while not Game do
	wait()
end
while not Game:FindFirstChild("Players") do
	wait()
end
while not Game.Players.LocalPlayer do
	wait()
end
while not Game:FindFirstChild("CoreGui") do
	wait()
end
while not Game.CoreGui:FindFirstChild("RobloxGui") do
	wait()
end
local userInputService = Game:GetService("UserInputService")
local success = pcall(function()
	return userInputService:IsLuaTouchControls()
end)
if not success then
	script:Destroy()
end
local screenResolution = Game:GetService("GuiService"):GetScreenResolution()
local isSmallScreenDevice
isSmallScreenDevice = function()
	return screenResolution.y <= 320
end
local localPlayer = Game.Players.LocalPlayer
local thumbstickSize = 120
if isSmallScreenDevice() then
	thumbstickSize = 70
end
local touchControlsSheet = "rbxasset://textures/ui/TouchControlsSheet.png"
local ThumbstickDeadZone = 5
local ThumbstickMaxPercentGive = 0.92
local thumbstickTouches = { }
local jumpButtonSize = 90
if isSmallScreenDevice() then
	jumpButtonSize = 70
end
local oldJumpTouches = { }
local currentJumpTouch
local CameraRotateSensitivity = 0.007
local CameraRotateDeadZone = CameraRotateSensitivity * 16
local CameraZoomSensitivity = 0.03
local PinchZoomDelay = 0.2
local cameraTouch
Game:GetService("ContentProvider"):Preload(touchControlsSheet)
local DistanceBetweenTwoPoints
DistanceBetweenTwoPoints = function(point1, point2)
	local dx = point2.x - point1.x
	local dy = point2.y - point1.y
	return math.sqrt(dx * dx + dy * dy)
end
local transformFromCenterToTopLeft
transformFromCenterToTopLeft = function(pointToTranslate, guiObject)
	return UDim2.new(0, pointToTranslate.x - guiObject.AbsoluteSize.x / 2, 0, pointToTranslate.y - guiObject.AbsoluteSize.y / 2)
end
local rotatePointAboutLocation
rotatePointAboutLocation = function(pointToRotate, pointToRotateAbout, radians)
	local sinAnglePercent = math.sin(radians)
	local cosAnglePercent = math.cos(radians)
	local transformedPoint = pointToRotate
	transformedPoint = Vector2.new(transformedPoint.x - pointToRotateAbout.x, transformedPoint.y - pointToRotateAbout.y)
	local xNew = transformedPoint.x * cosAnglePercent - transformedPoint.y * sinAnglePercent
	local yNew = transformedPoint.x * sinAnglePercent + transformedPoint.y * cosAnglePercent
	transformedPoint = Vector2.new(xNew + pointToRotateAbout.x, yNew + pointToRotateAbout.y)
	return transformedPoint
end
local dotProduct
dotProduct = function(v1, v2)
	return v1.x * v2.x + v1.y * v2.y
end
local stationaryThumbstickTouchMove
stationaryThumbstickTouchMove = function(thumbstickFrame, thumbstickOuter, touchLocation)
	local thumbstickOuterCenterPosition = Vector2.new(thumbstickOuter.Position.X.Offset + thumbstickOuter.AbsoluteSize.x / 2, thumbstickOuter.Position.Y.Offset + thumbstickOuter.AbsoluteSize.y / 2)
	local centerDiff = DistanceBetweenTwoPoints(touchLocation, thumbstickOuterCenterPosition)
	if centerDiff > (thumbstickSize / 2) then
		local thumbVector = Vector2.new(touchLocation.x - thumbstickOuterCenterPosition.x, touchLocation.y - thumbstickOuterCenterPosition.y)
		local normal = thumbVector.unit
		if normal.x == math.nan or normal.x == math.inf then
			normal = Vector2.new(0, normal.y)
		end
		if normal.y == math.nan or normal.y == math.inf then
			normal = Vector2.new(normal.x, 0)
		end
		local newThumbstickInnerPosition = thumbstickOuterCenterPosition + (normal * (thumbstickSize / 2))
		thumbstickFrame.Position = transformFromCenterToTopLeft(newThumbstickInnerPosition, thumbstickFrame)
	else
		thumbstickFrame.Position = transformFromCenterToTopLeft(touchLocation, thumbstickFrame)
	end
	return Vector2.new(thumbstickFrame.Position.X.Offset - thumbstickOuter.Position.X.Offset, thumbstickFrame.Position.Y.Offset - thumbstickOuter.Position.Y.Offset)
end
local followThumbstickTouchMove
followThumbstickTouchMove = function(thumbstickFrame, thumbstickOuter, touchLocation)
	local thumbstickOuterCenter = Vector2.new(thumbstickOuter.Position.X.Offset + thumbstickOuter.AbsoluteSize.x / 2, thumbstickOuter.Position.Y.Offset + thumbstickOuter.AbsoluteSize.y / 2)
	if DistanceBetweenTwoPoints(touchLocation, thumbstickOuterCenter) > thumbstickSize / 2 then
		local thumbstickInnerCenter = Vector2.new(thumbstickFrame.Position.X.Offset + thumbstickFrame.AbsoluteSize.x / 2, thumbstickFrame.Position.Y.Offset + thumbstickFrame.AbsoluteSize.y / 2)
		local movementVectorUnit = Vector2.new(touchLocation.x - thumbstickInnerCenter.x, touchLocation.y - thumbstickInnerCenter.y).unit
		local outerToInnerVectorCurrent = Vector2.new(thumbstickInnerCenter.x - thumbstickOuterCenter.x, thumbstickInnerCenter.y - thumbstickOuterCenter.y)
		local outerToInnerVectorCurrentUnit = outerToInnerVectorCurrent.unit
		local movementVector = Vector2.new(touchLocation.x - thumbstickInnerCenter.x, touchLocation.y - thumbstickInnerCenter.y)
		local crossOuterToInnerWithMovement = (outerToInnerVectorCurrentUnit.x * movementVectorUnit.y) - (outerToInnerVectorCurrentUnit.y * movementVectorUnit.x)
		local angle = math.atan2(crossOuterToInnerWithMovement, dotProduct(outerToInnerVectorCurrentUnit, movementVectorUnit))
		local anglePercent = angle * math.min(movementVector.magnitude / outerToInnerVectorCurrent.magnitude, 1.0)
		if math.abs(anglePercent) > 0.00001 then
			local outerThumbCenter = rotatePointAboutLocation(thumbstickOuterCenter, thumbstickInnerCenter, anglePercent)
			thumbstickOuter.Position = transformFromCenterToTopLeft(Vector2.new(outerThumbCenter.x, outerThumbCenter.y), thumbstickOuter)
		end
		thumbstickOuter.Position = UDim2.new(0, thumbstickOuter.Position.X.Offset + movementVector.x, 0, thumbstickOuter.Position.Y.Offset + movementVector.y)
	end
	thumbstickFrame.Position = transformFromCenterToTopLeft(touchLocation, thumbstickFrame)
	local thumbstickFramePosition = Vector2.new(thumbstickFrame.Position.X.Offset, thumbstickFrame.Position.Y.Offset)
	local thumbstickOuterPosition = Vector2.new(thumbstickOuter.Position.X.Offset, thumbstickOuter.Position.Y.Offset)
	if DistanceBetweenTwoPoints(thumbstickFramePosition, thumbstickOuterPosition) > thumbstickSize / 2 then
		local vectorWithLength = (thumbstickOuterPosition - thumbstickFramePosition).unit * thumbstickSize / 2
		thumbstickOuter.Position = UDim2.new(0, thumbstickFramePosition.x + vectorWithLength.x, 0, thumbstickFramePosition.y + vectorWithLength.y)
	end
	return Vector2.new(thumbstickFrame.Position.X.Offset - thumbstickOuter.Position.X.Offset, thumbstickFrame.Position.Y.Offset - thumbstickOuter.Position.Y.Offset)
end
local movementOutsideDeadZone
movementOutsideDeadZone = function(movementVector)
	return (math.abs(movementVector.x) > ThumbstickDeadZone) or (math.abs(movementVector.y) > ThumbstickDeadZone)
end
local constructThumbstick
constructThumbstick = function(defaultThumbstickPos, updateFunction, stationaryThumbstick)
	local thumbstickFrame = New("Frame", "ThumbstickFrame", {
		Active = true,
		Size = UDim2.new(0, thumbstickSize, 0, thumbstickSize),
		Position = defaultThumbstickPos,
		BackgroundTransparency = 1
	})
	New("ImageLabel", "InnerThumbstick", {
		Image = touchControlsSheet,
		ImageRectOffset = Vector2.new(220, 0),
		ImageRectSize = Vector2.new(111, 111),
		BackgroundTransparency = 1,
		Size = UDim2.new(0, thumbstickSize / 2, 0, thumbstickSize / 2),
		Position = UDim2.new(0, thumbstickFrame.Size.X.Offset / 2 - thumbstickSize / 4, 0, thumbstickFrame.Size.Y.Offset / 2 - thumbstickSize / 4),
		ZIndex = 2,
		Parent = thumbstickFrame
	})
	local outerThumbstick = New("ImageLabel", "OuterThumbstick", {
		Image = touchControlsSheet,
		ImageRectOffset = Vector2.new(0, 0),
		ImageRectSize = Vector2.new(220, 220),
		BackgroundTransparency = 1,
		Size = UDim2.new(0, thumbstickSize, 0, thumbstickSize),
		Position = defaultThumbstickPos,
		Parent = Game.CoreGui.RobloxGui
	})
	local thumbstickTouch
	local userInputServiceTouchMovedCon
	local userInputSeviceTouchEndedCon
	local startInputTracking
	startInputTracking = function(inputObject)
		if thumbstickTouch then
			return
		end
		if inputObject == cameraTouch then
			return
		end
		if inputObject == currentJumpTouch then
			return
		end
		if inputObject.UserInputType ~= Enum.UserInputType.Touch then
			return
		end
		thumbstickTouch = inputObject
		table.insert(thumbstickTouches, thumbstickTouch)
		thumbstickFrame.Position = transformFromCenterToTopLeft(thumbstickTouch.Position, thumbstickFrame)
		outerThumbstick.Position = thumbstickFrame.Position
		userInputServiceTouchMovedCon = userInputService.TouchMoved:connect(function(movedInput)
			if movedInput == thumbstickTouch then
				local movementVector
				if stationaryThumbstick then
					movementVector = stationaryThumbstickTouchMove(thumbstickFrame, outerThumbstick, Vector2.new(movedInput.Position.x, movedInput.Position.y))
				else
					movementVector = followThumbstickTouchMove(thumbstickFrame, outerThumbstick, Vector2.new(movedInput.Position.x, movedInput.Position.y))
				end
				if updateFunction then
					return updateFunction(movementVector, outerThumbstick.Size.X.Offset / 2)
				end
			end
		end)
		userInputSeviceTouchEndedCon = userInputService.TouchEnded:connect(function(endedInput)
			if endedInput == thumbstickTouch then
				if updateFunction then
					updateFunction(Vector2.new(0, 0), 1)
				end
				userInputSeviceTouchEndedCon:disconnect()
				userInputServiceTouchMovedCon:disconnect()
				thumbstickFrame.Position = defaultThumbstickPos
				outerThumbstick.Position = defaultThumbstickPos
				for i, object in pairs(thumbstickTouches) do
					if object == thumbstickTouch then
						table.remove(thumbstickTouches, i)
						break
					end
				end
				thumbstickTouch = nil
			end
		end)
	end
	userInputService.Changed:connect(function(prop)
		if prop == "ModalEnabled" then
			do
				local _tmp_0 = not userInputService.ModalEnabled
				thumbstickFrame.Visible = _tmp_0
				outerThumbstick.Visible = _tmp_0
			end
		end
	end)
	thumbstickFrame.InputBegan:connect(startInputTracking)
	return thumbstickFrame
end
local setupCharacterMovement
setupCharacterMovement = function(parentFrame)
	local lastMovementVector, lastMaxMovement
	local moveCharacterFunc = localPlayer.MoveCharacter
	local moveCharacterFunction
	moveCharacterFunction = function(movementVector, maxMovement)
		if localPlayer then
			if movementOutsideDeadZone(movementVector) then
				lastMovementVector = movementVector
				lastMaxMovement = maxMovement
				if movementVector.magnitude / maxMovement > ThumbstickMaxPercentGive then
					maxMovement = movementVector.magnitude - 1
				end
				return moveCharacterFunc(localPlayer, movementVector, maxMovement)
			else
				lastMovementVector = Vector2.new(0, 0)
				lastMaxMovement = 1
				return moveCharacterFunc(localPlayer, lastMovementVector, lastMaxMovement)
			end
		end
	end
	local thumbstickPos = UDim2.new(0, thumbstickSize / 2, 1, -thumbstickSize * 1.75)
	if isSmallScreenDevice() then
		thumbstickPos = UDim2.new(0, (thumbstickSize / 2) - 10, 1, -thumbstickSize - 20)
	end
	local characterThumbstick = constructThumbstick(thumbstickPos, moveCharacterFunction, false)
	characterThumbstick.Name = "CharacterThumbstick"
	characterThumbstick.Parent = parentFrame
	local refreshCharacterMovement
	refreshCharacterMovement = function()
		if localPlayer and moveCharacterFunc and lastMovementVector and lastMaxMovement then
			return moveCharacterFunc(localPlayer, lastMovementVector, lastMaxMovement)
		end
	end
	return refreshCharacterMovement
end
local setupJumpButton
setupJumpButton = function(parentFrame)
	local jumpButton = New("ImageButton", "JumpButton", {
		BackgroundTransparency = 1,
		Image = touchControlsSheet,
		ImageRectOffset = Vector2.new(176, 222),
		ImageRectSize = Vector2.new(174, 174),
		Size = UDim2.new(0, jumpButtonSize, 0, jumpButtonSize),
		Position = UDim2.new(1, (function()
			if isSmallScreenDevice() then
				return -(jumpButtonSize * 2.25), 1, -jumpButtonSize - 20
			else
				return -(jumpButtonSize * 2.75), 1, -jumpButtonSize - 120
			end
		end)())
	})
	local playerJumpFunc = localPlayer.JumpCharacter
	local doJumpLoop
	doJumpLoop = function()
		while currentJumpTouch do
			if localPlayer then
				playerJumpFunc(localPlayer)
			end
			wait(1 / 60)
		end
	end
	jumpButton.InputBegan:connect(function(inputObject)
		if inputObject.UserInputType ~= Enum.UserInputType.Touch then
			return
		end
		if currentJumpTouch then
			return
		end
		if inputObject == cameraTouch then
			return
		end
		for _, touch in pairs(oldJumpTouches) do
			if touch == inputObject then
				return
			end
		end
		currentJumpTouch = inputObject
		jumpButton.ImageRectOffset = Vector2.new(0, 222)
		jumpButton.ImageRectSize = Vector2.new(174, 174)
		return doJumpLoop()
	end)
	jumpButton.InputEnded:connect(function(inputObject)
		if inputObject.UserInputType ~= Enum.UserInputType.Touch then
			return
		end
		jumpButton.ImageRectOffset = Vector2.new(176, 222)
		jumpButton.ImageRectSize = Vector2.new(174, 174)
		if inputObject == currentJumpTouch then
			table.insert(oldJumpTouches, currentJumpTouch)
			currentJumpTouch = nil
		end
	end)
	userInputService.InputEnded:connect(function(globalInputObject)
		for i, touch in pairs(oldJumpTouches) do
			if touch == globalInputObject then
				table.remove(oldJumpTouches, i)
				break
			end
		end
	end)
	userInputService.Changed:connect(function(prop)
		if prop == "ModalEnabled" then
			jumpButton.Visible = not userInputService.ModalEnabled
		end
	end)
	jumpButton.Parent = parentFrame
end
local isTouchUsedByJumpButton
isTouchUsedByJumpButton = function(touch)
	if touch == currentJumpTouch then
		return true
	end
	for _, touchToCompare in pairs(oldJumpTouches) do
		if touch == touchToCompare then
			return true
		end
	end
	return false
end
local isTouchUsedByThumbstick
isTouchUsedByThumbstick = function(touch)
	for _, touchToCompare in pairs(thumbstickTouches) do
		if touch == touchToCompare then
			return true
		end
	end
	return false
end
local setupCameraControl
setupCameraControl = function(parentFrame, refreshCharacterMoveFunc)
	local lastPos
	local hasRotatedCamera = false
	local rotateCameraFunc = userInputService.RotateCamera
	local pinchTime = -1
	local shouldPinch = false
	local lastPinchScale
	local zoomCameraFunc = userInputService.ZoomCamera
	local pinchTouches = { }
	local pinchFrame
	local resetCameraRotateState
	resetCameraRotateState = function()
		cameraTouch = nil
		hasRotatedCamera = false
		lastPos = nil
	end
	local resetPinchState
	resetPinchState = function()
		pinchTouches = { }
		lastPinchScale = nil
		shouldPinch = false
		pinchFrame:Destroy()
		pinchFrame = nil
	end
	local startPinch
	startPinch = function(firstTouch, secondTouch)
		if pinchFrame ~= nil then
			pinchFrame:Destroy()
		end
		pinchFrame = New("Frame", {
			Name = "PinchFrame",
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			Parent = parentFrame
		})
		pinchFrame.InputChanged:connect(function(inputObject)
			if not shouldPinch then
				resetPinchState()
				return
			end
			resetCameraRotateState()
			if not (lastPinchScale ~= nil) then
				if inputObject == firstTouch then
					lastPinchScale = (inputObject.Position - secondTouch.Position).magnitude
					firstTouch = inputObject
				elseif inputObject == secondTouch then
					lastPinchScale = (inputObject.Position - firstTouch.Position).magnitude
					secondTouch = inputObject
				end
			else
				local newPinchDistance = 0
				if inputObject == firstTouch then
					newPinchDistance = (inputObject.Position - secondTouch.Position).magnitude
					firstTouch = inputObject
				elseif inputObject == secondTouch then
					newPinchDistance = (inputObject.Position - firstTouch.Position).magnitude
					secondTouch = inputObject
				end
				if newPinchDistance ~= 0 then
					local pinchDiff = newPinchDistance - lastPinchScale
					if pinchDiff ~= 0 then
						zoomCameraFunc(userInputService, (pinchDiff * CameraZoomSensitivity))
					end
					lastPinchScale = newPinchDistance
				end
			end
		end)
		return pinchFrame.InputEnded:connect(function(inputObject)
			if inputObject == firstTouch or inputObject == secondTouch then
				return resetPinchState()
			end
		end)
	end
	local pinchGestureReceivedTouch
	pinchGestureReceivedTouch = function(inputObject)
		if #pinchTouches < 1 then
			table.insert(pinchTouches, inputObject)
			pinchTime = tick()
			shouldPinch = false
		elseif #pinchTouches == 1 then
			shouldPinch = ((tick() - pinchTime) <= PinchZoomDelay)
			if shouldPinch then
				table.insert(pinchTouches, inputObject)
				return startPinch(pinchTouches[1], pinchTouches[2])
			else
				pinchTouches = { }
			end
		end
	end
	parentFrame.InputBegan:connect(function(inputObject)
		if inputObject.UserInputType ~= Enum.UserInputType.Touch then
			return
		end
		if isTouchUsedByJumpButton(inputObject) then
			return
		end
		local usedByThumbstick = isTouchUsedByThumbstick(inputObject)
		if not usedByThumbstick then
			pinchGestureReceivedTouch(inputObject)
		end
		if not (cameraTouch ~= nil) and not usedByThumbstick then
			cameraTouch = inputObject
			lastPos = Vector2.new(cameraTouch.Position.x, cameraTouch.Position.y)
		end
	end)
	userInputService.InputChanged:connect(function(inputObject)
		if inputObject.UserInputType ~= Enum.UserInputType.Touch then
			return
		end
		if cameraTouch ~= inputObject then
			return
		end
		local newPos = Vector2.new(cameraTouch.Position.x, cameraTouch.Position.y)
		local touchDiff = (lastPos - newPos) * CameraRotateSensitivity
		if not hasRotatedCamera and (touchDiff.magnitude > CameraRotateDeadZone) then
			hasRotatedCamera = true
			lastPos = newPos
		end
		if hasRotatedCamera and (lastPos ~= newPos) then
			rotateCameraFunc(userInputService, touchDiff)
			refreshCharacterMoveFunc()
			lastPos = newPos
		end
	end)
	return userInputService.InputEnded:connect(function(inputObject)
		if cameraTouch == inputObject or not (cameraTouch ~= nil) then
			resetCameraRotateState()
		end
		for i, touch in pairs(pinchTouches) do
			if touch == inputObject then
				table.remove(pinchTouches, i)
			end
		end
	end)
end
local setupTouchControls
setupTouchControls = function()
	local touchControlFrame = New("Frame", "TouchControlFrame", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Parent = Game.CoreGui.RobloxGui
	})
	local refreshCharacterMoveFunc = setupCharacterMovement(touchControlFrame)
	setupJumpButton(touchControlFrame)
	setupCameraControl(touchControlFrame, refreshCharacterMoveFunc)
	return userInputService.ProcessedEvent:connect(function(inputObject, processed)
		if not processed then
			return
		end
		if inputObject == cameraTouch and inputObject.UserInputState == Enum.UserInputState.Begin then
			cameraTouch = nil
		end
	end)
end
return setupTouchControls()
