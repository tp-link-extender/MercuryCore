print("[Mercury]: Loaded corescript 73157242")
local t = { }
local PlaneIntersection
PlaneIntersection = function(vectorPos)
	local hit = false
	local currCamera = game.Workspace.CurrentCamera
	local startPos
	do
		local _with_0 = currCamera.CoordinateFrame.p
		startPos = Vector3.new(_with_0.X, _with_0.Y, _with_0.Z)
	end
	local endPos = Vector3.new(vectorPos.X, vectorPos.Y, vectorPos.Z)
	local normal = Vector3.new(0, 1, 0)
	local p3 = Vector3.new(0, 0, 0)
	local startEndDot = normal:Dot(endPos - startPos)
	local cellPos = vectorPos
	if startEndDot ~= 0 then
		t = normal:Dot(p3 - startPos) / startEndDot
		if t >= 0 and t <= 1 then
			local intersection = ((endPos - startPos) * t) + startPos
			cellPos = game.Workspace.Terrain:WorldToCell(intersection)
			hit = true
		end
	end
	return cellPos, hit
end
local GetTerrainForMouse
GetTerrainForMouse = function(mouse)
	local cell = game.Workspace.Terrain:WorldToCellPreferSolid(Vector3.new(mouse.hit.x, mouse.hit.y, mouse.hit.z))
	local planeLoc
	if 0 == game.Workspace.Terrain:GetCell(cell.X, cell.Y, cell.Z).Value then
		cell = nil
		local hit
		planeLoc, hit = PlaneIntersection(Vector3.new(mouse.hit.x, mouse.hit.y, mouse.hit.z))
		if hit then
			cell = planeLoc
		end
	end
	return cell
end
local insertBoundingBoxOverlapVector = Vector3.new(0.3, 0.3, 0.3)
local rotatePartAndChildren
rotatePartAndChildren = function(part, rotCF, offsetFromOrigin)
	if part:IsA("BasePart") then
		part.CFrame = (rotCF * (part.CFrame - offsetFromOrigin)) + offsetFromOrigin
	end
	local partChildren = part:GetChildren()
	for c = 1, #partChildren do
		rotatePartAndChildren(partChildren[c], rotCF, offsetFromOrigin)
	end
end
local modelRotate
modelRotate = function(model, yAngle)
	local rotCF = CFrame.Angles(0, yAngle, 0)
	local offsetFromOrigin = model:GetModelCFrame().p
	return rotatePartAndChildren(model, rotCF, offsetFromOrigin)
end
local collectParts
collectParts = function(object, baseParts, scripts, decals)
	if object:IsA("BasePart") then
		baseParts[#baseParts + 1] = object
	elseif object:IsA("Script") then
		scripts[#scripts + 1] = object
	elseif object:IsA("Decal") then
		decals[#decals + 1] = object
	end
	for _, child in pairs(object:GetChildren()) do
		collectParts(child, baseParts, scripts, decals)
	end
end
local clusterPartsInRegion
clusterPartsInRegion = function(startVector, endVector)
	local cluster = game.Workspace:FindFirstChild("Terrain")
	local startCell = cluster:WorldToCell(startVector)
	local endCell = cluster:WorldToCell(endVector)
	local startX = startCell.X
	local startY = startCell.Y
	local startZ = startCell.Z
	local endX = endCell.X
	local endY = endCell.Y
	local endZ = endCell.Z
	if startX < cluster.MaxExtents.Min.X then
		startX = cluster.MaxExtents.Min.X
	end
	if startY < cluster.MaxExtents.Min.Y then
		startY = cluster.MaxExtents.Min.Y
	end
	if startZ < cluster.MaxExtents.Min.Z then
		startZ = cluster.MaxExtents.Min.Z
	end
	if endX > cluster.MaxExtents.Max.X then
		endX = cluster.MaxExtents.Max.X
	end
	if endY > cluster.MaxExtents.Max.Y then
		endY = cluster.MaxExtents.Max.Y
	end
	if endZ > cluster.MaxExtents.Max.Z then
		endZ = cluster.MaxExtents.Max.Z
	end
	for x = startX, endX do
		for y = startY, endY do
			for z = startZ, endZ do
				if cluster:GetCell(x, y, z).Value > 0 then
					return true
				end
			end
		end
	end
	return false
end
local findSeatsInModel
findSeatsInModel = function(parent, seatTable)
	if not parent then
		return
	end
	if parent.className == "Seat" or parent.className == "VehicleSeat" then
		table.insert(seatTable, parent)
	end
	local myChildren = parent:GetChildren()
	for j = 1, #myChildren do
		findSeatsInModel(myChildren[j], seatTable)
	end
end
local setSeatEnabledStatus
setSeatEnabledStatus = function(model, isEnabled)
	local seatList = { }
	findSeatsInModel(model, seatList)
	if isEnabled then
		for i = 1, #seatList do
			local nextSeat = seatList[i]:FindFirstChild("SeatWeld")
			while nextSeat do
				nextSeat:Remove()
				nextSeat = seatList[i]:FindFirstChild("SeatWeld")
			end
		end
	else
		for i = 1, #seatList do
			local fakeWeld = Instance.new("Weld")
			fakeWeld.Name = "SeatWeld"
			fakeWeld.Parent = seatList[i]
		end
	end
end
local autoAlignToFace
autoAlignToFace = function(parts)
	local aatf = parts:FindFirstChild("AutoAlignToFace")
	if aatf then
		return aatf.Value
	else
		return false
	end
end
local getClosestAlignedWorldDirection
getClosestAlignedWorldDirection = function(aVector3InWorld)
	local xDir = Vector3.new(1, 0, 0)
	local yDir = Vector3.new(0, 1, 0)
	local zDir = Vector3.new(0, 0, 1)
	local xDot = aVector3InWorld.x * xDir.x + aVector3InWorld.y * xDir.y + aVector3InWorld.z * xDir.z
	local yDot = aVector3InWorld.x * yDir.x + aVector3InWorld.y * yDir.y + aVector3InWorld.z * yDir.z
	local zDot = aVector3InWorld.x * zDir.x + aVector3InWorld.y * zDir.y + aVector3InWorld.z * zDir.z
	if math.abs(xDot) > math.abs(yDot) and math.abs(xDot) > math.abs(zDot) then
		if xDot > 0 then
			return 0
		else
			return 3
		end
	elseif math.abs(yDot) > math.abs(xDot) and math.abs(yDot) > math.abs(zDot) then
		if yDot > 0 then
			return 1
		else
			return 4
		end
	else
		if zDot > 0 then
			return 2
		else
			return 5
		end
	end
end
local positionPartsAtCFrame3
positionPartsAtCFrame3 = function(aCFrame, currentParts)
	local insertCFrame
	if not currentParts then
		return currentParts
	end
	if currentParts and (currentParts:IsA("Model") or currentParts:IsA("Tool")) then
		insertCFrame = currentParts:GetModelCFrame()
		currentParts:TranslateBy(aCFrame.p - insertCFrame.p)
	else
		currentParts.CFrame = aCFrame
	end
	return currentParts
end
local calcRayHitTime
calcRayHitTime = function(rayStart, raySlope, intersectionPlane)
	if math.abs(raySlope) < 0.01 then
		return 0
	end
	return (intersectionPlane - rayStart) / raySlope
end
local modelTargetSurface
modelTargetSurface = function(partOrModel, rayStart, rayEnd)
	if not partOrModel then
		return 0
	end
	local modelCFrame, modelSize
	if partOrModel:IsA("Model") then
		modelCFrame = partOrModel:GetModelCFrame()
		modelSize = partOrModel:GetModelSize()
	else
		modelCFrame = partOrModel.CFrame
		modelSize = partOrModel.Size
	end
	local mouseRayStart = modelCFrame:pointToObjectSpace(rayStart)
	local mouseRayEnd = modelCFrame:pointToObjectSpace(rayEnd)
	local mouseSlope = mouseRayEnd - mouseRayStart
	local xPositive = 1
	local yPositive = 1
	local zPositive = 1
	if mouseSlope.X > 0 then
		xPositive = -1
	end
	if mouseSlope.Y > 0 then
		yPositive = -1
	end
	if mouseSlope.Z > 0 then
		zPositive = -1
	end
	local xHitTime = calcRayHitTime(mouseRayStart.X, mouseSlope.X, modelSize.X / 2 * xPositive)
	local yHitTime = calcRayHitTime(mouseRayStart.Y, mouseSlope.Y, modelSize.Y / 2 * yPositive)
	local zHitTime = calcRayHitTime(mouseRayStart.Z, mouseSlope.Z, modelSize.Z / 2 * zPositive)
	local hitFace = 0
	if xHitTime > yHitTime then
		if xHitTime > zHitTime then
			hitFace = 1 * xPositive
		else
			hitFace = 3 * zPositive
		end
	else
		if yHitTime > zHitTime then
			hitFace = 2 * yPositive
		else
			hitFace = 3 * zPositive
		end
	end
	return hitFace
end
local getBoundingBox2
getBoundingBox2 = function(partOrModel)
	local minVec = Vector3.new(math.huge, math.huge, math.huge)
	local maxVec = Vector3.new(-math.huge, -math.huge, -math.huge)
	if partOrModel:IsA("Terrain") then
		minVec = Vector3.new(-2, -2, -2)
		maxVec = Vector3.new(2, 2, 2)
	elseif partOrModel:IsA("BasePart") then
		minVec = -0.5 * partOrModel.Size
		maxVec = -minVec
	else
		maxVec = partOrModel:GetModelSize() * 0.5
		minVec = -maxVec
	end
	local justifyValue = partOrModel:FindFirstChild("Justification")
	if (justifyValue ~= nil) then
		local justify = justifyValue.Value
		local two = Vector3.new(2, 2, 2)
		local actualBox = maxVec - minVec - Vector3.new(0.01, 0.01, 0.01)
		local containingGridBox = Vector3.new(4 * math.ceil(actualBox.x / 4), 4 * math.ceil(actualBox.y / 4), 4 * math.ceil(actualBox.z / 4))
		local adjustment = containingGridBox - actualBox
		minVec = minVec - (0.5 * adjustment * justify)
		maxVec = maxVec + (0.5 * adjustment * (two - justify))
	end
	return minVec, maxVec
end
local getBoundingBoxInWorldCoordinates
getBoundingBoxInWorldCoordinates = function(partOrModel)
	local minVec = Vector3.new(math.huge, math.huge, math.huge)
	local maxVec = Vector3.new(-math.huge, -math.huge, -math.huge)
	if partOrModel:IsA("BasePart") and not partOrModel:IsA("Terrain") then
		local vec1 = partOrModel.CFrame:pointToWorldSpace(-0.5 * partOrModel.Size)
		local vec2 = partOrModel.CFrame:pointToWorldSpace(0.5 * partOrModel.Size)
		minVec = Vector3.new(math.min(vec1.X, vec2.X), math.min(vec1.Y, vec2.Y), math.min(vec1.Z, vec2.Z))
		maxVec = Vector3.new(math.max(vec1.X, vec2.X), math.max(vec1.Y, vec2.Y), math.max(vec1.Z, vec2.Z))
	elseif not partOrModel:IsA("Terrain") then
		local vec1 = partOrModel:GetModelCFrame():pointToWorldSpace(-0.5 * partOrModel:GetModelSize())
		local vec2 = partOrModel:GetModelCFrame():pointToWorldSpace(0.5 * partOrModel:GetModelSize())
		minVec = Vector3.new(math.min(vec1.X, vec2.X), math.min(vec1.Y, vec2.Y), math.min(vec1.Z, vec2.Z))
		maxVec = Vector3.new(math.max(vec1.X, vec2.X), math.max(vec1.Y, vec2.Y), math.max(vec1.Z, vec2.Z))
	end
	return minVec, maxVec
end
local getTargetPartBoundingBox
getTargetPartBoundingBox = function(targetPart)
	return getBoundingBox2((function()
		if (targetPart.Parent:FindFirstChild("RobloxModel") ~= nil) then
			return targetPart.Parent
		else
			return targetPart
		end
	end)())
end
local getMouseTargetCFrame
getMouseTargetCFrame = function(targetPart)
	if (targetPart.Parent:FindFirstChild("RobloxModel") ~= nil) then
		if targetPart.Parent:IsA("Tool") then
			return targetPart.Parent.Handle.CFrame
		else
			return targetPart.Parent:GetModelCFrame()
		end
	else
		return targetPart.CFrame
	end
end
local isBlocker
isBlocker = function(part)
	if not part then
		return false
	end
	if not part.Parent then
		return false
	end
	if part:FindFirstChild("Humanoid") then
		return false
	end
	if part:FindFirstChild("RobloxStamper" or part:FindFirstChild("RobloxModel")) then
		return true
	end
	if part:IsA("Part") and not part.CanCollide then
		return false
	end
	if part == game.Lighting then
		return false
	end
	return isBlocker(part.Parent)
end
local spaceAboveCharacter
spaceAboveCharacter = function(charTorso, newTorsoY, stampData)
	local partsAboveChar = game.Workspace:FindPartsInRegion3(Region3.new(Vector3.new(charTorso.Position.X, newTorsoY, charTorso.Position.Z) - Vector3.new(0.75, 2.75, 0.75), Vector3.new(charTorso.Position.X, newTorsoY, charTorso.Position.Z) + Vector3.new(0.75, 1.75, 0.75)), charTorso.Parent, 100)
	for j = 1, #partsAboveChar do
		if partsAboveChar[j].CanCollide and not partsAboveChar[j]:IsDescendantOf(stampData.CurrentParts) then
			return false
		end
	end
	if clusterPartsInRegion(Vector3.new(charTorso.Position.X, newTorsoY, charTorso.Position.Z) - Vector3.new(0.75, 2.75, 0.75), Vector3.new(charTorso.Position.X, newTorsoY, charTorso.Position.Z) + Vector3.new(0.75, 1.75, 0.75)) then
		return false
	end
	return true
end
local findConfigAtMouseTarget
findConfigAtMouseTarget = function(Mouse, stampData)
	if not Mouse then
		return
	end
	if not stampData then
		return error("findConfigAtMouseTarget: stampData is nil")
	end
	if not stampData["CurrentParts"] then
		return
	end
	local grid = 4.0
	local admissibleConfig = false
	local targetConfig = CFrame.new(0, 0, 0)
	local minBB, maxBB = getBoundingBox2(stampData.CurrentParts)
	local diagBB = maxBB - minBB
	local insertCFrame
	if stampData.CurrentParts:IsA("Model") or stampData.CurrentParts:IsA("Tool") then
		insertCFrame = stampData.CurrentParts:GetModelCFrame()
	else
		insertCFrame = stampData.CurrentParts.CFrame
	end
	if Mouse then
		if stampData.CurrentParts:IsA("Tool") then
			Mouse.TargetFilter = stampData.CurrentParts.Handle
		else
			Mouse.TargetFilter = stampData.CurrentParts
		end
	end
	local hitPlane = false
	local targetPart
	local success = pcall(function()
		targetPart = Mouse.Target
	end)
	if not success then
		return admissibleConfig, targetConfig
	end
	local mouseHitInWorld = Vector3.new(0, 0, 0)
	if Mouse then
		mouseHitInWorld = Vector3.new(Mouse.Hit.x, Mouse.Hit.y, Mouse.Hit.z)
	end
	local cellPos
	if nil == targetPart then
		cellPos = GetTerrainForMouse(Mouse)
		if nil == cellPos then
			hitPlane = false
			return admissibleConfig, targetConfig
		else
			targetPart = game.Workspace.Terrain
			hitPlane = true
			cellPos = Vector3.new(cellPos.X - 1, cellPos.Y, cellPos.Z)
			mouseHitInWorld = game.Workspace.Terrain:CellCenterToWorld(cellPos.x, cellPos.y, cellPos.z)
		end
	end
	local minBBTarget, maxBBTarget
	minBBTarget, maxBBTarget = getTargetPartBoundingBox(targetPart)
	local diagBBTarget = maxBBTarget - minBBTarget
	local targetCFrame = getMouseTargetCFrame(targetPart)
	if targetPart:IsA("Terrain") then
		if not cluster then
			cluster = game.Workspace:FindFirstChild("Terrain")
		end
		local cellID = cluster:WorldToCellPreferSolid(mouseHitInWorld)
		if hitPlane then
			cellID = cellPos
		end
		targetCFrame = CFrame.new(game.Workspace.Terrain:CellCenterToWorld(cellID.x, cellID.y, cellID.z))
	end
	local mouseHitInTarget = targetCFrame:pointToObjectSpace(mouseHitInWorld)
	local targetVectorInWorld = Vector3.new(0, 0, 0)
	if Mouse then
		targetVectorInWorld = targetPart.CFrame:vectorToWorldSpace(Vector3.FromNormalId(Mouse.TargetSurface))
	end
	local targetRefPointInTarget, insertRefPointInInsert
	local clampToSurface
	if getClosestAlignedWorldDirection(targetVectorInWorld) == 0 then
		targetRefPointInTarget = targetCFrame:vectorToObjectSpace(Vector3.new(1, -1, 1))
		insertRefPointInInsert = insertCFrame:vectorToObjectSpace(Vector3.new(-1, -1, 1))
		clampToSurface = Vector3.new(0, 1, 1)
	elseif getClosestAlignedWorldDirection(targetVectorInWorld) == 3 then
		targetRefPointInTarget = targetCFrame:vectorToObjectSpace(Vector3.new(-1, -1, -1))
		insertRefPointInInsert = insertCFrame:vectorToObjectSpace(Vector3.new(1, -1, -1))
		clampToSurface = Vector3.new(0, 1, 1)
	elseif getClosestAlignedWorldDirection(targetVectorInWorld) == 1 then
		targetRefPointInTarget = targetCFrame:vectorToObjectSpace(Vector3.new(-1, 1, 1))
		insertRefPointInInsert = insertCFrame:vectorToObjectSpace(Vector3.new(-1, -1, 1))
		clampToSurface = Vector3.new(1, 0, 1)
	elseif getClosestAlignedWorldDirection(targetVectorInWorld) == 4 then
		targetRefPointInTarget = targetCFrame:vectorToObjectSpace(Vector3.new(-1, -1, 1))
		insertRefPointInInsert = insertCFrame:vectorToObjectSpace(Vector3.new(-1, 1, 1))
		clampToSurface = Vector3.new(1, 0, 1)
	elseif getClosestAlignedWorldDirection(targetVectorInWorld) == 2 then
		targetRefPointInTarget = targetCFrame:vectorToObjectSpace(Vector3.new(-1, -1, 1))
		insertRefPointInInsert = insertCFrame:vectorToObjectSpace(Vector3.new(-1, -1, -1))
		clampToSurface = Vector3.new(1, 1, 0)
	else
		targetRefPointInTarget = targetCFrame:vectorToObjectSpace(Vector3.new(1, -1, -1))
		insertRefPointInInsert = insertCFrame:vectorToObjectSpace(Vector3.new(1, -1, 1))
		clampToSurface = Vector3.new(1, 1, 0)
	end
	targetRefPointInTarget = targetRefPointInTarget * ((0.5 * diagBBTarget) + 0.5 * (maxBBTarget + minBBTarget))
	insertRefPointInInsert = insertRefPointInInsert * ((0.5 * diagBB) + 0.5 * (maxBB + minBB))
	local delta = mouseHitInTarget - targetRefPointInTarget
	local deltaClamped = Vector3.new(grid * math.modf(delta.x / grid), grid * math.modf(delta.y / grid), grid * math.modf(delta.z / grid))
	deltaClamped = deltaClamped * clampToSurface
	local targetTouchInTarget = deltaClamped + targetRefPointInTarget
	local TargetTouchRelToWorld = targetCFrame:pointToWorldSpace(targetTouchInTarget)
	local InsertTouchInWorld = insertCFrame:vectorToWorldSpace(insertRefPointInInsert)
	local posInsertOriginInWorld = TargetTouchRelToWorld - InsertTouchInWorld
	local _, _, _, R00, R01, R02, R10, R11, R12, R20, R21, R22
	_, _, _, R00, R01, R02, R10, R11, R12, R20, R21, R22 = insertCFrame:components()
	targetConfig = CFrame.new(posInsertOriginInWorld.x, posInsertOriginInWorld.y, posInsertOriginInWorld.z, R00, R01, R02, R10, R11, R12, R20, R21, R22)
	admissibleConfig = true
	return admissibleConfig, targetConfig, getClosestAlignedWorldDirection(targetVectorInWorld)
end
local truncateToCircleEighth
truncateToCircleEighth = function(bigValue, littleValue)
	local big = math.abs(bigValue)
	local little = math.abs(littleValue)
	local hypotenuse = math.sqrt(big * big + little * little)
	local frac = little / hypotenuse
	local bigSign = 1
	local littleSign = 1
	if bigValue < 0 then
		bigSign = -1
	end
	if littleValue < 0 then
		littleSign = -1
	end
	if frac > 0.382683432 then
		return 0.707106781 * hypotenuse * bigSign, 0.707106781 * hypotenuse * littleSign
	else
		return hypotenuse * bigSign, 0
	end
end
local saveTheWelds
saveTheWelds = function(object, manualWeldTable, manualWeldParentTable)
	if object:IsA("ManualWeld") or object:IsA("Rotate") then
		table.insert(manualWeldTable, object)
		return table.insert(manualWeldParentTable, object.Parent)
	else
		local children = object:GetChildren()
		for i = 1, #children do
			saveTheWelds(children[i], manualWeldTable, manualWeldParentTable)
		end
	end
end
local restoreTheWelds
restoreTheWelds = function(manualWeldTable, manualWeldParentTable)
	for i = 1, #manualWeldTable do
		manualWeldTable[i].Parent = manualWeldParentTable[i]
	end
end
t.CanEditRegion = function(partOrModel, EditRegion)
	if not EditRegion then
		return true, false
	end
	local minBB, maxBB
	minBB, maxBB = getBoundingBoxInWorldCoordinates(partOrModel)
	if minBB.X < EditRegion.CFrame.p.X - EditRegion.Size.X / 2 or minBB.Y < EditRegion.CFrame.p.Y - EditRegion.Size.Y / 2 or minBB.Z < EditRegion.CFrame.p.Z - EditRegion.Size.Z / 2 then
		return false, false
	end
	if maxBB.X > EditRegion.CFrame.p.X + EditRegion.Size.X / 2 or maxBB.Y > EditRegion.CFrame.p.Y + EditRegion.Size.Y / 2 or maxBB.Z > EditRegion.CFrame.p.Z + EditRegion.Size.Z / 2 then
		return false, false
	end
	return true, false
end
t.GetStampModel = function(assetId, terrainShape, useAssetVersionId)
	if assetId == 0 then
		return nil, "No Asset"
	end
	if assetId < 0 then
		return nil, "Negative Asset"
	end
	local UnlockInstances
	UnlockInstances = function(object)
		if object:IsA("BasePart") then
			object.Locked = false
		end
		for _, child in pairs(object:GetChildren()) do
			UnlockInstances(child)
		end
	end
	local getClosestColorToTerrainMaterial
	getClosestColorToTerrainMaterial = function(terrainValue)
		return BrickColor.new((function()
			if 1 == terrainValue then
				return "Bright green"
			elseif 2 == terrainValue then
				return "Bright yellow"
			elseif 3 == terrainValue then
				return "Bright red"
			elseif 4 == terrainValue then
				return "Sand red"
			elseif 5 == terrainValue then
				return "Black"
			elseif 6 == terrainValue then
				return "Dark stone grey"
			elseif 7 == terrainValue then
				return "Sand blue"
			elseif 8 == terrainValue then
				return "Deep orange"
			elseif 9 == terrainValue then
				return "Dark orange"
			elseif 10 == terrainValue then
				return "Reddish brown"
			elseif 11 == terrainValue then
				return "Light orange"
			elseif 12 == terrainValue then
				return "Light stone grey"
			elseif 13 == terrainValue then
				return "Sand green"
			elseif 14 == terrainValue then
				return "Medium stone grey"
			elseif 15 == terrainValue then
				return "Really red"
			elseif 16 == terrainValue then
				return "Really blue"
			elseif 17 == terrainValue then
				return "Bright blue"
			else
				return "Bright green"
			end
		end)())
	end
	local setupFakeTerrainPart
	setupFakeTerrainPart = function(cellMat, cellType, cellOrient)
		local newTerrainPiece
		if cellType == 1 or cellType == 4 then
			newTerrainPiece = Instance.new("WedgePart")
			newTerrainPiece.formFactor = "Custom"
		elseif cellType == 2 then
			newTerrainPiece = Instance.new("CornerWedgePart")
		else
			newTerrainPiece = Instance.new("Part")
			newTerrainPiece.formFactor = "Custom"
		end
		newTerrainPiece.Name = "MegaClusterCube"
		newTerrainPiece.Size = Vector3.new(4, 4, 4)
		newTerrainPiece.BottomSurface = "Smooth"
		newTerrainPiece.TopSurface = "Smooth"
		newTerrainPiece.BrickColor = getClosestColorToTerrainMaterial(cellMat)
		local sideways = 0
		local flipped = math.pi
		if cellType == 4 then
			sideways = -math.pi / 2
		end
		if cellType == 2 or cellType == 3 then
			flipped = 0
		end
		newTerrainPiece.CFrame = CFrame.Angles(0, math.pi / 2 * cellOrient + flipped, sideways)
		if cellType == 3 then
			local inverseCornerWedgeMesh = Instance.new("SpecialMesh")
			inverseCornerWedgeMesh.MeshType = "FileMesh"
			inverseCornerWedgeMesh.MeshId = "http://www.roblox.com/asset?id=66832495"
			inverseCornerWedgeMesh.Scale = Vector3.new(2, 2, 2)
			inverseCornerWedgeMesh.Parent = newTerrainPiece
		end
		local materialTag = Instance.new("Vector3Value")
		materialTag.Value = Vector3.new(cellMat, cellType, cellOrient)
		materialTag.Name = "ClusterMaterial"
		materialTag.Parent = newTerrainPiece
		return newTerrainPiece
	end
	local root
	local loader
	local loading = true
	if useAssetVersionId then
		loader = coroutine.create(function()
			root = game:GetService("InsertService"):LoadAssetVersion(assetId)
			loading = false
		end)
		coroutine.resume(loader)
	else
		loader = coroutine.create(function()
			root = game:GetService("InsertService"):LoadAsset(assetId)
			loading = false
		end)
		coroutine.resume(loader)
	end
	local lastGameTime = 0
	local totalTime = 0
	local maxWait = 8
	while loading and totalTime < maxWait do
		lastGameTime = tick()
		wait(1)
		totalTime = totalTime + (tick() - lastGameTime)
	end
	loading = false
	if totalTime >= maxWait then
		return nil, "Load Time Fail"
	end
	if root == nil then
		return nil, "Load Asset Fail"
	end
	if not root:IsA("Model") then
		return nil, "Load Type Fail"
	end
	local instances = root:GetChildren()
	if #instances == 0 then
		return nil, "Empty Model Fail"
	end
	UnlockInstances(root)
	root = root:GetChildren()[1]
	for _, instance in pairs(instances) do
		if instance:IsA("Team") then
			instance.Parent = game:GetService("Teams")
		elseif instance:IsA("Sky") then
			local lightingService = game:GetService("Lighting")
			for _, child in pairs(lightingService:GetChildren()) do
				if child:IsA("Sky") then
					child:Remove()
				end
			end
			instance.Parent = lightingService
			return
		end
	end
	if not (root:FindFirstChild("RobloxModel") ~= nil) then
		local stringTag = Instance.new("BoolValue")
		stringTag.Name = "RobloxModel"
		stringTag.Parent = root
		if not (root:FindFirstChild("RobloxStamper") ~= nil) then
			local stringTag2 = Instance.new("BoolValue")
			stringTag2.Name = "RobloxStamper"
			stringTag2.Parent = root
		end
	end
	if terrainShape then
		if root.Name == "MegaClusterCube" then
			if terrainShape == 6 then
				local autowedgeTag = Instance.new("BoolValue")
				autowedgeTag.Name = "AutoWedge"
				autowedgeTag.Parent = root
			else
				local clusterTag = root:FindFirstChild("ClusterMaterial")
				if clusterTag then
					if clusterTag:IsA("Vector3Value") then
						root = setupFakeTerrainPart(clusterTag.Value.X, terrainShape, clusterTag.Value.Z)
					else
						root = setupFakeTerrainPart(clusterTag.Value, terrainShape, 0)
					end
				else
					root = setupFakeTerrainPart(1, terrainShape, 0)
				end
			end
		end
	end
	return root
end
t.SetupStamperDragger = function(modelToStamp, Mouse, StampInModel, AllowedStampRegion, StampFailedFunc)
	if not modelToStamp then
		error("SetupStamperDragger: modelToStamp (first arg) is nil!  Should be a stamper model")
		return nil
	end
	if not modelToStamp:IsA("Model") and not modelToStamp:IsA("BasePart") then
		error("SetupStamperDragger: modelToStamp (first arg) is neither a Model or Part!")
		return nil
	end
	if not Mouse then
		error("SetupStamperDragger: Mouse (second arg) is nil!  Should be a mouse object")
		return nil
	end
	if not Mouse:IsA("Mouse") then
		error("SetupStamperDragger: Mouse (second arg) is not of type Mouse!")
		return nil
	end
	local stampInModel
	local allowedStampRegion
	local stampFailedFunc
	if StampInModel then
		if not StampInModel:IsA("Model") then
			error("SetupStamperDragger: StampInModel (optional third arg) is not of type 'Model'")
			return nil
		end
		if not AllowedStampRegion then
			error("SetupStamperDragger: AllowedStampRegion (optional fourth arg) is nil when StampInModel (optional third arg) is defined")
			return nil
		end
		stampFailedFunc = StampFailedFunc
		stampInModel = StampInModel
		allowedStampRegion = AllowedStampRegion
	end
	local gInitial90DegreeRotations = 0
	local stampData
	local mouseTarget
	local errorBox = Instance.new("SelectionBox")
	errorBox.Color = BrickColor.new("Bright red")
	errorBox.Transparency = 0
	errorBox.Archivable = false
	local adornPart = Instance.new("Part")
	adornPart.Parent = nil
	adornPart.formFactor = "Custom"
	adornPart.Size = Vector3.new(4, 4, 4)
	adornPart.CFrame = CFrame.new()
	adornPart.Archivable = false
	local adorn = Instance.new("SelectionBox")
	adorn.Color = BrickColor.new("Toothpaste")
	adorn.Adornee = adornPart
	adorn.Visible = true
	adorn.Transparency = 0
	adorn.Name = "HighScalabilityStamperLine"
	adorn.Archivable = false
	local HighScalabilityLine = { }
	HighScalabilityLine.Start = nil
	HighScalabilityLine.End = nil
	HighScalabilityLine.Adorn = adorn
	HighScalabilityLine.AdornPart = adornPart
	HighScalabilityLine.InternalLine = nil
	HighScalabilityLine.NewHint = true
	HighScalabilityLine.MorePoints = {
		nil,
		nil
	}
	HighScalabilityLine.MoreLines = {
		nil,
		nil
	}
	HighScalabilityLine.Dimensions = 1
	local control = { }
	local movingLock = false
	local stampUpLock = false
	local unstampableSurface = false
	local mouseCons = { }
	local keyCon
	local stamped = Instance.new("BoolValue")
	stamped.Archivable = false
	stamped.Value = false
	local lastTarget = { }
	lastTarget.TerrainOrientation = 0
	lastTarget.CFrame = 0
	local cellInfo = { }
	cellInfo.Material = 1
	cellInfo.clusterType = 0
	cellInfo.clusterOrientation = 0
	local isMegaClusterPart
	isMegaClusterPart = function()
		if not stampData then
			return false
		end
		if not stampData.CurrentParts then
			return false
		end
		return stampData.CurrentParts:FindFirstChild("ClusterMaterial", true) or (stampData.CurrentParts.Name == "MegaClusterCube")
	end
	local DoHighScalabilityRegionSelect
	DoHighScalabilityRegionSelect = function()
		local megaCube = stampData.CurrentParts:FindFirstChild("MegaClusterCube")
		if not megaCube then
			if not stampData.CurrentParts.Name == "MegaClusterCube" then
				return
			else
				megaCube = stampData.CurrentParts
			end
		end
		HighScalabilityLine.End = megaCube.CFrame.p
		local line
		local line2 = Vector3.new(0, 0, 0)
		local line3 = Vector3.new(0, 0, 0)
		if HighScalabilityLine.Dimensions == 1 then
			line = (HighScalabilityLine.End - HighScalabilityLine.Start)
			if math.abs(line.X) < math.abs(line.Y) then
				if math.abs(line.X) < math.abs(line.Z) then
					local newY, newZ
					if math.abs(line.Y) > math.abs(line.Z) then
						newY, newZ = truncateToCircleEighth(line.Y, line.Z)
					else
						newZ, newY = truncateToCircleEighth(line.Z, line.Y)
					end
					line = Vector3.new(0, newY, newZ)
				else
					local newY, newX
					newY, newX = truncateToCircleEighth(line.Y, line.X)
					line = Vector3.new(newX, newY, 0)
				end
			else
				if math.abs(line.Y) < math.abs(line.Z) then
					local newX, newZ
					if math.abs(line.X) > math.abs(line.Z) then
						newX, newZ = truncateToCircleEighth(line.X, line.Z)
					else
						newZ, newX = truncateToCircleEighth(line.Z, line.X)
					end
					line = Vector3.new(newX, 0, newZ)
				else
					local newX, newY
					newX, newY = truncateToCircleEighth(line.X, line.Y)
					line = Vector3.new(newX, newY, 0)
				end
			end
			HighScalabilityLine.InternalLine = line
		elseif HighScalabilityLine.Dimensions == 2 then
			line = HighScalabilityLine.MoreLines[1]
			line2 = HighScalabilityLine.End - HighScalabilityLine.MorePoints[1]
			line2 = line2 - (line.unit * line.unit:Dot(line2))
			local tempCFrame = CFrame.new(HighScalabilityLine.Start, HighScalabilityLine.Start + line)
			local yAxis = tempCFrame:vectorToWorldSpace(Vector3.new(0, 1, 0))
			local xAxis = tempCFrame:vectorToWorldSpace(Vector3.new(1, 0, 0))
			local xComp = xAxis:Dot(line2)
			local yComp = yAxis:Dot(line2)
			if math.abs(yComp) > math.abs(xComp) then
				line2 = line2 - (xAxis * xComp)
			else
				line2 = line2 - (yAxis * yComp)
			end
			HighScalabilityLine.InternalLine = line2
		elseif HighScalabilityLine.Dimensions == 3 then
			line = HighScalabilityLine.MoreLines[1]
			line2 = HighScalabilityLine.MoreLines[2]
			line3 = HighScalabilityLine.End - HighScalabilityLine.MorePoints[2]
			line3 = line3 - (line.unit * line.unit:Dot(line3))
			line3 = line3 - (line2.unit * line2.unit:Dot(line3))
			HighScalabilityLine.InternalLine = line3
		end
		local tempCFrame = CFrame.new(HighScalabilityLine.Start, HighScalabilityLine.Start + line)
		if HighScalabilityLine.Dimensions == 1 then
			HighScalabilityLine.AdornPart.Size = Vector3.new(4, 4, line.magnitude + 4)
			HighScalabilityLine.AdornPart.CFrame = tempCFrame + tempCFrame:vectorToWorldSpace(Vector3.new(2, 2, 2) - HighScalabilityLine.AdornPart.Size / 2)
		else
			local boxSize = tempCFrame:vectorToObjectSpace(line + line2 + line3)
			HighScalabilityLine.AdornPart.Size = Vector3.new(4, 4, 4) + Vector3.new(math.abs(boxSize.X), math.abs(boxSize.Y), math.abs(boxSize.Z))
			HighScalabilityLine.AdornPart.CFrame = tempCFrame + tempCFrame:vectorToWorldSpace(boxSize / 2)
		end
		local gui
		if game.Players["LocalPlayer"] then
			gui = game.Players.LocalPlayer:FindFirstChild("PlayerGui")
			if gui and gui:IsA("PlayerGui") then
				if (HighScalabilityLine.Dimensions == 1 and line.magnitude > 3) or HighScalabilityLine.Dimensions > 1 then
					HighScalabilityLine.Adorn.Parent = gui
				end
			end
		end
		if not (gui ~= nil) then
			gui = game:GetService("CoreGui")
			if (HighScalabilityLine.Dimensions == 1 and line.magnitude > 3) or HighScalabilityLine.Dimensions > 1 then
				HighScalabilityLine.Adorn.Parent = gui
			end
		end
	end
	local DoStamperMouseMove
	DoStamperMouseMove = function(Mouse)
		if not Mouse then
			error("Error: RbxStamper.DoStamperMouseMove: Mouse is nil")
			return
		end
		if not Mouse:IsA("Mouse") then
			error("Error: RbxStamper.DoStamperMouseMove: Mouse is of type", Mouse.className, "should be of type Mouse")
			return
		end
		if not Mouse.Target then
			local cellPos = GetTerrainForMouse(Mouse)
			if nil == cellPos then
				return
			end
		end
		if not stampData then
			return
		end
		local configFound, targetCFrame, targetSurface = findConfigAtMouseTarget(Mouse, stampData)
		if not configFound then
			error("RbxStamper.DoStamperMouseMove No configFound, returning")
			return
		end
		local numRotations = 0
		if autoAlignToFace(stampData.CurrentParts) and targetSurface ~= 1 and targetSurface ~= 4 then
			if targetSurface == 3 then
				numRotations = 0 - gInitial90DegreeRotations + autoAlignToFace(stampData.CurrentParts)
			elseif targetSurface == 0 then
				numRotations = 2 - gInitial90DegreeRotations + autoAlignToFace(stampData.CurrentParts)
			elseif targetSurface == 5 then
				numRotations = 3 - gInitial90DegreeRotations + autoAlignToFace(stampData.CurrentParts)
			elseif targetSurface == 2 then
				numRotations = 1 - gInitial90DegreeRotations + autoAlignToFace(stampData.CurrentParts)
			end
		end
		local ry = math.pi / 2
		gInitial90DegreeRotations = gInitial90DegreeRotations + numRotations
		if stampData.CurrentParts:IsA("Model") or stampData.CurrentParts:IsA("Tool") then
			modelRotate(stampData.CurrentParts, ry * numRotations)
		else
			stampData.CurrentParts.CFrame = CFrame.fromEulerAnglesXYZ(0, ry * numRotations, 0)({
				stampData.CurrentParts.CFrame
			})
		end
		local minBB, maxBB
		minBB, maxBB = getBoundingBoxInWorldCoordinates(stampData.CurrentParts)
		local currModelCFrame
		if stampData.CurrentParts:IsA("Model") then
			currModelCFrame = stampData.CurrentParts:GetModelCFrame()
		else
			currModelCFrame = stampData.CurrentParts.CFrame
		end
		minBB = minBB + (targetCFrame.p - currModelCFrame.p)
		maxBB = maxBB + (targetCFrame.p - currModelCFrame.p)
		if clusterPartsInRegion(minBB + insertBoundingBoxOverlapVector, maxBB - insertBoundingBoxOverlapVector) then
			if lastTarget.CFrame then
				if stampData.CurrentParts:FindFirstChild("ClusterMaterial", true) then
					local theClusterMaterial = stampData.CurrentParts:FindFirstChild("ClusterMaterial", true)
					if theClusterMaterial:IsA("Vector3Value") then
						local stampClusterMaterial = stampData.CurrentParts:FindFirstChild("ClusterMaterial", true)
						if stampClusterMaterial then
							stampClusterMaterial = clusterMat
						end
					end
				end
			end
			return
		end
		if isMegaClusterPart() then
			local cellToStamp = game.Workspace.Terrain:WorldToCell(targetCFrame.p)
			local newCFramePosition = game.Workspace.Terrain:CellCenterToWorld(cellToStamp.X, cellToStamp.Y, cellToStamp.Z)
			local _, _, _, R00, R01, R02, R10, R11, R12, R20, R21, R22
			_, _, _, R00, R01, R02, R10, R11, R12, R20, R21, R22 = targetCFrame:components()
			targetCFrame = CFrame.new(newCFramePosition.X, newCFramePosition.Y, newCFramePosition.Z, R00, R01, R02, R10, R11, R12, R20, R21, R22)
		end
		positionPartsAtCFrame3(targetCFrame, stampData.CurrentParts)
		lastTarget.CFrame = targetCFrame
		if stampData.CurrentParts:FindFirstChild("ClusterMaterial", true) then
			local clusterMat = stampData.CurrentParts:FindFirstChild("ClusterMaterial", true)
			if clusterMat:IsA("Vector3Value") then
				lastTarget.TerrainOrientation = clusterMat.Value.Z
			end
		end
		if Mouse and Mouse.Target and Mouse.Target.Parent then
			local modelInfo = Mouse.Target:FindFirstChild("RobloxModel")
			if not modelInfo then
				modelInfo = Mouse.Target.Parent:FindFirstChild("RobloxModel")
			end
			local myModelInfo = stampData.CurrentParts:FindFirstChild("UnstampableFaces")
			if true then
				local breakingFaces = ""
				local myBreakingFaces = ""
				if modelInfo and modelInfo.Parent:FindFirstChild("UnstampableFaces") then
					breakingFaces = modelInfo.Parent.UnstampableFaces.Value
				end
				if myModelInfo then
					myBreakingFaces = myModelInfo.Value
				end
				local hitFace = 0
				if modelInfo then
					hitFace = modelTargetSurface(modelInfo.Parent, game.Workspace.CurrentCamera.CoordinateFrame.p, Mouse.Hit.p)
				end
				for bf in string.gmatch(breakingFaces, "[^,]+") do
					if hitFace == tonumber(bf) then
						unstampableSurface = true
						game.JointsService:ClearJoinAfterMoveJoints()
						return
					end
				end
				hitFace = modelTargetSurface(stampData.CurrentParts, Mouse.Hit.p, game.Workspace.CurrentCamera.CoordinateFrame.p)
				for bf in string.gmatch(myBreakingFaces, "[^,]+") do
					if hitFace == tonumber(bf) then
						unstampableSurface = true
						game.JointsService:ClearJoinAfterMoveJoints()
						return
					end
				end
			end
		end
		unstampableSurface = false
		game.JointsService:SetJoinAfterMoveInstance(stampData.CurrentParts)
		if (not pcall(function()
			if Mouse and Mouse.Target and not (Mouse.Target.Parent:FindFirstChild("RobloxModel") ~= nil) then
				return
			else
				return
			end
		end)) then
			error("Error: RbxStamper.DoStamperMouseMove Mouse is nil on second check")
			game.JointsService:ClearJoinAfterMoveJoints()
			Mouse = nil
			return
		end
		if Mouse and Mouse.Target and not (Mouse.Target.Parent:FindFirstChild("RobloxModel") ~= nil) then
			game.JointsService:SetJoinAfterMoveTarget(Mouse.Target)
		else
			game.JointsService:SetJoinAfterMoveTarget(nil)
		end
		game.JointsService:ShowPermissibleJoints()
		if isMegaClusterPart() and HighScalabilityLine and HighScalabilityLine.Start then
			return DoHighScalabilityRegionSelect()
		end
	end
	local setupKeyListener
	setupKeyListener = function(key, Mouse)
		if control and control["Paused"] then
			return
		end
		key = string.lower(key)
		if key == "r" and not autoAlignToFace(stampData.CurrentParts) then
			gInitial90DegreeRotations = gInitial90DegreeRotations + 1
			local clusterValues = stampData.CurrentParts:FindFirstChild("ClusterMaterial", true)
			if clusterValues and clusterValues:IsA("Vector3Value") then
				clusterValues.Value = Vector3.new(clusterValues.Value.X, clusterValues.Value.Y, (clusterValues.Value.Z + 1) % 4)
			end
			local ry = math.pi / 2
			if stampData.CurrentParts:IsA("Model") or stampData.CurrentParts:IsA("Tool") then
				modelRotate(stampData.CurrentParts, ry)
			else
				stampData.CurrentParts.CFrame = CFrame.fromEulerAnglesXYZ(0, ry, 0) * stampData.CurrentParts.CFrame
			end
			local configFound, targetCFrame = findConfigAtMouseTarget(Mouse, stampData)
			if configFound then
				positionPartsAtCFrame3(targetCFrame, stampData.CurrentParts)
				return DoStamperMouseMove(Mouse)
			end
		elseif key == "c" then
			if HighScalabilityLine.InternalLine and HighScalabilityLine.InternalLine.magnitude > 0 and HighScalabilityLine.Dimensions < 3 then
				HighScalabilityLine.MorePoints[HighScalabilityLine.Dimensions] = HighScalabilityLine.End
				HighScalabilityLine.MoreLines[HighScalabilityLine.Dimensions] = HighScalabilityLine.InternalLine
				HighScalabilityLine.Dimensions = HighScalabilityLine.Dimensions + 1
				HighScalabilityLine.NewHint = true
			end
		end
	end
	keyCon = Mouse.KeyDown:connect(function(key)
		return setupKeyListener(key, Mouse)
	end)
	local resetHighScalabilityLine
	resetHighScalabilityLine = function()
		if HighScalabilityLine then
			HighScalabilityLine.Start = nil
			HighScalabilityLine.End = nil
			HighScalabilityLine.InternalLine = nil
			HighScalabilityLine.NewHint = true
		end
	end
	local flashRedBox
	flashRedBox = function()
		local gui = game.CoreGui
		if game:FindFirstChild("Players") then
			if game.Players["LocalPlayer"] then
				if game.Players.LocalPlayer:FindFirstChild("PlayerGui") then
					gui = game.Players.LocalPlayer.PlayerGui
				end
			end
		end
		if not stampData["ErrorBox"] then
			return
		end
		stampData.ErrorBox.Parent = gui
		if stampData.CurrentParts:IsA("Tool") then
			stampData.ErrorBox.Adornee = stampData.CurrentParts.Handle
		else
			stampData.ErrorBox.Adornee = stampData.CurrentParts
		end
		return delay(0, function()
			for _ = 1, 3 do
				if stampData["ErrorBox"] then
					stampData.ErrorBox.Visible = true
				end
				wait(0.13)
				if stampData["ErrorBox"] then
					stampData.ErrorBox.Visible = false
				end
				wait(0.13)
			end
			if stampData["ErrorBox"] then
				stampData.ErrorBox.Adornee = nil
				stampData.ErrorBox.Parent = Tool
			end
		end)
	end
	local DoStamperMouseDown
	DoStamperMouseDown = function(Mouse)
		if not Mouse then
			error("Error: RbxStamper.DoStamperMouseDown: Mouse is nil")
			return
		end
		if not Mouse:IsA("Mouse") then
			error("Error: RbxStamper.DoStamperMouseDown: Mouse is of type", Mouse.className, "should be of type Mouse")
			return
		end
		if not stampData then
			return
		end
		if isMegaClusterPart() then
			if Mouse and HighScalabilityLine then
				local megaCube = stampData.CurrentParts:FindFirstChild("MegaClusterCube", true)
				local terrain = game.Workspace.Terrain
				if megaCube then
					HighScalabilityLine.Dimensions = 1
					local tempCell = terrain:WorldToCell(megaCube.CFrame.p)
					HighScalabilityLine.Start = terrain:CellCenterToWorld(tempCell.X, tempCell.Y, tempCell.Z)
					return
				else
					HighScalabilityLine.Dimensions = 1
					local tempCell = terrain:WorldToCell(stampData.CurrentParts.CFrame.p)
					HighScalabilityLine.Start = terrain:CellCenterToWorld(tempCell.X, tempCell.Y, tempCell.Z)
					return
				end
			end
		end
	end
	local loadSurfaceTypes
	loadSurfaceTypes = function(part, surfaces)
		part.TopSurface = surfaces[1]
		part.BottomSurface = surfaces[2]
		part.LeftSurface = surfaces[3]
		part.RightSurface = surfaces[4]
		part.FrontSurface = surfaces[5]
		part.BackSurface = surfaces[6]
		return part
	end
	local saveSurfaceTypes
	saveSurfaceTypes = function(part, myTable)
		local tempTable = { }
		tempTable[1] = part.TopSurface
		tempTable[2] = part.BottomSurface
		tempTable[3] = part.LeftSurface
		tempTable[4] = part.RightSurface
		tempTable[5] = part.FrontSurface
		tempTable[6] = part.BackSurface
		myTable[part] = tempTable
	end
	local prepareModel
	prepareModel = function(model)
		if not model then
			return nil
		end
		local gDesiredTrans = 0.7
		local gStaticTrans = 1
		local clone = model:Clone()
		local scripts = { }
		local parts = { }
		local decals = { }
		stampData = { }
		stampData.DisabledScripts = { }
		stampData.TransparencyTable = { }
		stampData.MaterialTable = { }
		stampData.CanCollideTable = { }
		stampData.AnchoredTable = { }
		stampData.ArchivableTable = { }
		stampData.DecalTransparencyTable = { }
		stampData.SurfaceTypeTable = { }
		collectParts(clone, parts, scripts, decals)
		if #parts <= 0 then
			return nil, "no parts found in modelToStamp"
		end
		for _, script in pairs(scripts) do
			if not script.Disabled then
				script.Disabled = true
				stampData.DisabledScripts[#stampData.DisabledScripts + 1] = script
			end
		end
		for _, part in pairs(parts) do
			stampData.TransparencyTable[part] = part.Transparency
			part.Transparency = gStaticTrans + (1 - gStaticTrans) * part.Transparency
			stampData.MaterialTable[part] = part.Material
			part.Material = Enum.Material.Plastic
			stampData.CanCollideTable[part] = part.CanCollide
			part.CanCollide = false
			stampData.AnchoredTable[part] = part.Anchored
			part.Anchored = true
			stampData.ArchivableTable[part] = part.Archivable
			part.Archivable = false
			saveSurfaceTypes(part, stampData.SurfaceTypeTable)
			local fadeInDelayTime = 0.5
			local transFadeInTime = 0.5
			delay(0, function()
				wait(fadeInDelayTime)
				local begTime = tick()
				local currTime = begTime
				while (currTime - begTime) < transFadeInTime and part and part:IsA("BasePart") and part.Transparency > gDesiredTrans do
					local newTrans = 1 - (((currTime - begTime) / transFadeInTime) * (gStaticTrans - gDesiredTrans))
					if stampData["TransparencyTable"] and stampData.TransparencyTable[part] then
						part.Transparency = newTrans + (1 - newTrans) * stampData.TransparencyTable[part]
					end
					wait(0.03)
					currTime = tick()
				end
				if part and part:IsA("BasePart") then
					if stampData["TransparencyTable"] and stampData.TransparencyTable[part] then
						part.Transparency = gDesiredTrans + (1 - gDesiredTrans) * stampData.TransparencyTable[part]
					end
				end
			end)
		end
		for _, decal in pairs(decals) do
			stampData.DecalTransparencyTable[decal] = decal.Transparency
			decal.Transparency = gDesiredTrans + (1 - gDesiredTrans) * decal.Transparency
		end
		setSeatEnabledStatus(clone, true)
		setSeatEnabledStatus(clone, false)
		stampData.CurrentParts = clone
		if autoAlignToFace(clone) then
			stampData.CurrentParts:ResetOrientationToIdentity()
			gInitial90DegreeRotations = 0
		else
			local ry = gInitial90DegreeRotations * math.pi / 2
			if stampData.CurrentParts:IsA("Model") or stampData.CurrentParts:IsA("Tool") then
				modelRotate(stampData.CurrentParts, ry)
			else
				stampData.CurrentParts.CFrame = CFrame.fromEulerAnglesXYZ(0, ry, 0) * stampData.CurrentParts.CFrame
			end
		end
		local clusterMaterial = stampData.CurrentParts:FindFirstChild("ClusterMaterial", true)
		if clusterMaterial and clusterMaterial:IsA("Vector3Value") then
			clusterMaterial.Value = Vector3.new(clusterMaterial.Value.X, clusterMaterial.Value.Y, (clusterMaterial.Value.Z + gInitial90DegreeRotations) % 4)
		end
		local configFound, targetCFrame
		configFound, targetCFrame = findConfigAtMouseTarget(Mouse, stampData)
		if configFound then
			stampData.CurrentParts = positionPartsAtCFrame3(targetCFrame, stampData.CurrentParts)
		end
		game.JointsService:SetJoinAfterMoveInstance(stampData.CurrentParts)
		return clone, parts
	end
	local checkTerrainBlockCollisions
	checkTerrainBlockCollisions = function(cellPos, checkHighScalabilityStamp)
		local cellCenterToWorld = game.Workspace.Terrain.CellCenterToWorld
		local cellCenter = cellCenterToWorld(game.Workspace.Terrain, cellPos.X, cellPos.Y, cellPos.Z)
		local cellBlockingParts = game.Workspace:FindPartsInRegion3(Region3.new(cellCenter - Vector3.new(2, 2, 2) + insertBoundingBoxOverlapVector, cellCenter + Vector3.new(2, 2, 2) - insertBoundingBoxOverlapVector), stampData.CurrentParts, 100)
		local skipThisCell = false
		for b = 1, #cellBlockingParts do
			if isBlocker(cellBlockingParts[b]) then
				skipThisCell = true
				break
			end
		end
		if not skipThisCell then
			local alreadyPushedUp = { }
			for b = 1, #cellBlockingParts do
				if cellBlockingParts[b].Parent and not alreadyPushedUp[cellBlockingParts[b].Parent] and cellBlockingParts[b].Parent:FindFirstChild("Humanoid" and cellBlockingParts[b].Parent:FindFirstChild("Humanoid"):IsA("Humanoid")) then
					local blockingPersonTorso = cellBlockingParts[b].Parent:FindFirstChild("Torso")
					alreadyPushedUp[cellBlockingParts[b].Parent] = true
					if blockingPersonTorso then
						local newY = cellCenter.Y + 5
						if spaceAboveCharacter(blockingPersonTorso, newY, stampData) then
							blockingPersonTorso.CFrame = blockingPersonTorso.CFrame + Vector3.new(0, newY - blockingPersonTorso.CFrame.p.Y, 0)
						else
							skipThisCell = true
							break
						end
					end
				end
			end
		end
		if not skipThisCell then
			local canSetCell = true
			if checkHighScalabilityStamp then
				if allowedStampRegion then
					cellPos = cellCenterToWorld(game.Workspace.Terrain, cellPos.X, cellPos.Y, cellPos.Z)
					if (cellPos.X + 2 > allowedStampRegion.CFrame.p.X + allowedStampRegion.Size.X / 2) or (cellPos.X - 2 < allowedStampRegion.CFrame.p.X - allowedStampRegion.Size.X / 2) or (cellPos.Y + 2 > allowedStampRegion.CFrame.p.Y + allowedStampRegion.Size.Y / 2) or (cellPos.Y - 2 < allowedStampRegion.CFrame.p.Y - allowedStampRegion.Size.Y / 2) or (cellPos.Z + 2 > allowedStampRegion.CFrame.p.Z + allowedStampRegion.Size.Z / 2) or (cellPos.Z - 2 < allowedStampRegion.CFrame.p.Z - allowedStampRegion.Size.Z / 2) then
						canSetCell = false
					end
				end
			end
			return canSetCell
		end
		return false
	end
	local ResolveMegaClusterStamp
	ResolveMegaClusterStamp = function(checkHighScalabilityStamp)
		local cellSet = false
		local cluster = game.Workspace.Terrain
		local line = HighScalabilityLine.InternalLine
		local cMax = game.Workspace.Terrain.MaxExtents.Max
		local cMin = game.Workspace.Terrain.MaxExtents.Min
		local clusterMaterial = 1
		local clusterType = 0
		local clusterOrientation = 0
		local autoWedgeClusterParts = false
		if stampData.CurrentParts:FindFirstChild("AutoWedge") then
			autoWedgeClusterParts = true
		end
		if stampData.CurrentParts:FindFirstChild("ClusterMaterial", true) then
			clusterMaterial = stampData.CurrentParts:FindFirstChild("ClusterMaterial", true)
			if clusterMaterial:IsA("Vector3Value") then
				clusterType = clusterMaterial.Value.Y
				clusterOrientation = clusterMaterial.Value.Z
				clusterMaterial = clusterMaterial.Value.X
			elseif clusterMaterial:IsA("IntValue") then
				clusterMaterial = clusterMaterial.Value
			end
		end
		if HighScalabilityLine.Adorn.Parent and HighScalabilityLine.Start and ((HighScalabilityLine.Dimensions > 1) or (line and line.magnitude > 0)) then
			local startCell = game.Workspace.Terrain:WorldToCell(HighScalabilityLine.Start)
			local xInc = {
				0,
				0,
				0
			}
			local yInc = {
				0,
				0,
				0
			}
			local zInc = {
				0,
				0,
				0
			}
			local incrementVect = {
				nil,
				nil,
				nil
			}
			local stepVect = {
				Vector3.new(0, 0, 0),
				Vector3.new(0, 0, 0),
				Vector3.new(0, 0, 0)
			}
			local worldAxes = {
				Vector3.new(1, 0, 0),
				Vector3.new(0, 1, 0),
				Vector3.new(0, 0, 1)
			}
			local lines = { }
			if HighScalabilityLine.Dimensions > 1 then
				table.insert(lines, HighScalabilityLine.MoreLines[1])
			end
			if line and line.magnitude > 0 then
				table.insert(lines, line)
			end
			if HighScalabilityLine.Dimensions > 2 then
				table.insert(lines, HighScalabilityLine.MoreLines[2])
			end
			for i = 1, #lines do
				lines[i] = Vector3.new(math.floor(lines[i].X + 0.5), math.floor(lines[i].Y + 0.5), math.floor(lines[i].Z + 0.5))
				if lines[i].X > 0 then
					xInc[i] = 1
				elseif lines[i].X < 0 then
					xInc[i] = -1
				end
				if lines[i].Y > 0 then
					yInc[i] = 1
				elseif lines[i].Y < 0 then
					yInc[i] = -1
				end
				if lines[i].Z > 0 then
					zInc[i] = 1
				elseif lines[i].Z < 0 then
					zInc[i] = -1
				end
				incrementVect[i] = Vector3.new(xInc[i], yInc[i], zInc[i])
				if incrementVect[i].magnitude < 0.9 then
					incrementVect[i] = nil
				end
			end
			if not lines[2] then
				lines[2] = Vector3.new(0, 0, 0)
			end
			if not lines[3] then
				lines[3] = Vector3.new(0, 0, 0)
			end
			local waterForceTag = stampData.CurrentParts:FindFirstChild("WaterForceTag", true)
			local waterForceDirectionTag = stampData.CurrentParts:FindFirstChild("WaterForceDirectionTag", true)
			while stepVect[3].magnitude * 4 <= lines[3].magnitude do
				local outerStepVectIndex = 1
				while outerStepVectIndex < 4 do
					stepVect[2] = Vector3.new(0, 0, 0)
					while stepVect[2].magnitude * 4 <= lines[2].magnitude do
						local innerStepVectIndex = 1
						while innerStepVectIndex < 4 do
							stepVect[1] = Vector3.new(0, 0, 0)
							while stepVect[1].magnitude * 4 <= lines[1].magnitude do
								local stepVectSum = stepVect[1] + stepVect[2] + stepVect[3]
								local cellPos = Vector3int16.new(startCell.X + stepVectSum.X, startCell.Y + stepVectSum.Y, startCell.Z + stepVectSum.Z)
								if cellPos.X >= cMin.X and cellPos.Y >= cMin.Y and cellPos.Z >= cMin.Z and cellPos.X < cMax.X and cellPos.Y < cMax.Y and cellPos.Z < cMax.Z then
									local okToStampTerrainBlock = checkTerrainBlockCollisions(cellPos, checkHighScalabilityStamp)
									if okToStampTerrainBlock then
										if waterForceTag then
											cluster:SetWaterCell(cellPos.X, cellPos.Y, cellPos.Z, Enum.WaterForce[waterForceTag.Value], Enum.WaterDirection[waterForceDirectionTag.Value])
										else
											cluster:SetCell(cellPos.X, cellPos.Y, cellPos.Z, clusterMaterial, clusterType, clusterOrientation)
										end
										cellSet = true
										if autoWedgeClusterParts then
											game.Workspace.Terrain:AutowedgeCells(Region3int16.new(Vector3int16.new(cellPos.x - 1, cellPos.y - 1, cellPos.z - 1), Vector3int16.new(cellPos.x + 1, cellPos.y + 1, cellPos.z + 1)))
										end
									end
								end
								stepVect[1] = stepVect[1] + incrementVect[1]
							end
							if incrementVect[2] then
								while innerStepVectIndex < 4 and worldAxes[innerStepVectIndex]:Dot(incrementVect[2]) == 0 do
									innerStepVectIndex = innerStepVectIndex + 1
								end
								if innerStepVectIndex < 4 then
									stepVect[2] = stepVect[2] + worldAxes[innerStepVectIndex] * worldAxes[innerStepVectIndex]:Dot(incrementVect[2])
								end
								innerStepVectIndex = innerStepVectIndex + 1
							else
								stepVect[2] = Vector3.new(1, 0, 0)
								innerStepVectIndex = 4
							end
							if stepVect[2].magnitude * 4 > lines[2].magnitude then
								innerStepVectIndex = 4
							end
						end
					end
					if incrementVect[3] then
						while outerStepVectIndex < 4 and worldAxes[outerStepVectIndex]:Dot(incrementVect[3]) == 0 do
							outerStepVectIndex = outerStepVectIndex + 1
						end
						if outerStepVectIndex < 4 then
							stepVect[3] = stepVect[3] + worldAxes[outerStepVectIndex] * worldAxes[outerStepVectIndex]:Dot(incrementVect[3])
						end
						outerStepVectIndex = outerStepVectIndex + 1
					else
						stepVect[3] = Vector3.new(1, 0, 0)
						outerStepVectIndex = 4
					end
					if stepVect[3].magnitude * 4 > lines[3].magnitude then
						outerStepVectIndex = 4
					end
				end
			end
		end
		HighScalabilityLine.Start = nil
		HighScalabilityLine.Adorn.Parent = nil
		if cellSet then
			stampData.CurrentParts.Parent = nil
pcall(function()
				return game:GetService("ChangeHistoryService"):SetWaypoint("StamperMulti")
			end)
		end
		return cellSet
	end
	local DoStamperMouseUp
	DoStamperMouseUp = function(Mouse)
		if not Mouse then
			error("Error: RbxStamper.DoStamperMouseUp: Mouse is nil")
			return false
		end
		if not Mouse:IsA("Mouse") then
			error("Error: RbxStamper.DoStamperMouseUp: Mouse is of type", Mouse.className, "should be of type Mouse")
			return false
		end
		if not stampData.Dragger then
			error("Error: RbxStamper.DoStamperMouseUp: stampData.Dragger is nil")
			return false
		end
		if not HighScalabilityLine then
			return false
		end
		local checkHighScalabilityStamp
		if stampInModel then
			local canStamp
			local isHSLPart = isMegaClusterPart()
			if isHSLPart and HighScalabilityLine and HighScalabilityLine.Start and HighScalabilityLine.InternalLine and HighScalabilityLine.InternalLine.magnitude > 0 then
				canStamp = true
				checkHighScalabilityStamp = true
			else
				canStamp, checkHighScalabilityStamp = t.CanEditRegion(stampData.CurrentParts, allowedStampRegion)
			end
			if not canStamp then
				if stampFailedFunc then
					stampFailedFunc()
				end
				return false
			end
		end
		if unstampableSurface then
			flashRedBox()
			return false
		end
		local canStamp
		canStamp, checkHighScalabilityStamp = t.CanEditRegion(stampData.CurrentParts, allowedStampRegion)
		if not canStamp then
			if stampFailedFunc then
				stampFailedFunc()
			end
			return false
		end
		local minBB, maxBB
		minBB, maxBB = getBoundingBoxInWorldCoordinates(stampData.CurrentParts)
		local configFound, targetCFrame = findConfigAtMouseTarget(Mouse, stampData)
		if configFound and not HighScalabilityLine.Adorn.Parent then
			if clusterPartsInRegion(minBB + insertBoundingBoxOverlapVector, maxBB - insertBoundingBoxOverlapVector) then
				flashRedBox()
				return false
			end
			local blockingParts = game.Workspace:FindPartsInRegion3(Region3.new(minBB + insertBoundingBoxOverlapVector, maxBB - insertBoundingBoxOverlapVector), stampData.CurrentParts, 100)
			for b = 1, #blockingParts do
				if isBlocker(blockingParts[b]) then
					flashRedBox()
					return false
				end
			end
			local alreadyPushedUp = { }
			for b = 1, #blockingParts do
				if blockingParts[b].Parent and not alreadyPushedUp[blockingParts[b].Parent] and blockingParts[b].Parent:FindFirstChild("Humanoid") and blockingParts[b].Parent:FindFirstChild("Humanoid"):IsA("Humanoid") then
					local blockingPersonTorso = blockingParts[b].Parent:FindFirstChild("Torso")
					alreadyPushedUp[blockingParts[b].Parent] = true
					if blockingPersonTorso then
						local newY = maxBB.Y + 3
						if spaceAboveCharacter(blockingPersonTorso, newY, stampData) then
							blockingPersonTorso.CFrame = blockingPersonTorso.CFrame + Vector3.new(0, newY - blockingPersonTorso.CFrame.p.Y, 0)
						else
							flashRedBox()
							return false
						end
					end
				end
			end
		elseif (not configFound) and not (HighScalabilityLine.Start and HighScalabilityLine.Adorn.Parent) then
			resetHighScalabilityLine()
			return false
		end
		if game:FindFirstChild("Players") then
			if game.Players["LocalPlayer"] then
				if game.Players.LocalPlayer["Character"] then
					local localChar = game.Players.LocalPlayer.Character
					local stampTracker = localChar:FindFirstChild("StampTracker")
					if stampTracker and not stampTracker.Value then
						stampTracker.Value = true
					end
				end
			end
		end
		if HighScalabilityLine.Start and HighScalabilityLine.Adorn.Parent and isMegaClusterPart() then
			if ResolveMegaClusterStamp(checkHighScalabilityStamp) or checkHighScalabilityStamp then
				stampData.CurrentParts.Parent = nil
				return true
			end
		end
		HighScalabilityLine.Start = nil
		HighScalabilityLine.Adorn.Parent = nil
		local cluster = game.Workspace.Terrain
		if isMegaClusterPart() then
			local cellPos
			if stampData.CurrentParts:IsA("Model") then
				cellPos = cluster:WorldToCell(stampData.CurrentParts:GetModelCFrame().p)
			else
				cellPos = cluster:WorldToCell(stampData.CurrentParts.CFrame.p)
			end
			local cMax = game.Workspace.Terrain.MaxExtents.Max
			local cMin = game.Workspace.Terrain.MaxExtents.Min
			if checkTerrainBlockCollisions(cellPos, false) then
				local clusterValues = stampData.CurrentParts:FindFirstChild("ClusterMaterial", true)
				local waterForceTag = stampData.CurrentParts:FindFirstChild("WaterForceTag", true)
				local waterForceDirectionTag = stampData.CurrentParts:FindFirstChild("WaterForceDirectionTag", true)
				if cellPos.X >= cMin.X and cellPos.Y >= cMin.Y and cellPos.Z >= cMin.Z and cellPos.X < cMax.X and cellPos.Y < cMax.Y and cellPos.Z < cMax.Z then
					if waterForceTag then
						cluster:SetWaterCell(cellPos.X, cellPos.Y, cellPos.Z, Enum.WaterForce[waterForceTag.Value], Enum.WaterDirection[waterForceDirectionTag.Value])
					elseif not clusterValues then
						cluster:SetCell(cellPos.X, cellPos.Y, cellPos.Z, cellInfo.Material, cellInfo.clusterType, gInitial90DegreeRotations % 4)
					elseif clusterValues:IsA("Vector3Value") then
						cluster:SetCell(cellPos.X, cellPos.Y, cellPos.Z, clusterValues.Value.X, clusterValues.Value.Y, clusterValues.Value.Z)
					else
						cluster:SetCell(cellPos.X, cellPos.Y, cellPos.Z, clusterValues.Value, 0, 0)
					end
					local autoWedgeClusterParts = false
					if stampData.CurrentParts:FindFirstChild("AutoWedge") then
						autoWedgeClusterParts = true
					end
					if autoWedgeClusterParts then
						game.Workspace.Terrain:AutowedgeCells(Region3int16.new(Vector3int16.new(cellPos.x - 1, cellPos.y - 1, cellPos.z - 1), Vector3int16.new(cellPos.x + 1, cellPos.y + 1, cellPos.z + 1)))
					end
					stampData.CurrentParts.Parent = nil
pcall(function()
						return game:GetService("ChangeHistoryService"):SetWaypoint("StamperSingle")
					end)
					return true
				end
			else
				flashRedBox()
				return false
			end
		end
		local getPlayer
		getPlayer = function()
			if game:FindFirstChild("Players") then
				if game.Players["LocalPlayer"] then
					return game.Players.LocalPlayer
				end
			end
			return nil
		end
		if stampData.CurrentParts:IsA("Model") or stampData.CurrentParts:IsA("Tool") then
			if stampData.CurrentParts:IsA("Model") then
				local manualWeldTable = { }
				local manualWeldParentTable = { }
				saveTheWelds(stampData.CurrentParts, manualWeldTable, manualWeldParentTable)
				stampData.CurrentParts:BreakJoints()
				stampData.CurrentParts:MakeJoints()
				restoreTheWelds(manualWeldTable, manualWeldParentTable)
			end
			local playerIdTag = stampData.CurrentParts:FindFirstChild("PlayerIdTag")
			local playerNameTag = stampData.CurrentParts:FindFirstChild("PlayerNameTag")
			if (playerIdTag ~= nil) then
				local tempPlayerValue = getPlayer()
				if (tempPlayerValue ~= nil) then
					playerIdTag.Value = tempPlayerValue.userId
				end
			end
			if (playerNameTag ~= nil) then
				if game:FindFirstChild("Players" and game.Players["LocalPlayer"]) then
					local tempPlayerValue = game.Players.LocalPlayer
					if (tempPlayerValue ~= nil) then
						playerNameTag.Value = tempPlayerValue.Name
					end
				end
			end
			if not (stampData.CurrentParts:FindFirstChild("RobloxModel") ~= nil) then
				local stringTag = Instance.new("BoolValue")
				stringTag.Name = "RobloxModel"
				stringTag.Parent = stampData.CurrentParts
				if not (stampData.CurrentParts:FindFirstChild("RobloxStamper") ~= nil) then
					local stringTag2 = Instance.new("BoolValue")
					stringTag2.Name = "RobloxStamper"
					stringTag2.Parent = stampData.CurrentParts
				end
			end
		else
			stampData.CurrentParts:BreakJoints()
			if not (stampData.CurrentParts:FindFirstChild("RobloxStamper") ~= nil) then
				local stringTag2 = Instance.new("BoolValue")
				stringTag2.Name = "RobloxStamper"
				stringTag2.Parent = stampData.CurrentParts
			end
		end
		if not createJoints then
			game.JointsService:CreateJoinAfterMoveJoints()
		end
		for part, transparency in pairs(stampData.TransparencyTable) do
			part.Transparency = transparency
		end
		for part, archivable in pairs(stampData.ArchivableTable) do
			part.Archivable = archivable
		end
		for part, material in pairs(stampData.MaterialTable) do
			part.Material = material
		end
		for part, collide in pairs(stampData.CanCollideTable) do
			part.CanCollide = collide
		end
		for part, anchored in pairs(stampData.AnchoredTable) do
			part.Anchored = anchored
		end
		for decal, transparency in pairs(stampData.DecalTransparencyTable) do
			decal.Transparency = transparency
		end
		for part, surfaces in pairs(stampData.SurfaceTypeTable) do
			loadSurfaceTypes(part, surfaces)
		end
		if isMegaClusterPart() then
			stampData.CurrentParts.Transparency = 0
		end
		setSeatEnabledStatus(stampData.CurrentParts, true)
		stampData.TransparencyTable = nil
		stampData.ArchivableTable = nil
		stampData.MaterialTable = nil
		stampData.CanCollideTable = nil
		stampData.AnchoredTable = nil
		stampData.SurfaceTypeTable = nil
		if not (stampData.CurrentParts:FindFirstChild("RobloxModel") ~= nil) then
			local stringTag = Instance.new("BoolValue")
			stringTag.Name = "RobloxModel"
			stringTag.Parent = stampData.CurrentParts
		end
		if ghostRemovalScript then
			ghostRemovalScript.Parent = nil
		end
		for _, script in pairs(stampData.DisabledScripts) do
			script.Disabled = false
		end
		for _, script in pairs(stampData.DisabledScripts) do
			local oldParent = script.Parent
			script.Parent = nil
			script:Clone().Parent = oldParent
		end
		stampData.DisabledScripts = nil
		stampData.Dragger = nil
		stampData.CurrentParts = nil
pcall(function()
			return game:GetService("ChangeHistoryService"):SetWaypoint("StampedObject")
		end)
		return true
	end
	local pauseStamper
	pauseStamper = function()
		for i = 1, #mouseCons do
			mouseCons[i]:disconnect()
			mouseCons[i] = nil
		end
		mouseCons = { }
		if stampData and stampData.CurrentParts then
			stampData.CurrentParts.Parent = nil
			stampData.CurrentParts:Remove()
		end
		resetHighScalabilityLine()
		return game.JointsService:ClearJoinAfterMoveJoints()
	end
	local prepareUnjoinableSurfaces
	prepareUnjoinableSurfaces = function(modelCFrame, parts, whichSurface)
		local AXIS_VECTORS = {
			Vector3.new(1, 0, 0),
			Vector3.new(0, 1, 0),
			Vector3.new(0, 0, 1)
		}
		local isPositive = 1
		if whichSurface < 0 then
			isPositive = isPositive * (-1)
			whichSurface = whichSurface * (-1)
		end
		local surfaceNormal = isPositive * modelCFrame:vectorToWorldSpace(AXIS_VECTORS[whichSurface])
		for i = 1, #parts do
			local currPart = parts[i]
			local surfaceNormalInLocalCoords = currPart.CFrame:vectorToObjectSpace(surfaceNormal)
			if math.abs(surfaceNormalInLocalCoords.X) > math.abs(surfaceNormalInLocalCoords.Y) then
				if math.abs(surfaceNormalInLocalCoords.X) > math.abs(surfaceNormalInLocalCoords.Z) then
					if surfaceNormalInLocalCoords.X > 0 then
						currPart.RightSurface = "Unjoinable"
					else
						currPart.LeftSurface = "Unjoinable"
					end
				else
					if surfaceNormalInLocalCoords.Z > 0 then
						currPart.BackSurface = "Unjoinable"
					else
						currPart.FrontSurface = "Unjoinable"
					end
				end
			else
				if math.abs(surfaceNormalInLocalCoords.Y) > math.abs(surfaceNormalInLocalCoords.Z) then
					if surfaceNormalInLocalCoords.Y > 0 then
						currPart.TopSurface = "Unjoinable"
					else
						currPart.BottomSurface = "Unjoinable"
					end
				else
					if surfaceNormalInLocalCoords.Z > 0 then
						currPart.BackSurface = "Unjoinable"
					else
						currPart.FrontSurface = "Unjoinable"
					end
				end
			end
		end
	end
	local resumeStamper
	resumeStamper = function()
		local clone, parts = prepareModel(modelToStamp)
		if not clone or not parts then
			return
		end
		local unjoinableTag = clone:FindFirstChild("UnjoinableFaces", true)
		if unjoinableTag then
			for unjoinableSurface in string.gmatch(unjoinableTag.Value, "[^,]*") do
				if tonumber(unjoinableSurface) then
					if clone:IsA("Model") then
						prepareUnjoinableSurfaces(clone:GetModelCFrame(), parts, tonumber(unjoinableSurface))
					else
						prepareUnjoinableSurfaces(clone.CFrame, parts, tonumber(unjoinableSurface))
					end
				end
			end
		end
		stampData.ErrorBox = errorBox
		if stampInModel then
			clone.Parent = stampInModel
		else
			clone.Parent = game.Workspace
		end
		if clone:FindFirstChild("ClusterMaterial", true) then
			local clusterMaterial = clone:FindFirstChild("ClusterMaterial", true)
			if clusterMaterial:IsA("Vector3Value") then
				cellInfo.Material = clusterMaterial.Value.X
				cellInfo.clusterType = clusterMaterial.Value.Y
				cellInfo.clusterOrientation = clusterMaterial.Value.Z
			elseif clusterMaterial:IsA("IntValue") then
				cellInfo.Material = clusterMaterial.Value
			end
		end
pcall(function()
			mouseTarget = Mouse.Target
		end)
		if mouseTarget and not (mouseTarget.Parent:FindFirstChild("RobloxModel") ~= nil) then
			game.JointsService:SetJoinAfterMoveTarget(mouseTarget)
		else
			game.JointsService:SetJoinAfterMoveTarget(nil)
		end
		game.JointsService:ShowPermissibleJoints()
		for _, object in pairs(stampData.DisabledScripts) do
			if object.Name == "GhostRemovalScript" then
				object.Parent = stampData.CurrentParts
			end
		end
		stampData.Dragger = Instance.new("Dragger")
		stampData.Dragger:MouseDown(parts[1], Vector3.new(0, 0, 0, parts))
		stampData.Dragger:MouseUp()
		DoStamperMouseMove(Mouse)
		table.insert(mouseCons, Mouse.Move:connect(function()
			if movingLock or stampUpLock then
				return
			end
			movingLock = true
			DoStamperMouseMove(Mouse)
			movingLock = false
		end))
		table.insert(mouseCons, Mouse.Button1Down:connect(function()
			return DoStamperMouseDown(Mouse)
		end))
		table.insert(mouseCons, Mouse.Button1Up:connect(function()
			stampUpLock = true
			while movingLock do
				wait()
			end
			stamped.Value = DoStamperMouseUp(Mouse)
			resetHighScalabilityLine()
			stampUpLock = false
		end))
		stamped.Value = false
	end
	local resetStamperState
	resetStamperState = function(newModelToStamp)
		if newModelToStamp then
			if not newModelToStamp:IsA("Model") and not newModelToStamp:IsA("BasePart") then
				error("resetStamperState: newModelToStamp (first arg) is not nil, but not a model or part!")
			end
			modelToStamp = newModelToStamp
		end
		pauseStamper()
		return resumeStamper()
	end
	resetStamperState()
	control.Stamped = stamped
	control.Paused = false
	control.LoadNewModel = function(newStampModel)
		if newStampModel and not newStampModel:IsA("Model") and not newStampModel:IsA("BasePart") then
			error("Control.LoadNewModel: newStampModel (first arg) is not a Model or Part!")
			return nil
		end
		return resetStamperState(newStampModel)
	end
	control.ReloadModel = function()
		return resetStamperState()
	end
	control.Pause = function()
		if not control.Paused then
			pauseStamper()
			control.Paused = true
		else
			return print("RbxStamper Warning: Tried to call Control.Pause! when already paused")
		end
	end
	control.Resume = function()
		if control.Paused then
			resumeStamper()
			control.Paused = false
		else
			return print("RbxStamper Warning: Tried to call Control.Resume! without Pausing First")
		end
	end
	control.ResetRotation = function() end
	control.Destroy = function()
		for i = 1, #mouseCons do
			mouseCons[i]:disconnect()
			mouseCons[i] = nil
		end
		if keyCon ~= nil then
			keyCon:disconnect()
		end
		game.JointsService:ClearJoinAfterMoveJoints()
		if adorn ~= nil then
			adorn:Destroy()
		end
		if adornPart ~= nil then
			adornPart:Destroy()
		end
		if errorBox ~= nil then
			errorBox:Destroy()
		end
		if stampData ~= nil then
			do
				local _obj_0 = stampData.Dragger
				if _obj_0 ~= nil then
					_obj_0:Destroy()
				end
			end
		end
		if stampData ~= nil then
			do
				local _obj_0 = stampData.CurrentParts
				if _obj_0 ~= nil then
					_obj_0:Destroy()
				end
			end
		end
		if control and control["Stamped"] then
			control.Stamped:Destroy()
		end
		control = nil
	end
	return control
end
t.Help = function(funcNameOrFunc)
	if "GetStampModel" == funcNameOrFunc or t.GetStampModel == funcNameOrFunc then
		return "Function GetStampModel.  Arguments: assetId, useAssetVersionId.  assetId is the asset to load in, define useAssetVersionId as true if assetId is a version id instead of a relative assetId.  Side effect: returns a model of the assetId, or a string with error message if something fails"
	elseif "SetupStamperDragger" == funcNameOrFunc or t.SetupStamperDragger == funcNameOrFunc then
		return "Function SetupStamperDragger. Side Effect: Creates 4x4 stamping mechanism for building out parts quickly. Arguments: ModelToStamp, Mouse, LegalStampCheckFunction. ModelToStamp should be a Model or Part, preferrably loaded from RbxStamper.GetStampModel and should have extents that are multiples of 4.  Mouse should be a mouse object (obtained from things such as Tool.OnEquipped), used to drag parts around 'stamp' them out. LegalStampCheckFunction is optional, used as a callback with a table argument (table is full of instances about to be stamped). Function should return either true or false, false stopping the stamp action."
	end
end
return t
