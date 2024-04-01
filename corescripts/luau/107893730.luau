--!strict
-- CoreGui.RobloxGui.CoreScripts/PurchasePromptScript
print "[Graphictoria]: Loaded corescript 107893730"

-- this script creates the gui and sends the web requests for in game purchase prompts

local MarketplaceService = game:GetService "MarketplaceService"
local GuiService = game:GetService "GuiService"
local ContentProvider = game:GetService "ContentProvider"
local HttpService = game:GetService "HttpService"
local RunService = game:GetService "RunService"

-- wait for important items to appear
while not Game do
	RunService.Heartbeat:wait()
end
while not MarketplaceService do
	RunService.Heartbeat:wait()
	MarketplaceService = game:GetService "MarketplaceService"
end
while not game:FindFirstChild "CoreGui" do
	RunService.Heartbeat:wait()
end
while not game.CoreGui:FindFirstChild "RobloxGui" do
	RunService.Heartbeat:wait()
end

-------------------------------- Global Variables ----------------------------------------
-- utility variables
local baseUrl = string.lower(ContentProvider.BaseUrl)

-- data variables
local currentProductInfo, currentAssetId, currentCurrencyType, currentCurrencyAmount, currentEquipOnPurchase, currentProductId, currentServerResponseTable
local checkingPlayerFunds = false
local openBCUpSellWindowConnection
local purchasingConsumable = false
local enableBrowserWindowClosedEvent = true

-- gui variables
local openBuyCurrencyWindowConnection
local currentlyPrompting = false
local purchaseDialog
local tweenTime = 0.3
local showPosition = UDim2.new(0.5, -330, 0.5, -200)
local hidePosition = UDim2.new(0.5, -330, 1, 25)
-- local isSmallScreen
local spinning = false
local spinnerIcons
-- local smallScreenThreshold = 450

-- user facing images
local function assetUrl(id: number)
	return `http://banland.xyz/asset?id={id}`
end

local errorImageUrl = assetUrl(42557901)
local buyImageUrl = assetUrl(104651457)
local buyImageDownUrl = assetUrl(104651515)
local buyImageDisabledUrl = assetUrl(104651532)
local cancelButtonImageUrl = assetUrl(104651592)
local cancelButtonDownUrl = assetUrl(104651639)
local okButtonUrl = assetUrl(104651665)
local okButtonPressedrl = assetUrl(104651707)
local freeButtonImageUrl = assetUrl(104651733)
local freeButtonImageDownUrl = assetUrl(104651761)
local tixIcon = assetUrl(102481431)
local robuxIcon = assetUrl(102481419)

-- user facing string
local buyHeaderText = "Buy"
local takeHeaderText = "Take"
local buyFailedHeaderText = "An Error Occurred"

local errorPurchasesDisabledText = "in-game purchases are disabled"
local errorPurchasesUnknownText = "Roblox is performing maintenance"

local purchaseSucceededText = "Your purchase of itemName succeeded!"
local purchaseFailedText =
	"Your purchase of itemName failed because errorReason. Your account has not been charged. Please try again soon."
local productPurchaseText =
	"Would you like to buy 'itemName' for currencyType currencyAmount?"
local freeItemPurchaseText =
	"Would you like to take the assetType 'itemName' for FREE?"
local freeItemBalanceText =
	"Your balance of Robux or Tix will not be affected by this transaction."

-------------------------------- End Global Variables ----------------------------------------

----------------------------- Util Functions ---------------------------------------------

local function getSecureApiBaseUrl()
	local secureApiUrl = baseUrl
	secureApiUrl = string.gsub(secureApiUrl, "http", "https")
	secureApiUrl = string.gsub(secureApiUrl, "www", "api")
	return secureApiUrl
end

local function preloadAssets()
	for _, url in ipairs {
		errorImageUrl,
		buyImageUrl,
		buyImageDownUrl,
		buyImageDisabledUrl,
		cancelButtonImageUrl,
		cancelButtonDownUrl,
		okButtonUrl,
		okButtonPressedrl,
		freeButtonImageUrl,
		freeButtonImageDownUrl,
		tixIcon,
		robuxIcon,
	} do
		ContentProvider:Preload(url)
	end
end

----------------------------- End Util Functions ---------------------------------------------

-------------------------------- Accept/Decline Functions --------------------------------------

local function removeCurrentPurchaseInfo()
	currentAssetId = nil
	currentCurrencyType = nil
	currentCurrencyAmount = nil
	currentEquipOnPurchase = nil
	currentProductId = nil
	currentProductInfo = nil
	currentServerResponseTable = nil

	checkingPlayerFunds = false
end

local function hidePurchasing()
	purchaseDialog.PurchasingFrame.Visible = false
	spinning = false
end

local function closePurchasePrompt()
	purchaseDialog:TweenPosition(
		hidePosition,
		Enum.EasingDirection.Out,
		Enum.EasingStyle.Quad,
		tweenTime,
		true,
		function()
			game.GuiService:RemoveCenterDialog(purchaseDialog)
			hidePurchasing()
			purchaseDialog.Visible = false
			currentlyPrompting = false
		end
	)
end

local function signalPromptEnded(isSuccess)
	closePurchasePrompt()
	if purchasingConsumable then
		MarketplaceService:SignalPromptProductPurchaseFinished(
			game.Players.LocalPlayer.userId,
			currentProductId,
			isSuccess
		)
	else
		MarketplaceService:SignalPromptPurchaseFinished(
			game.Players.LocalPlayer,
			currentAssetId,
			isSuccess
		)
	end
	removeCurrentPurchaseInfo()
end

-- convenience method to say exactly what buttons should be visible (all others are not!)
local function setButtonsVisible(...)
	local args = { ... }
	local argCount = select("#", ...)

	local bodyFrameChildren = purchaseDialog.BodyFrame:GetChildren()
	for i = 1, #bodyFrameChildren do
		if bodyFrameChildren[i]:IsA "GuiButton" then
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

local function userPurchaseActionsEnded(isSuccess: boolean)
	checkingPlayerFunds = false

	if isSuccess then -- show the user we bought the item successfully, when they close this dialog we will call signalPromptEnded
		local newPurchasedSucceededText = string.gsub(
			purchaseSucceededText,
			"itemName",
			tostring(currentProductInfo.Name)
		)
		purchaseDialog.BodyFrame.ItemPreview.ItemDescription.Text =
			newPurchasedSucceededText
		setButtonsVisible(purchaseDialog.BodyFrame.OkPurchasedButton)
		hidePurchasing()
	else -- otherwise we didn't purchase, no need to show anything, just signal and close dialog
		signalPromptEnded(isSuccess)
	end
end

-- enums have no implicit conversion to numbers in lua, has to have a function to do this
local function currencyEnumToInt(currencyEnum: EnumItem)
	if currencyEnum == Enum.CurrencyType.Tix then
		return 2
	end
	return 1
end

-- oi, this is ugly
local function assetTypeToString(assetType: number)
	if assetType == 1 then
		return "Image"
	elseif assetType == 2 then
		return "T-Shirt"
	elseif assetType == 3 then
		return "Audio"
	elseif assetType == 4 then
		return "Mesh"
	elseif assetType == 5 then
		return "Lua"
	elseif assetType == 6 then
		return "HTML"
	elseif assetType == 7 then
		return "Text"
	elseif assetType == 8 then
		return "Hat"
	elseif assetType == 9 then
		return "Place"
	elseif assetType == 10 then
		return "Model"
	elseif assetType == 11 then
		return "Shirt"
	elseif assetType == 12 then
		return "Pants"
	elseif assetType == 13 then
		return "Decal"
	elseif assetType == 16 then
		return "Avatar"
	elseif assetType == 17 then
		return "Head"
	elseif assetType == 18 then
		return "Face"
	elseif assetType == 19 then
		return "Gear"
	elseif assetType == 21 then
		return "Badge"
	elseif assetType == 22 then
		return "Group Emblem"
	elseif assetType == 24 then
		return "Animation"
	elseif assetType == 25 then
		return "Arms"
	elseif assetType == 26 then
		return "Legs"
	elseif assetType == 27 then
		return "Torso"
	elseif assetType == 28 then
		return "Right Arm"
	elseif assetType == 29 then
		return "Left Arm"
	elseif assetType == 30 then
		return "Left Leg"
	elseif assetType == 31 then
		return "Right Leg"
	elseif assetType == 32 then
		return "Package"
	elseif assetType == 33 then
		return "YouTube Video"
	elseif assetType == 34 then
		return "Game Pass"
	elseif assetType == 0 then
		return "Product"
	end

	return ""
end

local function isFreeItem()
	-- if both of these are true, then the item is free, just prompt user if they want to take one
	return currentProductInfo
		and currentProductInfo.IsForSale == true
		and currentProductInfo.IsPublicDomain == true
end

local function setHeaderText(text)
	purchaseDialog.TitleLabel.Text = text
	purchaseDialog.TitleBackdrop.Text = text
end

local function currencyTypeToString(currencyType)
	if currencyType == Enum.CurrencyType.Tix then
		return "Tix"
	end
	return "R$"
end

-- make sure our gui displays the proper purchase data, and set the productid we will try and buy if use specifies a buy action
local function updatePurchasePromptData()
	local newItemDescription = ""

	-- id to use when we request a purchase
	if not currentProductId then
		currentProductId = currentProductInfo.ProductId
	end

	if isFreeItem() then
		newItemDescription = string.gsub(
			freeItemPurchaseText,
			"itemName",
			tostring(currentProductInfo.Name)
		)
		newItemDescription = string.gsub(
			newItemDescription,
			"assetType",
			tostring(assetTypeToString(currentProductInfo.AssetTypeId))
		)
		setHeaderText(takeHeaderText)
	else -- otherwise item costs something, so different prompt
		newItemDescription = string.gsub(
			productPurchaseText,
			"itemName",
			tostring(currentProductInfo.Name)
		)
		newItemDescription = string.gsub(
			newItemDescription,
			"currencyType",
			tostring(currencyTypeToString(currentCurrencyType))
		)
		newItemDescription = string.gsub(
			newItemDescription,
			"currencyAmount",
			tostring(currentCurrencyAmount)
		)
		setHeaderText(buyHeaderText)
	end

	purchaseDialog.BodyFrame.ItemPreview.ItemDescription.Text =
		newItemDescription

	if purchasingConsumable then
		purchaseDialog.BodyFrame.ItemPreview.Image =
			`{baseUrl}thumbs/asset.ashx?assetid={currentProductInfo.IconImageAssetId}&x=100&y=100&format=png`
	else
		purchaseDialog.BodyFrame.ItemPreview.Image =
			`{baseUrl}thumbs/asset.ashx?assetid={currentAssetId}&x=100&y=100&format=png`
	end
end

-- more enum to int fun!
local function membershipTypeToNumber(membership: EnumItem) -- idk if there's a better type than EnumItem
	if membership == Enum.MembershipType.None then
		return 0
	elseif membership == Enum.MembershipType.BuildersClub then
		return 1
	elseif membership == Enum.MembershipType.TurboBuildersClub then
		return 2
	elseif membership == Enum.MembershipType.OutrageousBuildersClub then
		return 3
	end

	return -1
end

-- should open an external default browser window to this url
local function openBuyCurrencyWindow()
	checkingPlayerFunds = true
	GuiService:OpenBrowserWindow(`{baseUrl}Upgrades/Robux.aspx`)
end

-- set up the gui text at the bottom of the prompt (alerts user to how much money they will have left, or if they need to buy more to buy the item)
local function updateAfterBalanceText(playerBalance, notRightBc)
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

	-- check to see if we have enough of the desired currency to allow a purchase, if not we need to prompt user to buy robux
	if not notRightBc then
		if afterBalanceNumber < 0 and keyWord == "robux" then
			if openBuyCurrencyWindowConnection == nil then
				openBuyCurrencyWindowConnection =
					purchaseDialog.BodyFrame.AfterBalanceButton.MouseButton1Click:connect(
						openBuyCurrencyWindow
					)
			end
			purchaseDialog.BodyFrame.AfterBalanceButton.Text =
				`You need R$ {-afterBalanceNumber} more to buy this, click here to purchase more.`
			return true, true
		elseif afterBalanceNumber < 0 and keyWord == "tickets" then
			purchaseDialog.BodyFrame.AfterBalanceButton.Text =
				`You need {-afterBalanceNumber} Tix more to buy this item.`
			return true, true -- user can't buy more tickets, so we say fail the transaction (maybe instead we can prompt them to trade currency???)
		end
	end

	-- this ensures that we only have one connection to openBuyCurrencyWindow at a time (otherwise might open multiple browser windows)
	if openBuyCurrencyWindowConnection then
		openBuyCurrencyWindowConnection:disconnect()
		openBuyCurrencyWindowConnection = nil
	end
	purchaseDialog.BodyFrame.AfterBalanceButton.Text =
		`Your balance after this transaction will be {currencyTypeToString(
			currentCurrencyType
		)} {afterBalanceNumber}.`
	return true, false
end

-- will get the player's balance of robux and tix, return in a table
local function getPlayerBalance()
	local playerBalance
	local success, errorCode = ypcall(function()
		playerBalance =
			game:HttpGetAsync(`{getSecureApiBaseUrl()}currency/balance`)
	end)
	if not success then
		print("Get player balance failed because", errorCode)
		return
	elseif playerBalance == "" then
		return
	end

	return HttpService:JSONDecode(playerBalance)
end

-- figure out what currency to use based on the currency you can actually sell the item in and what the script specified
local function setCurrencyAmountAndType(priceInRobux, priceInTix)
	if
		currentCurrencyType == Enum.CurrencyType.Default
		or currentCurrencyType == Enum.CurrencyType.Robux
	then -- sell for default (user doesn't care) or robux
		if priceInRobux ~= nil and priceInRobux ~= 0 then -- we can sell for robux
			currentCurrencyAmount = priceInRobux
			currentCurrencyType = Enum.CurrencyType.Robux
		else -- have to use tix
			currentCurrencyAmount = priceInTix
			currentCurrencyType = Enum.CurrencyType.Tix
		end
	elseif currentCurrencyType == Enum.CurrencyType.Tix then -- we want to sell for tix
		if priceInTix ~= nil and priceInTix ~= 0 then -- we can sell for tix
			currentCurrencyAmount = priceInTix
			currentCurrencyType = Enum.CurrencyType.Tix
		else -- have to use robux
			currentCurrencyAmount = priceInRobux
			currentCurrencyType = Enum.CurrencyType.Robux
		end
	else
		return false
	end

	if currentCurrencyAmount == nil then
		return false
	end

	return true
end

-- This functions checks to make sure the purchase is even possible, if not it returns false and we don't prompt user (some situations require user feedback when we won't prompt)
local function canPurchaseItem()
	-- first we see if player already owns the asset/get the productinfo
	local playerOwnsAsset = false
	local notRightBc = false
	local descText
	local success = false

	if purchasingConsumable then
		local currentProductInfoRaw
		success = ypcall(function()
			currentProductInfoRaw = Game:HttpGetAsync(
				`{getSecureApiBaseUrl()}marketplace/productDetails?productid={currentProductId}`
			)
		end)
		if success then
			currentProductInfo = HttpService:JSONDecode(currentProductInfoRaw)
		end
	else
		success = ypcall(function()
			currentProductInfo =
				MarketplaceService:GetProductInfo(currentAssetId)
		end)
	end

	if currentProductInfo == nil or not success then
		return true,
			nil,
			nil,
			true,
			"In-game sales are temporarily disabled. Please try again later."
	end

	if not purchasingConsumable then
		if not currentAssetId then
			print "current asset id is nil, this should always have a value"
			return false
		end
		if currentAssetId <= 0 then
			print "current asset id is negative, this should always be positive"
			return false
		end

		local success2, errorCode = ypcall(function()
			playerOwnsAsset = game:HttpGetAsync(
				`{getSecureApiBaseUrl()}ownership/hasAsset?userId={game.Players.LocalPlayer.userId}&assetId={currentAssetId}`
			)
		end)

		if not success2 then
			print("could not tell if player owns asset because", errorCode)
			return false
		end

		if playerOwnsAsset == true or playerOwnsAsset == "true" then
			descText = "You already own this item."
			return true, nil, nil, true, descText
		end
	end

	purchaseDialog.BodyFrame.AfterBalanceButton.Visible = true

	-- next we parse through product info and see if we can purchase

	if type(currentProductInfo) ~= "table" then
		currentProductInfo = HttpService:JSONDecode(currentProductInfo)
	end

	if not currentProductInfo then
		descText = "Could not get product info. Please try again later."
		return true, nil, nil, true, descText
	end

	if
		currentProductInfo.IsForSale == false
		and currentProductInfo.IsPublicDomain == false
	then
		descText = "This item is no longer for sale."
		return true, nil, nil, true, descText
	end

	-- now we start talking money, making sure we are going to be able to purchase this
	if
		not setCurrencyAmountAndType(
			tonumber(currentProductInfo.PriceInRobux),
			tonumber(currentProductInfo.PriceInTickets)
		)
	then
		descText =
			"We could retrieve the price of the item correctly. Please try again later."
		return true, nil, nil, true, descText
	end

	local playerBalance = getPlayerBalance()
	if not playerBalance then
		descText = "Could not retrieve your balance. Please try again later."
		return true, nil, nil, true, descText
	end

	if
		tonumber(currentProductInfo.MinimumMembershipLevel)
		> membershipTypeToNumber(game.Players.LocalPlayer.MembershipType)
	then
		notRightBc = true
	end

	local updatedBalance, insufficientFunds =
		updateAfterBalanceText(playerBalance, notRightBc)

	if notRightBc then
		purchaseDialog.BodyFrame.AfterBalanceButton.Active = true
		return true, insufficientFunds, notRightBc, false
	end

	if currentProductInfo.ContentRatingTypeId == 1 then
		if game.Players.LocalPlayer:GetUnder13() then
			descText =
				"Your account is under 13 so purchase of this item is not allowed."
			return true, nil, nil, true, descText
		end
	end

	if
		(
			currentProductInfo.IsLimited == true
			or currentProductInfo.IsLimitedUnique == true
		)
		and (
			currentProductInfo.Remaining == ""
			or currentProductInfo.Remaining == 0
			or currentProductInfo.Remaining == nil
		)
	then
		descText =
			"All copies of this item have been sold out! Try buying from other users on the website."
		return true, nil, nil, true, descText
	end

	if not updatedBalance then
		descText =
			"Could not update your balance. Please check back after some time."
		return true, nil, nil, true, descText
	end

	-- we use insufficient funds to display a prompt to buy more robux
	purchaseDialog.BodyFrame.AfterBalanceButton.Active = true
	return true, insufficientFunds
end

local function doPlayerFundsCheck(checkIndefinitely)
	if checkingPlayerFunds then
		local canPurchase, insufficientFunds = canPurchaseItem() -- check again to see if we can buy item
		if canPurchase and insufficientFunds then -- wait a bit and try a few more times
			local retries = 1000
			while
				(retries > 0 or checkIndefinitely)
				and insufficientFunds
				and checkingPlayerFunds
				and canPurchase
			do
				wait(0.1)
				canPurchase, insufficientFunds = canPurchaseItem()
				retries -= 1
			end
		end
		if canPurchase and not insufficientFunds then
			-- we can buy item! set our buttons up and we will exit this loop
			setButtonsVisible(
				purchaseDialog.BodyFrame.BuyButton,
				purchaseDialog.BodyFrame.CancelButton,
				purchaseDialog.BodyFrame.AfterBalanceButton
			)
		end
	end
end

local function openBCUpSellWindow()
	GuiService:OpenBrowserWindow(
		`{baseUrl}Upgrades/BuildersClubMemberships.aspx`
	)
end

-- user pressed the cancel button, just remove all purchasing prompts

local function showPurchasePrompt()
	local canPurchase, insufficientFunds, notRightBC, override, descText =
		canPurchaseItem()

	if canPurchase then
		updatePurchasePromptData()

		if override and descText then
			purchaseDialog.BodyFrame.ItemPreview.ItemDescription.Text = descText
			purchaseDialog.BodyFrame.AfterBalanceButton.Visible = false
		end
		game.GuiService:AddCenterDialog(
			purchaseDialog,
			Enum.CenterDialogType.ModalDialog,
			--ShowFunction
			function()
				-- set the state for our buttons
				purchaseDialog.Visible = true
				if isFreeItem() then
					setButtonsVisible(
						purchaseDialog.BodyFrame.FreeButton,
						purchaseDialog.BodyFrame.CancelButton,
						purchaseDialog.BodyFrame.AfterBalanceButton
					)
				elseif notRightBC then
					purchaseDialog.BodyFrame.AfterBalanceButton.Text =
						"You require an upgrade to your Builders Club membership to purchase this item. Click here to upgrade."
					if not openBCUpSellWindowConnection then
						openBCUpSellWindowConnection = purchaseDialog.BodyFrame.AfterBalanceButton.MouseButton1Click:connect(
							function()
								if
									purchaseDialog.BodyFrame.AfterBalanceButton.Text
									== "You require an upgrade to your Builders Club membership to purchase this item. Click here to upgrade."
								then
									openBCUpSellWindow()
								end
							end
						)
					end
					setButtonsVisible(
						purchaseDialog.BodyFrame.BuyDisabledButton,
						purchaseDialog.BodyFrame.CancelButton,
						purchaseDialog.BodyFrame.AfterBalanceButton
					)
				elseif insufficientFunds then
					setButtonsVisible(
						purchaseDialog.BodyFrame.BuyDisabledButton,
						purchaseDialog.BodyFrame.CancelButton,
						purchaseDialog.BodyFrame.AfterBalanceButton
					)
				elseif override then
					setButtonsVisible(
						purchaseDialog.BodyFrame.BuyDisabledButton,
						purchaseDialog.BodyFrame.CancelButton
					) -- , purchaseDialog.BodyFrame.AfterBalanceButton)
				else
					setButtonsVisible(
						purchaseDialog.BodyFrame.BuyButton,
						purchaseDialog.BodyFrame.CancelButton
					) -- , purchaseDialog.BodyFrame.AfterBalanceButton)
				end

				purchaseDialog:TweenPosition(
					showPosition,
					Enum.EasingDirection.Out,
					Enum.EasingStyle.Quad,
					tweenTime,
					true
				)

				if
					canPurchase
					and insufficientFunds
					and not enableBrowserWindowClosedEvent
				then
					checkingPlayerFunds = true
					doPlayerFundsCheck(true)
				end
			end,
			--HideFunction
			function()
				purchaseDialog.Visible = false
			end
		)
	else -- we failed in prompting a purchase, do a decline
		userPurchaseActionsEnded(false)
	end
end

-- given an asset id, this function will grab that asset from the website, and return the first "Tool" object found inside it
local function getToolAssetID(assetID)
	local newTool = game:GetService("InsertService"):LoadAsset(assetID)
	if not newTool then
		return nil
	end

	if newTool:IsA "Tool" then
		return newTool
	end

	local toolChildren = newTool:GetChildren()
	for i = 1, #toolChildren do
		if toolChildren[i]:IsA "Tool" then
			return toolChildren[i]
		end
	end
	return nil
end

-- the user tried to purchase by clicking the purchase button, but something went wrong.
-- let them know their account was not charged, and that they do not own the item yet.
local function purchaseFailed(inGamePurchasesDisabled)
	local name = "Item"
	if currentProductInfo then
		name = currentProductInfo.Name
	end

	local newPurchasedFailedText =
		string.gsub(purchaseFailedText, "itemName", tostring(name))
	if inGamePurchasesDisabled then
		newPurchasedFailedText = string.gsub(
			newPurchasedFailedText,
			"errorReason",
			tostring(errorPurchasesDisabledText)
		)
	else
		newPurchasedFailedText = string.gsub(
			newPurchasedFailedText,
			"errorReason",
			tostring(errorPurchasesUnknownText)
		)
	end

	purchaseDialog.BodyFrame.ItemPreview.ItemDescription.Text =
		newPurchasedFailedText
	purchaseDialog.BodyFrame.ItemPreview.Image = errorImageUrl

	setButtonsVisible(purchaseDialog.BodyFrame.OkButton)

	setHeaderText(buyFailedHeaderText)

	hidePurchasing()
end

local function startSpinner()
	spinning = true
	Spawn(function()
		local spinPos = 0
		while spinning do
			local pos = 0

			while pos < 8 do
				if pos == spinPos or pos == ((spinPos + 1) % 8) then
					spinnerIcons[pos + 1].Image = assetUrl(45880668)
				else
					spinnerIcons[pos + 1].Image = assetUrl(45880710)
				end

				pos += 1
			end
			spinPos = (spinPos + 1) % 8
			wait(1 / 15)
		end
	end)
end

-- user has specified they want to buy an item, now try to attempt to buy it for them
local function acceptPurchase()
	-- shows a purchasing ui (shows spinner)
	startSpinner()
	purchaseDialog.PurchasingFrame.Visible = true

	local startTime = tick()

	-- http call to do the purchase
	local response = "none"
	local url = `{getSecureApiBaseUrl()}marketplace/`

	local currencyData = `&currencyTypeId={currencyEnumToInt(
		currentCurrencyType
	)}&currencyTypeId={currencyEnumToInt(currentCurrencyType)}`

	-- consumables need to use a different url
	if purchasingConsumable then
		url ..= `submitpurchase?productId={currentProductId}{currencyData}&expectedUnitPrice={currentCurrencyAmount}&placeId={Game.PlaceId}`
	else
		url ..= `purchase?productId={currentProductId}{currencyData}&purchasePrice={currentCurrencyAmount}&locationType=Game&locationId={Game.PlaceId}`
	end

	local success, reason = ypcall(function()
		response = game:HttpPostAsync(url, "RobloxPurchaseRequest")
	end)

	-- debug output for us (found in the logs from local)
	print(
		"acceptPurchase success from ypcall is ",
		success,
		"reason is",
		reason
	)

	if tick() - startTime < 1 then
		wait(1) -- allow the purchasing waiting dialog to at least be readable (otherwise it might flash, looks bad)...
	end

	-- check to make sure purchase actually happened on the web end
	if response == "none" or response == nil or response == "" then
		print(
			"did not get a proper response from web on purchase of",
			currentAssetId,
			currentProductId
		)
		purchaseFailed()
		return
	end

	-- parse our response, decide how to react
	response = HttpService:JSONDecode(response)

	if response then
		if response.success == false and response.status ~= "AlreadyOwned" then
			print(
				"web return response of fail on purchase of",
				currentAssetId,
				currentProductId
			)
			purchaseFailed((response.status == "EconomyDisabled"))
			return
		end
	else
		print(
			"web return response of non parsable JSON on purchase of",
			currentAssetId
		)
		purchaseFailed()
		return
	end

	-- check to see if this item was bought, and if we want to equip it (also need to make sure the asset type was gear)
	if
		currentEquipOnPurchase
		and success
		and currentAssetId
		and tonumber(currentProductInfo.AssetTypeId) == 19
	then
		local tool = getToolAssetID(tonumber(currentAssetId))
		if tool then
			tool.Parent = game.Players.LocalPlayer.Backpack
		end
	end

	if purchasingConsumable then
		if not response.receipt then
			print(
				"tried to buy productId, but no receipt returned. productId was",
				currentProductId
			)
			purchaseFailed()
			return
		end
		MarketplaceService:SignalClientPurchaseSuccess(
			tostring(response.receipt),
			game.Players.LocalPlayer.userId,
			currentProductId
		)
	else
		userPurchaseActionsEnded(success)
	end
end

-------------------------------- End Accept/Decline Functions --------------------------------------

---------------------------------------------- Gui Functions ----------------------------------------------

-- used for the "Purchasing..." frame
local function createSpinner(size, position, parent)
	local spinnerFrame = Instance.new "Frame"
	spinnerFrame.Name = "Spinner"
	spinnerFrame.Size = size
	spinnerFrame.Position = position
	spinnerFrame.BackgroundTransparency = 1
	spinnerFrame.ZIndex = 10
	spinnerFrame.Parent = parent

	spinnerIcons = {}
	local spinnerNum = 1
	while spinnerNum <= 8 do
		local spinnerImage = Instance.new "ImageLabel"
		spinnerImage.Name = `Spinner{spinnerNum}`
		spinnerImage.Size = UDim2.new(0, 16, 0, 16)
		spinnerImage.Position = UDim2.new(
			0.5 + 0.3 * math.cos(math.rad(45 * spinnerNum)),
			-8,
			0.5 + 0.3 * math.sin(math.rad(45 * spinnerNum)),
			-8
		)
		spinnerImage.BackgroundTransparency = 1
		spinnerImage.ZIndex = 10
		spinnerImage.Image = assetUrl(45880710)
		spinnerImage.Parent = spinnerFrame

		spinnerIcons[spinnerNum] = spinnerImage
		spinnerNum += 1
	end
end

local function userPurchaseProductActionsEnded(userIsClosingDialog)
	checkingPlayerFunds = false

	if userIsClosingDialog then
		closePurchasePrompt()
		if currentServerResponseTable then
			local isPurchased = false
			if
				string.lower(tostring(currentServerResponseTable.isValid))
				== "true"
			then
				isPurchased = true
			end

			MarketplaceService:SignalPromptProductPurchaseFinished(
				tonumber(currentServerResponseTable.playerId),
				tonumber(currentServerResponseTable.productId),
				isPurchased
			)
		else
			print "Something went wrong, no currentServerResponseTable"
		end
		removeCurrentPurchaseInfo()
	else
		local newPurchasedSucceededText = string.gsub(
			purchaseSucceededText,
			"itemName",
			tostring(currentProductInfo.Name)
		)
		purchaseDialog.BodyFrame.ItemPreview.ItemDescription.Text =
			newPurchasedSucceededText
		setButtonsVisible(purchaseDialog.BodyFrame.OkPurchasedButton)
		hidePurchasing()
	end
end

local function createImageButton(name)
	local imageButton = Instance.new "ImageButton"
	imageButton.Size = UDim2.new(0, 153, 0, 46)
	imageButton.Name = name
	return imageButton
end

local function createTextObject(name, text, type, size)
	local textLabel = Instance.new(type)
	textLabel.Font = Enum.Font.ArialBold
	textLabel.TextColor3 = Color3.new(217 / 255, 217 / 255, 217 / 255)
	textLabel.TextWrapped = true
	textLabel.Name = name
	textLabel.Text = text
	textLabel.BackgroundTransparency = 1
	textLabel.BorderSizePixel = 0
	textLabel.FontSize = size

	return textLabel
end

-- all the gui init.  Would be nice if this didn't have to be a script
local function createPurchasePromptGui()
	purchaseDialog = Instance.new "Frame"
	purchaseDialog.Name = "PurchaseFrame"
	purchaseDialog.Size = UDim2.new(0, 660, 0, 400)
	purchaseDialog.Position = hidePosition
	purchaseDialog.Visible = false
	purchaseDialog.BackgroundColor3 =
		Color3.new(141 / 255, 141 / 255, 141 / 255)
	purchaseDialog.BorderColor3 = Color3.new(204 / 255, 204 / 255, 204 / 255)
	purchaseDialog.Parent = game.CoreGui.RobloxGui

	local bodyFrame = Instance.new "Frame"
	bodyFrame.Name = "BodyFrame"
	bodyFrame.Size = UDim2.new(1, 0, 1, -60)
	bodyFrame.Position = UDim2.new(0, 0, 0, 60)
	bodyFrame.BackgroundColor3 = Color3.new(67 / 255, 67 / 255, 67 / 255)
	bodyFrame.BorderSizePixel = 0
	bodyFrame.ZIndex = 8
	bodyFrame.Parent = purchaseDialog

	local titleLabel = createTextObject(
		"TitleLabel",
		"Buy Item",
		"TextLabel",
		Enum.FontSize.Size48
	)
	titleLabel.ZIndex = 8
	titleLabel.Size = UDim2.new(1, 0, 0, 60)
	local titleBackdrop = titleLabel:Clone()
	titleBackdrop.Name = "TitleBackdrop"
	titleBackdrop.TextColor3 = Color3.new(32 / 255, 32 / 255, 32 / 255)
	titleBackdrop.BackgroundTransparency = 0.0
	titleBackdrop.BackgroundColor3 = Color3.new(54 / 255, 96 / 255, 171 / 255)
	titleBackdrop.Position = UDim2.new(0, 0, 0, -2)
	titleBackdrop.ZIndex = 8
	titleBackdrop.Parent = purchaseDialog
	titleLabel.Parent = purchaseDialog

	local distanceBetweenButtons = 90

	local cancelButton = createImageButton "CancelButton"
	cancelButton.Position =
		UDim2.new(0.5, (distanceBetweenButtons / 2), 1, -120)
	cancelButton.BackgroundTransparency = 1
	cancelButton.BorderSizePixel = 0
	cancelButton.Parent = bodyFrame
	cancelButton.Modal = true
	cancelButton.ZIndex = 8
	cancelButton.Image = cancelButtonImageUrl
	cancelButton.MouseButton1Down:connect(function()
		cancelButton.Image = cancelButtonDownUrl
	end)
	cancelButton.MouseButton1Up:connect(function()
		cancelButton.Image = cancelButtonImageUrl
	end)
	cancelButton.MouseLeave:connect(function()
		cancelButton.Image = cancelButtonImageUrl
	end)
	cancelButton.MouseButton1Click:connect(function()
		-- user pressed the cancel button, just remove all purchasing prompts
		userPurchaseActionsEnded(false)
	end)

	local buyButton = createImageButton "BuyButton"
	buyButton.Position =
		UDim2.new(0.5, -153 - (distanceBetweenButtons / 2), 1, -120)
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

	local buyDisabledButton = buyButton:Clone()
	buyDisabledButton.Name = "BuyDisabledButton"
	buyDisabledButton.AutoButtonColor = false
	buyDisabledButton.Visible = false
	buyDisabledButton.Active = false
	buyDisabledButton.Image = buyImageDisabledUrl
	buyDisabledButton.ZIndex = 8
	buyDisabledButton.Parent = bodyFrame

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

	local okPurchasedButton = okButton:Clone()
	okPurchasedButton.ZIndex = 8
	okPurchasedButton.Name = "OkPurchasedButton"
	okPurchasedButton.MouseButton1Down:connect(function()
		okPurchasedButton.Image = okButtonPressedrl
	end)
	okPurchasedButton.MouseButton1Up:connect(function()
		okPurchasedButton.Image = okButtonUrl
	end)
	okPurchasedButton.MouseLeave:connect(function()
		okPurchasedButton.Image = okButtonUrl
	end)
	okPurchasedButton.Parent = bodyFrame

	okButton.MouseButton1Click:connect(function()
		userPurchaseActionsEnded(false)
	end)
	okPurchasedButton.MouseButton1Click:connect(function()
		if purchasingConsumable then
			userPurchaseProductActionsEnded(true)
		else
			signalPromptEnded(true)
		end
	end)
	buyButton.MouseButton1Click:connect(function()
		acceptPurchase()
	end)
	freeButton.MouseButton1Click:connect(function()
		acceptPurchase()
	end)

	local itemPreview = Instance.new "ImageLabel"
	itemPreview.Name = "ItemPreview"
	itemPreview.BackgroundColor3 = Color3.new(32 / 255, 32 / 255, 32 / 255)
	itemPreview.BorderColor3 = Color3.new(141 / 255, 141 / 255, 141 / 255)
	itemPreview.Position = UDim2.new(0, 30, 0, 20)
	itemPreview.Size = UDim2.new(0, 180, 0, 180)
	itemPreview.ZIndex = 9
	itemPreview.Parent = bodyFrame

	local itemDescription = createTextObject(
		"ItemDescription",
		"Would you like to buy the 'itemName' for currencyType currencyAmount?",
		"TextLabel",
		Enum.FontSize.Size24
	)
	itemDescription.Position = UDim2.new(1, 20, 0, 0)
	itemDescription.Size = UDim2.new(0, 410, 1, 0)
	itemDescription.ZIndex = 8
	itemDescription.Parent = itemPreview

	local afterBalanceButton = createTextObject(
		"AfterBalanceButton",
		"Place holder text ip sum lorem dodo ashs",
		"TextButton",
		Enum.FontSize.Size24
	)
	afterBalanceButton.AutoButtonColor = false
	afterBalanceButton.TextColor3 = Color3.new(222 / 255, 59 / 255, 30 / 255)
	afterBalanceButton.Position = UDim2.new(0, 5, 1, -55)
	afterBalanceButton.Size = UDim2.new(1, -10, 0, 50)
	afterBalanceButton.ZIndex = 8
	afterBalanceButton.Parent = bodyFrame

	local purchasingFrame = Instance.new "Frame"
	purchasingFrame.Name = "PurchasingFrame"
	purchasingFrame.Size = UDim2.new(1, 0, 1, 0)
	purchasingFrame.BackgroundColor3 = Color3.new(0, 0, 0)
	purchasingFrame.BackgroundTransparency = 0.2
	purchasingFrame.BorderSizePixel = 0
	purchasingFrame.ZIndex = 9
	purchasingFrame.Visible = false
	purchasingFrame.Active = true
	purchasingFrame.Parent = purchaseDialog

	local purchasingLabel = createTextObject(
		"PurchasingLabel",
		"Purchasing...",
		"TextLabel",
		Enum.FontSize.Size48
	)
	purchasingLabel.Size = UDim2.new(1, 0, 1, 0)
	purchasingLabel.ZIndex = 10
	purchasingLabel.Parent = purchasingFrame

	createSpinner(
		UDim2.new(0, 50, 0, 50),
		UDim2.new(0.5, -25, 0.5, 30),
		purchasingLabel
	)
end

local function doPurchasePrompt(
	player,
	assetId,
	equipIfPurchased,
	currencyType,
	productId
)
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

		showPurchasePrompt()
	end
end

local function doProcessServerPurchaseResponse(serverResponseTable)
	if not serverResponseTable then
		print "Server response table was nil, cancelling purchase"
		purchaseFailed()
		return
	end

	if
		serverResponseTable.playerId
		and tonumber(serverResponseTable.playerId)
			== game.Players.LocalPlayer.userId
	then
		currentServerResponseTable = serverResponseTable
		userPurchaseProductActionsEnded(false)
	end
end

---------------------------------------------- End Gui Functions ----------------------------------------------

---------------------------------------------- Script Event start/initialization ----------------------------------------------
preloadAssets()

MarketplaceService.PromptProductPurchaseRequested:connect(
	function(player, productId, equipIfPurchased, currencyType)
		doPurchasePrompt(player, nil, equipIfPurchased, currencyType, productId)
	end
)

MarketplaceService.PromptPurchaseRequested:connect(
	function(player, assetId, equipIfPurchased, currencyType)
		doPurchasePrompt(player, assetId, equipIfPurchased, currencyType, nil)
	end
)

MarketplaceService.ServerPurchaseVerification:connect(
	function(serverResponseTable)
		doProcessServerPurchaseResponse(serverResponseTable)
	end
)

if enableBrowserWindowClosedEvent then
	GuiService.BrowserWindowClosed:connect(function()
		doPlayerFundsCheck(false)
	end)
end
