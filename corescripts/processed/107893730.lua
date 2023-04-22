print("[Mercury]: Loaded corescript 107893730")
local New
New = function(className, name, props)
	if not (props ~= nil) then
		props = name
		name = nil
	end
	local obj = New(className)
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
	wait(0.1)
end
while not game:GetService("MarketplaceService") do
	wait(0.1)
end
while not game:FindFirstChild("CoreGui") do
	wait(0.1)
end
while not game.CoreGui:FindFirstChild("RobloxGui") do
	wait(0.1)
end
local RbxUtility
local baseUrl = game:GetService("ContentProvider").BaseUrl:lower()
local currentProductInfo, currentAssetId, currentCurrencyType, currentCurrencyAmount, currentEquipOnPurchase, currentProductId, currentServerResponseTable
local checkingPlayerFunds = false
local openBCUpSellWindowConnection
local purchasingConsumable = false
local enableBrowserWindowClosedEvent = true
local openBuyCurrencyWindowConnection
local currentlyPrompting = false
local purchaseDialog
local tweenTime = 0.3
local showPosition = UDim2.new(0.5, -330, 0.5, -200)
local hidePosition = UDim2.new(0.5, -330, 1, 25)
local isSmallScreen
local spinning = false
local spinnerIcons
local smallScreenThreshold = 450
local assetUrls = { }
local assetUrl
assetUrl = function(str)
	return "http://www.roblox.com/Asset/?id=" .. tostring(str)
end
local errorImageUrl = assetUrl("42557901")
table.insert(assetUrls, errorImageUrl)
local buyImageUrl = assetUrl("104651457")
table.insert(assetUrls, buyImageUrl)
local buyImageDownUrl = assetUrl("104651515")
table.insert(assetUrls, buyImageDownUrl)
local buyImageDisabledUrl = assetUrl("104651532")
table.insert(assetUrls, buyImageDisabledUrl)
local cancelButtonImageUrl = assetUrl("104651592")
table.insert(assetUrls, cancelButtonImageUrl)
local cancelButtonDownUrl = assetUrl("104651639")
table.insert(assetUrls, cancelButtonDownUrl)
local okButtonUrl = assetUrl("104651665")
table.insert(assetUrls, okButtonUrl)
local okButtonPressedrl = assetUrl("104651707")
table.insert(assetUrls, okButtonPressedrl)
local freeButtonImageUrl = assetUrl("104651733")
table.insert(assetUrls, freeButtonImageUrl)
local freeButtonImageDownUrl = assetUrl("104651761")
table.insert(assetUrls, freeButtonImageDownUrl)
local tixIcon = assetUrl("102481431")
table.insert(assetUrls, tixIcon)
local robuxIcon = assetUrl("102481419")
table.insert(assetUrls, robuxIcon)
local buyHeaderText = "Buy"
local takeHeaderText = "Take"
local buyFailedHeaderText = "An Error Occurred"
local errorPurchasesDisabledText = "in-game purchases are disabled"
local errorPurchasesUnknownText = "Roblox is performing maintenance"
local purchaseSucceededText = "Your purchase of itemName succeeded!"
local purchaseFailedText = "Your purchase of itemName failed because errorReason. Your account has not been charged. Please try again soon."
local productPurchaseText = "Would you like to buy 'itemName' for currencyType currencyAmount?"
local freeItemPurchaseText = "Would you like to take the assetType 'itemName' for FREE?"
local freeItemBalanceText = "Your balance of Robux or Tix will not be affected by this transaction."
local getSecureApiBaseUrl
getSecureApiBaseUrl = function()
	local secureApiUrl = string.gsub(baseUrl, "http", "https")
	secureApiUrl = string.gsub(secureApiUrl, "www", "api")
	return secureApiUrl
end
local getRbxUtility
getRbxUtility = function()
	if not RbxUtility then
		RbxUtility = LoadLibrary("RbxUtility")
	end
	return RbxUtility
end
local preloadAssets
preloadAssets = function()
	for i = 1, #assetUrls do
		game:GetService("ContentProvider"):Preload(assetUrls[i])
	end
end
local removeCurrentPurchaseInfo
removeCurrentPurchaseInfo = function()
	currentAssetId = nil
	currentCurrencyType = nil
	currentCurrencyAmount = nil
	currentEquipOnPurchase = nil
	currentProductId = nil
	currentProductInfo = nil
	currentServerResponseTable = nil
	checkingPlayerFunds = false
end
local hidePurchasing
hidePurchasing = function()
	purchaseDialog.PurchasingFrame.Visible = false
	spinning = false
end
local closePurchasePrompt
closePurchasePrompt = function()
	return purchaseDialog:TweenPosition(hidePosition, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, tweenTime, true, function()
		game.GuiService:RemoveCenterDialog(purchaseDialog)
		hidePurchasing()
		purchaseDialog.Visible = false
		currentlyPrompting = false
	end)
end
local setButtonsVisible
setButtonsVisible = function(...)
	local args = {
		...
	}
	local argCount = select("#", ...)
	local bodyFrameChildren = purchaseDialog.BodyFrame:GetChildren()
	for i = 1, #bodyFrameChildren do
		if bodyFrameChildren[i]:IsA("GuiButton") then
			bodyFrameChildren[i].Visible = false
			for j = 1, argCount do
				if bodyFrameChildren[i] == args[j] then
					bodyFrameChildren[i].Visible = true
					break
				end
			end
		end
	end
end
local signalPromptEnded
signalPromptEnded = function(isSuccess)
	closePurchasePrompt()
	if purchasingConsumable then
		game:GetService("MarketplaceService"):SignalPromptProductPurchaseFinished(game.Players.LocalPlayer.userId, currentProductId, isSuccess)
	else
		game:GetService("MarketplaceService"):SignalPromptPurchaseFinished(game.Players.LocalPlayer, currentAssetId, isSuccess)
	end
	return removeCurrentPurchaseInfo()
end
local userPurchaseActionsEnded
userPurchaseActionsEnded = function(isSuccess)
	checkingPlayerFunds = false
	if isSuccess then
		local newPurchasedSucceededText = string.gsub(purchaseSucceededText, "itemName", tostring(currentProductInfo["Name"]))
		purchaseDialog.BodyFrame.ItemPreview.ItemDescription.Text = newPurchasedSucceededText
		setButtonsVisible(purchaseDialog.BodyFrame.OkPurchasedButton)
		return hidePurchasing()
	else
		return signalPromptEnded(isSuccess)
	end
end
local isFreeItem
isFreeItem = function()
	return currentProductInfo and currentProductInfo["IsForSale"] == true and currentProductInfo["IsPublicDomain"] == true
end
local setHeaderText
setHeaderText = function(text)
	purchaseDialog.TitleLabel.Text = text
	purchaseDialog.TitleBackdrop.Text = text
end
local assetTypeToString
assetTypeToString = function(assetType)
	if 1 == assetType then
		return "Image"
	elseif 2 == assetType then
		return "T-Shirt"
	elseif 3 == assetType then
		return "Audio"
	elseif 4 == assetType then
		return "Mesh"
	elseif 5 == assetType then
		return "Lua"
	elseif 6 == assetType then
		return "HTML"
	elseif 7 == assetType then
		return "Text"
	elseif 8 == assetType then
		return "Hat"
	elseif 9 == assetType then
		return "Place"
	elseif 10 == assetType then
		return "Model"
	elseif 11 == assetType then
		return "Shirt"
	elseif 12 == assetType then
		return "Pants"
	elseif 13 == assetType then
		return "Decal"
	elseif 16 == assetType then
		return "Avatar"
	elseif 17 == assetType then
		return "Head"
	elseif 18 == assetType then
		return "Face"
	elseif 19 == assetType then
		return "Gear"
	elseif 21 == assetType then
		return "Badge"
	elseif 22 == assetType then
		return "Group Emblem"
	elseif 24 == assetType then
		return "Animation"
	elseif 25 == assetType then
		return "Arms"
	elseif 26 == assetType then
		return "Legs"
	elseif 27 == assetType then
		return "Torso"
	elseif 28 == assetType then
		return "Right Arm"
	elseif 29 == assetType then
		return "Left Arm"
	elseif 30 == assetType then
		return "Left Leg"
	elseif 31 == assetType then
		return "Right Leg"
	elseif 32 == assetType then
		return "Package"
	elseif 33 == assetType then
		return "YouTube Video"
	elseif 34 == assetType then
		return "Game Pass"
	elseif 0 == assetType then
		return "Product"
	else
		return ""
	end
end
local currencyTypeToString
currencyTypeToString = function(currencyType)
	if currencyType == Enum.CurrencyType.Tix then
		return "Tix"
	else
		return "R$"
	end
end
local updatePurchasePromptData
updatePurchasePromptData = function(_)
	local newItemDescription = ""
	if not currentProductId then
		currentProductId = currentProductInfo["ProductId"]
	end
	if isFreeItem() then
		newItemDescription = string.gsub(freeItemPurchaseText, "itemName", tostring(currentProductInfo["Name"]))
		newItemDescription = string.gsub(newItemDescription, "assetType", tostring(assetTypeToString(currentProductInfo["AssetTypeId"])))
		setHeaderText(takeHeaderText)
	else
		newItemDescription = string.gsub(productPurchaseText, "itemName", tostring(currentProductInfo["Name"]))
		newItemDescription = string.gsub(newItemDescription, "currencyType", tostring(currencyTypeToString(currentCurrencyType)))
		newItemDescription = string.gsub(newItemDescription, "currencyAmount", tostring(currentCurrencyAmount))
		setHeaderText(buyHeaderText)
	end
	purchaseDialog.BodyFrame.ItemPreview.ItemDescription.Text = newItemDescription
	if purchasingConsumable then
		purchaseDialog.BodyFrame.ItemPreview.Image = baseUrl .. "thumbs/asset.ashx?assetid=" .. tostring(currentProductInfo["IconImageAssetId"]) .. "&x=100&y=100&format=png"
	else
		purchaseDialog.BodyFrame.ItemPreview.Image = baseUrl .. "thumbs/asset.ashx?assetid=" .. tostring(currentAssetId) .. "&x=100&y=100&format=png"
	end
end
local setCurrencyAmountAndType
setCurrencyAmountAndType = function(priceInRobux, priceInTix)
	if currentCurrencyType == Enum.CurrencyType.Default or currentCurrencyType == Enum.CurrencyType.Robux then
		if (priceInRobux ~= nil) and priceInRobux ~= 0 then
			currentCurrencyAmount = priceInRobux
			currentCurrencyType = Enum.CurrencyType.Robux
		else
			currentCurrencyAmount = priceInTix
			currentCurrencyType = Enum.CurrencyType.Tix
		end
	elseif currentCurrencyType == Enum.CurrencyType.Tix then
		if (priceInTix ~= nil) and priceInTix ~= 0 then
			currentCurrencyAmount = priceInTix
			currentCurrencyType = Enum.CurrencyType.Tix
		else
			currentCurrencyAmount = priceInRobux
			currentCurrencyType = Enum.CurrencyType.Robux
		end
	else
		return false
	end
	if not (currentCurrencyAmount ~= nil) then
		return false
	end
	return true
end
local getPlayerBalance
getPlayerBalance = function()
	local playerBalance
	local success, errorCode
	success, errorCode = pcall(function()
		playerBalance = game:HttpGetAsync(tostring(getSecureApiBaseUrl()) .. "currency/balance")
	end)
	if not success then
		print("Get player balance failed because", errorCode)
		return nil
	end
	if playerBalance == "" then
		return nil
	end
	playerBalance = getRbxUtility().DecodeJSON(playerBalance)
	return playerBalance
end
local membershipTypeToNumber
membershipTypeToNumber = function(membership)
	if Enum.MembershipType.None == membership then
		return 0
	elseif Enum.MembershipType.BuildersClub == membership then
		return 1
	elseif Enum.MembershipType.TurboBuildersClub == membership then
		return 2
	elseif Enum.MembershipType.OutrageousBuildersClub == membership then
		return 3
	else
		return -1
	end
end
local openBuyCurrencyWindow
openBuyCurrencyWindow = function()
	checkingPlayerFunds = true
	return game:GetService("GuiService"):OpenBrowserWindow(tostring(baseUrl) .. "Upgrades/Robux.aspx")
end
local updateAfterBalanceText
updateAfterBalanceText = function(playerBalance, notRightBc)
	if isFreeItem() then
		purchaseDialog.BodyFrame.AfterBalanceButton.Text = freeItemBalanceText
		return true, false
	end
	local keyWord
	if currentCurrencyType == Enum.CurrencyType.Robux then
		keyWord = "robux"
	elseif currentCurrencyType == Enum.CurrencyType.Tix then
		keyWord = "tickets"
	end
	if not keyWord then
		return false
	end
	local playerBalanceNumber = tonumber(playerBalance[keyWord])
	if not playerBalanceNumber then
		return false
	end
	local afterBalanceNumber = playerBalanceNumber - currentCurrencyAmount
	if not notRightBc then
		if afterBalanceNumber < 0 and keyWord == "robux" then
			if not (openBuyCurrencyWindowConnection ~= nil) then
				openBuyCurrencyWindowConnection = purchaseDialog.BodyFrame.AfterBalanceButton.MouseButton1Click:connect(openBuyCurrencyWindow)
			end
			purchaseDialog.BodyFrame.AfterBalanceButton.Text = "You need " .. tostring(currencyTypeToString(currentCurrencyType)) .. " " .. tostring(-afterBalanceNumber) .. " more to buy this, click here to purchase more."
			return true, true
		elseif afterBalanceNumber < 0 and keyWord == "tickets" then
			purchaseDialog.BodyFrame.AfterBalanceButton.Text = "You need " .. tostring(-afterBalanceNumber) .. " " .. tostring(currencyTypeToString(currentCurrencyType)) .. " more to buy this item."
			return true, true
		end
	end
	if openBuyCurrencyWindowConnection then
		openBuyCurrencyWindowConnection:disconnect()
		openBuyCurrencyWindowConnection = nil
	end
	purchaseDialog.BodyFrame.AfterBalanceButton.Text = "Your balance after this transaction will be " .. tostring(currencyTypeToString(currentCurrencyType)) .. " " .. tostring(afterBalanceNumber) .. "."
	return true, false
end
local canPurchaseItem
canPurchaseItem = function()
	local playerOwnsAsset = false
	local notRightBc = false
	local descText
	local success = false
	if purchasingConsumable then
		local currentProductInfoRaw
		success = pcall(function()
			currentProductInfoRaw = Game:HttpGetAsync(tostring(getSecureApiBaseUrl()) .. "marketplace/productDetails?productid=" .. tostring(currentProductId))
		end)
		if success then
			currentProductInfo = getRbxUtility().DecodeJSON(currentProductInfoRaw)
		end
	else
		success = pcall(function()
			currentProductInfo = game:GetService("MarketplaceService"):GetProductInfo(currentAssetId)
		end)
	end
	if not (currentProductInfo ~= nil) or not success then
		descText = "In-game sales are temporarily disabled. Please try again later."
		return true, nil, nil, true, descText
	end
	if not purchasingConsumable then
		if not currentAssetId then
			print("current asset id is nil, this should always have a value")
			return false
		end
		if currentAssetId <= 0 then
			print("current asset id is negative, this should always be positive")
			return false
		end
		local success, errorCode
		success, errorCode = pcall(function()
			playerOwnsAsset = game:HttpGetAsync(getSecureApiBaseUrl() .. "ownership/hasAsset?userId=" .. tostring(game.Players.LocalPlayer.userId) .. "&assetId=" .. tostring(currentAssetId))
		end)
		if not success then
			print("could not tell if player owns asset because", errorCode)
			return false
		end
		if playerOwnsAsset == true or playerOwnsAsset == "true" then
			descText = "You already own this item."
			return true, nil, nil, true, descText
		end
	end
	purchaseDialog.BodyFrame.AfterBalanceButton.Visible = true
	if type(currentProductInfo) ~= "table" then
		currentProductInfo = getRbxUtility().DecodeJSON(currentProductInfo)
	end
	if not currentProductInfo then
		descText = "Could not get product info. Please try again later."
		return true, nil, nil, true, descText
	end
	if currentProductInfo["IsForSale"] == false and currentProductInfo["IsPublicDomain"] == false then
		descText = "This item is no longer for sale."
		return true, nil, nil, true, descText
	end
	if not setCurrencyAmountAndType(tonumber(currentProductInfo["PriceInRobux"]), tonumber(currentProductInfo["PriceInTickets"])) then
		descText = "We could retrieve the price of the item correctly. Please try again later."
		return true, nil, nil, true, descText
	end
	local playerBalance = getPlayerBalance()
	if not playerBalance then
		descText = "Could not retrieve your balance. Please try again later."
		return true, nil, nil, true, descText
	end
	if tonumber(currentProductInfo["MinimumMembershipLevel"]) > membershipTypeToNumber(game.Players.LocalPlayer.MembershipType) then
		notRightBc = true
	end
	local updatedBalance, insufficientFunds
	updatedBalance, insufficientFunds = updateAfterBalanceText(playerBalance, notRightBc)
	if notRightBc then
		purchaseDialog.BodyFrame.AfterBalanceButton.Active = true
		return true, insufficientFunds, notRightBc, false
	end
	if currentProductInfo["ContentRatingTypeId"] == 1 then
		if game.Players.LocalPlayer:GetUnder13() then
			descText = "Your account is under 13 so purchase of this item is not allowed."
			return true, nil, nil, true, descText
		end
	end
	if (currentProductInfo["IsLimited"] == true or currentProductInfo["IsLimitedUnique"] == true) and (currentProductInfo["Remaining"] == "" or currentProductInfo["Remaining"] == 0 or not (currentProductInfo["Remaining"] ~= nil)) then
		descText = "All copies of this item have been sold out! Try buying from other users on the website."
		return true, nil, nil, true, descText
	end
	if not updatedBalance then
		descText = "Could not update your balance. Please check back after some time."
		return true, nil, nil, true, descText
	end
	purchaseDialog.BodyFrame.AfterBalanceButton.Active = true
	return true, insufficientFunds
end
local doPlayerFundsCheck
doPlayerFundsCheck = function(checkIndefinitely)
	if checkingPlayerFunds then
		local canPurchase, insufficientFunds
		canPurchase, insufficientFunds = canPurchaseItem()
		if canPurchase and insufficientFunds then
			local retries = 1000
			while (retries > 0 or checkIndefinitely) and insufficientFunds and checkingPlayerFunds and canPurchase do
				wait(1 / 10)
				canPurchase, insufficientFunds = canPurchaseItem()
				retries = retries - 1
			end
		end
		if canPurchase and not insufficientFunds then
			return setButtonsVisible(purchaseDialog.BodyFrame.BuyButton, purchaseDialog.BodyFrame.CancelButton, purchaseDialog.BodyFrame.AfterBalanceButton)
		end
	end
end
local openBCUpSellWindow
openBCUpSellWindow = function()
	return Game:GetService("GuiService"):OpenBrowserWindow(tostring(baseUrl) .. "Upgrades/BuildersClubMemberships.aspx")
end
local doDeclinePurchase
doDeclinePurchase = function()
	return userPurchaseActionsEnded(false)
end
local showPurchasePrompt
showPurchasePrompt = function()
	local canPurchase, insufficientFunds, notRightBC, override, descText
	canPurchase, insufficientFunds, notRightBC, override, descText = canPurchaseItem()
	if canPurchase then
		updatePurchasePromptData()
		if override and descText then
			purchaseDialog.BodyFrame.ItemPreview.ItemDescription.Text = descText
			purchaseDialog.BodyFrame.AfterBalanceButton.Visible = false
		end
		game.GuiService:AddCenterDialog(purchaseDialog, Enum.CenterDialogType.ModalDialog, function()
			purchaseDialog.Visible = true
			if isFreeItem() then
				setButtonsVisible(purchaseDialog.BodyFrame.FreeButton, purchaseDialog.BodyFrame.CancelButton, purchaseDialog.BodyFrame.AfterBalanceButton)
			elseif notRightBC then
				purchaseDialog.BodyFrame.AfterBalanceButton.Text = "You require an upgrade to your Builders Club membership to purchase this item. Click here to upgrade."
				if not openBCUpSellWindowConnection then
					openBCUpSellWindowConnection = purchaseDialog.BodyFrame.AfterBalanceButton.MouseButton1Click:connect(function()
						if purchaseDialog.BodyFrame.AfterBalanceButton.Text == "You require an upgrade to your Builders Club membership to purchase this item. Click here to upgrade." then
							return openBCUpSellWindow()
						end
					end)
				end
				setButtonsVisible(purchaseDialog.BodyFrame.BuyDisabledButton, purchaseDialog.BodyFrame.CancelButton, purchaseDialog.BodyFrame.AfterBalanceButton)
			elseif insufficientFunds then
				setButtonsVisible(purchaseDialog.BodyFrame.BuyDisabledButton, purchaseDialog.BodyFrame.CancelButton, purchaseDialog.BodyFrame.AfterBalanceButton)
			elseif override then
				setButtonsVisible(purchaseDialog.BodyFrame.BuyDisabledButton, purchaseDialog.BodyFrame.CancelButton)
			else
				setButtonsVisible(purchaseDialog.BodyFrame.BuyButton, purchaseDialog.BodyFrame.CancelButton)
			end
			purchaseDialog:TweenPosition(showPosition, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, tweenTime, true)
			if canPurchase and insufficientFunds and not enableBrowserWindowClosedEvent then
				checkingPlayerFunds = true
				return doPlayerFundsCheck(true)
			end
		end, function()
			purchaseDialog.Visible = false
		end)
		return purchaseDialog
	else
		return doDeclinePurchase()
	end
end
local getToolAssetID
getToolAssetID = function(assetID)
	local newTool = game:GetService("InsertService"):LoadAsset(assetID)
	if not newTool then
		return nil
	end
	if newTool:IsA("Tool") then
		return newTool
	end
	local toolChildren = newTool:GetChildren()
	for i = 1, #toolChildren do
		if toolChildren[i]:IsA("Tool") then
			return toolChildren[i]
		end
	end
	return nil
end
local purchaseFailed
purchaseFailed = function(inGamePurchasesDisabled)
	local name = "Item"
	if currentProductInfo then
		name = currentProductInfo["Name"]
	end
	local newPurchasedFailedText = string.gsub(purchaseFailedText, "itemName", tostring(name))
	if inGamePurchasesDisabled then
		newPurchasedFailedText = string.gsub(newPurchasedFailedText, "errorReason", tostring(errorPurchasesDisabledText))
	else
		newPurchasedFailedText = string.gsub(newPurchasedFailedText, "errorReason", tostring(errorPurchasesUnknownText))
	end
	purchaseDialog.BodyFrame.ItemPreview.ItemDescription.Text = newPurchasedFailedText
	purchaseDialog.BodyFrame.ItemPreview.Image = errorImageUrl
	setButtonsVisible(purchaseDialog.BodyFrame.OkButton)
	setHeaderText(buyFailedHeaderText)
	return hidePurchasing()
end
local startSpinner
startSpinner = function()
	spinning = true
	return Spawn(function()
		local spinPos = 0
		while spinning do
			local pos = 0
			while pos < 8 do
				spinnerIcons[pos + 1].Image = "http://www.roblox.com/Asset/?id=" .. (function()
					if pos == spinPos or pos == (spinPos + 1) % 8 then
						return "45880668"
					else
						return "45880710"
					end
				end)()
				pos = pos + 1
			end
			spinPos = (spinPos + 1) % 8
			wait(1 / 15)
		end
	end)
end
local showPurchasing
showPurchasing = function()
	startSpinner()
	purchaseDialog.PurchasingFrame.Visible = true
end
local currencyEnumToInt
currencyEnumToInt = function(currencyEnum)
	if currencyEnum == Enum.CurrencyType.Robux or currencyEnum == Enum.CurrencyType.Default then
		return 1
	elseif currencyEnum == Enum.CurrencyType.Tix then
		return 2
	end
end
local doAcceptPurchase
doAcceptPurchase = function(_)
	showPurchasing()
	local startTime = tick()
	local response = "none"
	local url
	if purchasingConsumable then
		url = getSecureApiBaseUrl() .. "marketplace/submitpurchase?productId=" .. tostring(currentProductId) .. "&currencyTypeId=" .. tostring(currencyEnumToInt(currentCurrencyType)) .. "&expectedUnitPrice=" .. tostring(currentCurrencyAmount) .. "&placeId=" .. tostring(Game.PlaceId)
	else
		url = getSecureApiBaseUrl() .. "marketplace/purchase?productId=" .. tostring(currentProductId) .. "&currencyTypeId=" .. tostring(currencyEnumToInt(currentCurrencyType)) .. "&purchasePrice=" .. tostring(currentCurrencyAmount) .. "&locationType=Game" .. "&locationId=" .. tostring(Game.PlaceId)
	end
	local success, reason
	success, reason = pcall(function()
		response = game:HttpPostAsync(url, "RobloxPurchaseRequest")
	end)
	print("doAcceptPurchase success from ypcall is ", success, "reason is", reason)
	if (tick() - startTime) < 1 then
		wait(1)
	end
	if response == "none" or not (response ~= nil) or response == "" then
		print("did not get a proper response from web on purchase of", currentAssetId, currentProductId)
		purchaseFailed()
		return
	end
	response = getRbxUtility().DecodeJSON(response)
	if response then
		if response["success"] == false then
			if response["status"] ~= "AlreadyOwned" then
				print("web return response of fail on purchase of", currentAssetId, currentProductId)
				purchaseFailed(response["status"] == "EconomyDisabled")
				return
			end
		end
	else
		print("web return response of non parsable JSON on purchase of", currentAssetId)
		purchaseFailed()
		return
	end
	if currentEquipOnPurchase and success and currentAssetId and tonumber(currentProductInfo["AssetTypeId"]) == 19 then
		local tool = getToolAssetID(tonumber(currentAssetId))
		if tool then
			tool.Parent = game.Players.LocalPlayer.Backpack
		end
	end
	if purchasingConsumable then
		if not response["receipt"] then
			print("tried to buy productId, but no receipt returned. productId was", currentProductId)
			purchaseFailed()
			return
		end
		return Game:GetService("MarketplaceService"):SignalClientPurchaseSuccess(tostring(response["receipt"]), game.Players.LocalPlayer.userId, currentProductId)
	else
		return userPurchaseActionsEnded(success)
	end
end
local createSpinner
createSpinner = function(size, position, parent)
	local spinnerFrame = New("Frame", "Spinner", {
		Size = size,
		Position = position,
		BackgroundTransparency = 1,
		ZIndex = 10,
		Parent = parent
	})
	spinnerIcons = { }
	local spinnerNum = 1
	while spinnerNum <= 8 do
		local spinnerImage = New("ImageLabel", "Spinner" .. tostring(spinnerNum), {
			Size = UDim2.new(0, 16, 0, 16),
			Position = UDim2.new(0.5 + 0.3 * math.cos(math.rad(45 * spinnerNum)), -8, 0.5 + 0.3 * math.sin(math.rad(45 * spinnerNum)), -8),
			BackgroundTransparency = 1,
			ZIndex = 10,
			Image = "http://www.roblox.com/Asset/?id=45880710",
			Parent = spinnerFrame
		})
		spinnerIcons[spinnerNum] = spinnerImage
		spinnerNum = spinnerNum + 1
	end
end
local createTextObject
createTextObject = function(name, text, type, size)
	return New(type, name, {
		Font = Enum.Font.ArialBold,
		TextColor3 = Color3.new(217 / 255, 217 / 255, 217 / 255),
		TextWrapped = true,
		Text = text,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		FontSize = size
	})
end
local createImageButton
createImageButton = function(name)
	return New("ImageButton", name, {
		Size = UDim2.new(0, 153, 0, 46),
		Name = name
	})
end
local userPurchaseProductActionsEnded
userPurchaseProductActionsEnded = function(userIsClosingDialog)
	checkingPlayerFunds = false
	if userIsClosingDialog then
		closePurchasePrompt()
		if currentServerResponseTable then
			local isPurchased = false
			if (tostring(currentServerResponseTable["isValid"])):lower() == "true" then
				isPurchased = true
			end
			Game:GetService("MarketplaceService"):SignalPromptProductPurchaseFinished(tonumber(currentServerResponseTable["playerId"]), tonumber(currentServerResponseTable["productId"]), isPurchased)
		else
			print("Something went wrong, no currentServerResponseTable")
		end
		return removeCurrentPurchaseInfo()
	else
		local newPurchasedSucceededText = string.gsub(purchaseSucceededText, "itemName", tostring(currentProductInfo["Name"]))
		purchaseDialog.BodyFrame.ItemPreview.ItemDescription.Text = newPurchasedSucceededText
		setButtonsVisible(purchaseDialog.BodyFrame.OkPurchasedButton)
		return hidePurchasing()
	end
end
local createPurchasePromptGui
createPurchasePromptGui = function()
	purchaseDialog = New("Frame", "PurchaseFrame", {
		Size = UDim2.new(0, 660, 0, 400),
		Position = hidePosition,
		Visible = false,
		BackgroundColor3 = Color3.new(141 / 255, 141 / 255, 141 / 255),
		BorderColor3 = Color3.new(204 / 255, 204 / 255, 204 / 255),
		Parent = game.CoreGui.RobloxGui,
		New("Frame", "BodyFrame", {
			Size = UDim2.new(1, 0, 1, -60),
			Position = UDim2.new(0, 0, 0, 60),
			BackgroundColor3 = Color3.new(67 / 255, 67 / 255, 67 / 255),
			BorderSizePixel = 0,
			ZIndex = 8
		})
	})
	local bodyFrame = purchaseDialog.BodyFrame
	do
		local _with_0 = createTextObject("TitleLabel", "Buy Item", "TextLabel", Enum.FontSize.Size48)
		_with_0.ZIndex = 8
		_with_0.Size = UDim2.new(1, 0, 0, 60)
		do
			local _with_1 = _with_0:Clone()
			_with_1.Name = "TitleBackdrop"
			_with_1.TextColor3 = Color3.new(32 / 255, 32 / 255, 32 / 255)
			_with_1.BackgroundTransparency = 0.0
			_with_1.BackgroundColor3 = Color3.new(54 / 255, 96 / 255, 171 / 255)
			_with_1.Position = UDim2.new(0, 0, 0, -2)
			_with_1.ZIndex = 8
			_with_1.Parent = purchaseDialog
		end
		_with_0.Parent = purchaseDialog
	end
	local distanceBetweenButtons = 90
	do
		local _with_0 = createImageButton("CancelButton")
		_with_0.Position = UDim2.new(0.5, distanceBetweenButtons / 2, 1, -120)
		_with_0.BackgroundTransparency = 1
		_with_0.BorderSizePixel = 0
		_with_0.Parent = bodyFrame
		_with_0.Modal = true
		_with_0.ZIndex = 8
		_with_0.Image = cancelButtonImageUrl
		_with_0.MouseButton1Down:connect(function()
			_with_0.Image = cancelButtonDownUrl
		end)
		_with_0.MouseButton1Up:connect(function()
			_with_0.Image = cancelButtonImageUrl
		end)
		_with_0.MouseLeave:connect(function()
			_with_0.Image = cancelButtonImageUrl
		end)
		_with_0.MouseButton1Click:connect(doDeclinePurchase)
	end
	local buyButton = createImageButton("BuyButton")
	buyButton.Position = UDim2.new(0.5, -153 - (distanceBetweenButtons / 2), 1, -120)
	buyButton.BackgroundTransparency = 1
	buyButton.BorderSizePixel = 0
	buyButton.Image = buyImageUrl
	buyButton.ZIndex = 8
	buyButton.MouseButton1Down:connect(function()
		buyButton.Image = buyImageDownUrl
	end)
	buyButton.MouseButton1Up:connect(function()
		buyButton.Image = buyImageUrl
	end)
	buyButton.MouseLeave:connect(function()
		buyButton.Image = buyImageUrl
	end)
	buyButton.Parent = bodyFrame
	do
		local _with_0 = buyButton:Clone()
		_with_0.Name = "BuyDisabledButton"
		_with_0.AutoButtonColor = false
		_with_0.Visible = false
		_with_0.Active = false
		_with_0.Image = buyImageDisabledUrl
		_with_0.ZIndex = 8
		_with_0.Parent = bodyFrame
	end
	local freeButton = buyButton:Clone()
	freeButton.BackgroundTransparency = 1
	freeButton.Name = "FreeButton"
	freeButton.Visible = false
	freeButton.ZIndex = 8
	freeButton.Image = freeButtonImageUrl
	freeButton.MouseButton1Down:connect(function()
		freeButton.Image = freeButtonImageDownUrl
	end)
	freeButton.MouseButton1Up:connect(function()
		freeButton.Image = freeButtonImageUrl
	end)
	freeButton.MouseLeave:connect(function()
		freeButton.Image = freeButtonImageUrl
	end)
	freeButton.Parent = bodyFrame
	local okButton = buyButton:Clone()
	okButton.Name = "OkButton"
	okButton.BackgroundTransparency = 1
	okButton.Visible = false
	okButton.Position = UDim2.new(0.5, -okButton.Size.X.Offset / 2, 1, -120)
	okButton.Modal = true
	okButton.Image = okButtonUrl
	okButton.ZIndex = 8
	okButton.MouseButton1Down:connect(function()
		okButton.Image = okButtonPressedrl
	end)
	okButton.MouseButton1Up:connect(function()
		okButton.Image = okButtonUrl
	end)
	okButton.MouseLeave:connect(function()
		okButton.Image = okButtonUrl
	end)
	okButton.Parent = bodyFrame
	do
		local _with_0 = okButton:Clone()
		_with_0.ZIndex = 8
		_with_0.Name = "OkPurchasedButton"
		_with_0.MouseButton1Down:connect(function()
			_with_0.Image = okButtonPressedrl
		end)
		_with_0.MouseButton1Up:connect(function()
			_with_0.Image = okButtonUrl
		end)
		_with_0.MouseLeave:connect(function()
			_with_0.Image = okButtonUrl
		end)
		_with_0.Parent = bodyFrame
		_with_0.MouseButton1Click:connect(function()
			if purchasingConsumable then
				return userPurchaseProductActionsEnded(true)
			else
				return signalPromptEnded(true)
			end
		end)
	end
	okButton.MouseButton1Click:connect(function()
		return userPurchaseActionsEnded(false)
	end)
	buyButton.MouseButton1Click:connect(function()
		return doAcceptPurchase(Enum.CurrencyType.Robux)
	end)
	freeButton.MouseButton1Click:connect(function()
		return doAcceptPurchase(false)
	end)
	local itemPreview = New("ImageLabel", "ItemPreview", {
		BackgroundColor3 = Color3.new(32 / 255, 32 / 255, 32 / 255),
		BorderColor3 = Color3.new(141 / 255, 141 / 255, 141 / 255),
		Position = UDim2.new(0, 30, 0, 20),
		Size = UDim2.new(0, 180, 0, 180),
		ZIndex = 9,
		Parent = bodyFrame
	})
	do
		local _with_0 = createTextObject("ItemDescription", "Would you like to buy the 'itemName' for currencyType currencyAmount?", "TextLabel", Enum.FontSize.Size24)
		_with_0.Position = UDim2.new(1, 20, 0, 0)
		_with_0.Size = UDim2.new(0, 410, 1, 0)
		_with_0.ZIndex = 8
		_with_0.Parent = itemPreview
	end
	do
		local _with_0 = createTextObject("AfterBalanceButton", "Place holder text ip sum lorem dodo ashs", "TextButton", Enum.FontSize.Size24)
		_with_0.AutoButtonColor = false
		_with_0.TextColor3 = Color3.new(222 / 255, 59 / 255, 30 / 255)
		_with_0.Position = UDim2.new(0, 5, 1, -55)
		_with_0.Size = UDim2.new(1, -10, 0, 50)
		_with_0.ZIndex = 8
		_with_0.Parent = bodyFrame
	end
	local purchasingFrame = New("Frame", "PurchasingFrame", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = Color3.new(0, 0, 0),
		BackgroundTransparency = 0.2,
		BorderSizePixel = 0,
		ZIndex = 9,
		Visible = false,
		Active = true,
		Parent = purchaseDialog
	})
	local purchasingLabel = createTextObject("PurchasingLabel", "Purchasing...", "TextLabel", Enum.FontSize.Size48)
	purchasingLabel.Size = UDim2.new(1, 0, 1, 0)
	purchasingLabel.ZIndex = 10
	purchasingLabel.Parent = purchasingFrame
	return createSpinner(UDim2.new(0, 50, 0, 50), UDim2.new(0.5, -25, 0.5, 30), purchasingLabel)
end
local cutSizeInHalfRecursive
cutSizeInHalfRecursive = function(_) end
local doubleSizeRecursive
doubleSizeRecursive = function(_) end
local changeGuiToScreenSize
changeGuiToScreenSize = function(smallScreen)
	if smallScreen then
		return cutSizeInHalfRecursive(purchaseDialog)
	else
		return doubleSizeRecursive(purchaseDialog)
	end
end
local doPurchasePrompt
doPurchasePrompt = function(player, assetId, equipIfPurchased, currencyType, productId)
	if not purchaseDialog then
		createPurchasePromptGui()
	end
	if player == game.Players.LocalPlayer then
		if currentlyPrompting then
			return
		end
		currentlyPrompting = true
		currentAssetId = assetId
		currentProductId = productId
		currentCurrencyType = currencyType
		currentEquipOnPurchase = equipIfPurchased
		purchasingConsumable = (currentProductId ~= nil)
		return showPurchasePrompt()
	end
end
local doProcessServerPurchaseResponse
doProcessServerPurchaseResponse = function(serverResponseTable)
	if not serverResponseTable then
		print("Server response table was nil, cancelling purchase")
		purchaseFailed()
		return
	end
	if serverResponseTable["playerId"] and tonumber(serverResponseTable["playerId"]) == game.Players.LocalPlayer.userId then
		currentServerResponseTable = serverResponseTable
		return userPurchaseProductActionsEnded(false)
	end
end
preloadAssets()
game:GetService("MarketplaceService").PromptProductPurchaseRequested:connect(function(player, productId, equipIfPurchased, currencyType)
	return doPurchasePrompt(player, nil, equipIfPurchased, currencyType, productId)
end)
Game:GetService("MarketplaceService").PromptPurchaseRequested:connect(function(player, assetId, equipIfPurchased, currencyType)
	return doPurchasePrompt(player, assetId, equipIfPurchased, currencyType, nil)
end)
Game:GetService("MarketplaceService").ServerPurchaseVerification:connect(function(serverResponseTable)
	return doProcessServerPurchaseResponse(serverResponseTable)
end)
if enableBrowserWindowClosedEvent then
	Game:GetService("GuiService").BrowserWindowClosed:connect(function()
		return doPlayerFundsCheck(false)
	end)
end
Game.CoreGui.RobloxGui.Changed:connect(function()
	local nowIsSmallScreen = game.CoreGui.RobloxGui.AbsoluteSize.Y <= smallScreenThreshold
	if nowIsSmallScreen and not isSmallScreen then
		changeGuiToScreenSize(true)
	elseif not nowIsSmallScreen and isSmallScreen then
		changeGuiToScreenSize(false)
	end
	isSmallScreen = nowIsSmallScreen
end)
isSmallScreen = game.CoreGui.RobloxGui.AbsoluteSize.Y <= smallScreenThreshold
if isSmallScreen then
	return changeGuiToScreenSize(true)
end
