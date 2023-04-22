while not Game do wait(0.1)end while not game:GetService'MarketplaceService'do
wait(0.1)end while not game:FindFirstChild'CoreGui'do wait(0.1)end while not
game.CoreGui:FindFirstChild'RobloxGui'do wait(0.1)end local a,b,c,d,e,f,g,h,i,j,
k,l,m,n,o,p,q,r,s,t,u,v,w,x,y=nil,game:GetService'ContentProvider'.BaseUrl:
lower(),nil,nil,nil,nil,nil,nil,nil,false,nil,false,true,nil,false,nil,0.3,UDim2
.new(0.5,-330,0.5,-200),UDim2.new(0.5,-330,1,25),nil,false,nil,450,{},
'http://www.roblox.com/Asset/?id='local z=y..'42557901'table.insert(x,z)local A=
y..'104651457'table.insert(x,A)local B=y..'104651515'table.insert(x,B)local C=y
..'104651532'table.insert(x,C)local D=y..'104651592'table.insert(x,D)local E=y..
'104651639'table.insert(x,E)local F=y..'104651665'table.insert(x,F)local G=y..
'104651707'table.insert(x,G)local H=y..'104651733'table.insert(x,H)local I=y..
'104651761'table.insert(x,I)local J=y..'102481431'table.insert(x,J)local K=y..
'102481419'table.insert(x,K)local L,M,N,O,P,Q,R,S,T,U='Buy','Take',
'An Error Occurred','in-game purchases are disabled',
'Roblox is performing maintenance','Your purchase of itemName succeeded!',
[[Your purchase of itemName failed because errorReason. Your account has not been charged. Please try again soon.]]
,[[Would you like to buy 'itemName' for currencyType currencyAmount?]],
"Would you like to take the assetType 'itemName' for FREE?",
[[Your balance of Robux or Tix will not be affected by this transaction.]]
function getSecureApiBaseUrl()local V=b V=string.gsub(V,'http','https')V=string.
gsub(V,'www','api')return V end function getRbxUtility()if not a then a=
LoadLibrary'RbxUtility'end return a end function preloadAssets()for V=1,#x do
game:GetService'ContentProvider':Preload(x[V])end end function
removeCurrentPurchaseInfo()d=nil e=nil f=nil g=nil h=nil c=nil i=nil j=false end
function closePurchasePrompt()p:TweenPosition(s,Enum.EasingDirection.Out,Enum.
EasingStyle.Quad,q,true,function()game.GuiService:RemoveCenterDialog(p)
hidePurchasing()p.Visible=false o=false end)end function
userPurchaseActionsEnded(V)j=false if V then local W=string.gsub(Q,'itemName',
tostring(c['Name']))p.BodyFrame.ItemPreview.ItemDescription.Text=W
setButtonsVisible(p.BodyFrame.OkPurchasedButton)hidePurchasing()else
signalPromptEnded(V)end end function signalPromptEnded(V)closePurchasePrompt()if
l then game:GetService'MarketplaceService':SignalPromptProductPurchaseFinished(
game.Players.LocalPlayer.userId,h,V)else game:GetService'MarketplaceService':
SignalPromptPurchaseFinished(game.Players.LocalPlayer,d,V)end
removeCurrentPurchaseInfo()end function updatePurchasePromptData(V)local W=''if
not h then h=c['ProductId']end if isFreeItem()then W=string.gsub(T,'itemName',
tostring(c['Name']))W=string.gsub(W,'assetType',tostring(assetTypeToString(c[
'AssetTypeId'])))setHeaderText(M)else W=string.gsub(S,'itemName',tostring(c[
'Name']))W=string.gsub(W,'currencyType',tostring(currencyTypeToString(e)))W=
string.gsub(W,'currencyAmount',tostring(f))setHeaderText(L)end p.BodyFrame.
ItemPreview.ItemDescription.Text=W if l then p.BodyFrame.ItemPreview.Image=b..
'thumbs/asset.ashx?assetid='..tostring(c['IconImageAssetId'])..
'&x=100&y=100&format=png'else p.BodyFrame.ItemPreview.Image=b..
'thumbs/asset.ashx?assetid='..tostring(d)..'&x=100&y=100&format=png'end end
function doPlayerFundsCheck(V)if j then local W,X=canPurchaseItem()if W and X
then local Y=1000 while(Y>0 or V)and X and j and W do wait(0.1)W,X=
canPurchaseItem()Y=Y-1 end end if W and not X then setButtonsVisible(p.BodyFrame
.BuyButton,p.BodyFrame.CancelButton,p.BodyFrame.AfterBalanceButton)end end end
function showPurchasePrompt()local V,W,X,Y,Z=canPurchaseItem()if V then
updatePurchasePromptData()if Y and Z then p.BodyFrame.ItemPreview.
ItemDescription.Text=Z p.BodyFrame.AfterBalanceButton.Visible=false end game.
GuiService:AddCenterDialog(p,Enum.CenterDialogType.ModalDialog,function()p.
Visible=true if isFreeItem()then setButtonsVisible(p.BodyFrame.FreeButton,p.
BodyFrame.CancelButton,p.BodyFrame.AfterBalanceButton)elseif X then p.BodyFrame.
AfterBalanceButton.Text=
[[You require an upgrade to your Builders Club membership to purchase this item. Click here to upgrade.]]
if not k then k=p.BodyFrame.AfterBalanceButton.MouseButton1Click:connect(
function()if p.BodyFrame.AfterBalanceButton.Text==
[[You require an upgrade to your Builders Club membership to purchase this item. Click here to upgrade.]]
then openBCUpSellWindow()end end)end setButtonsVisible(p.BodyFrame.
BuyDisabledButton,p.BodyFrame.CancelButton,p.BodyFrame.AfterBalanceButton)elseif
W then setButtonsVisible(p.BodyFrame.BuyDisabledButton,p.BodyFrame.CancelButton,
p.BodyFrame.AfterBalanceButton)elseif Y then setButtonsVisible(p.BodyFrame.
BuyDisabledButton,p.BodyFrame.CancelButton)else setButtonsVisible(p.BodyFrame.
BuyButton,p.BodyFrame.CancelButton)end p:TweenPosition(r,Enum.EasingDirection.
Out,Enum.EasingStyle.Quad,q,true)if V and W and not m then j=true
doPlayerFundsCheck(true)end end,function()p.Visible=false end)else
doDeclinePurchase()end end function getToolAssetID(V)local W=game:GetService
'InsertService':LoadAsset(V)if not W then return nil end if W:IsA'Tool'then
return W end local X=W:GetChildren()for Y=1,#X do if X[Y]:IsA'Tool'then return X
[Y]end end return nil end function purchaseFailed(V)local W='Item'if c then W=c[
'Name']end local X=string.gsub(R,'itemName',tostring(W))if V then X=string.gsub(
X,'errorReason',tostring(O))else X=string.gsub(X,'errorReason',tostring(P))end p
.BodyFrame.ItemPreview.ItemDescription.Text=X p.BodyFrame.ItemPreview.Image=z
setButtonsVisible(p.BodyFrame.OkButton)setHeaderText(N)hidePurchasing()end
function doAcceptPurchase(V)showPurchasing()local W,X,Y=tick(),'none',nil if l
then Y=getSecureApiBaseUrl()..'marketplace/submitpurchase?productId='..tostring(
h)..'&currencyTypeId='..tostring(currencyEnumToInt(e))..'&expectedUnitPrice='..
tostring(f)..'&placeId='..tostring(Game.PlaceId)else Y=getSecureApiBaseUrl()..
'marketplace/purchase?productId='..tostring(h)..'&currencyTypeId='..tostring(
currencyEnumToInt(e))..'&purchasePrice='..tostring(f)..'&locationType=Game'..
'&locationId='..Game.PlaceId end local Z,_=ypcall(function()X=game:
HttpPostAsync(Y,'RobloxPurchaseRequest')end)print(
'doAcceptPurchase success from ypcall is ',Z,'reason is',_)if(tick()-W)<1 then
wait(1)end if X=='none'or X==nil or X==''then print(
'did not get a proper response from web on purchase of',d,h)purchaseFailed()
return end X=getRbxUtility().DecodeJSON(X)if X then if X['success']==false then
if X['status']~='AlreadyOwned'then print(
'web return response of fail on purchase of',d,h)purchaseFailed((X['status']==
'EconomyDisabled'))return end end else print(
'web return response of non parsable JSON on purchase of',d)purchaseFailed()
return end if g and Z and d and tonumber(c['AssetTypeId'])==19 then local aa=
getToolAssetID(tonumber(d))if aa then aa.Parent=game.Players.LocalPlayer.
Backpack end end if l then if not X['receipt']then print(
[[tried to buy productId, but no receipt returned. productId was]],h)
purchaseFailed()return end Game:GetService'MarketplaceService':
SignalClientPurchaseSuccess(tostring(X['receipt']),game.Players.LocalPlayer.
userId,h)else userPurchaseActionsEnded(Z)end end function doDeclinePurchase()
userPurchaseActionsEnded(false)end function currencyEnumToInt(aa)if aa==Enum.
CurrencyType.Robux or aa==Enum.CurrencyType.Default then return 1 elseif aa==
Enum.CurrencyType.Tix then return 2 end end function assetTypeToString(aa)if aa
==1 then return'Image'elseif aa==2 then return'T-Shirt'elseif aa==3 then return
'Audio'elseif aa==4 then return'Mesh'elseif aa==5 then return'Lua'elseif aa==6
then return'HTML'elseif aa==7 then return'Text'elseif aa==8 then return'Hat'
elseif aa==9 then return'Place'elseif aa==10 then return'Model'elseif aa==11
then return'Shirt'elseif aa==12 then return'Pants'elseif aa==13 then return
'Decal'elseif aa==16 then return'Avatar'elseif aa==17 then return'Head'elseif aa
==18 then return'Face'elseif aa==19 then return'Gear'elseif aa==21 then return
'Badge'elseif aa==22 then return'Group Emblem'elseif aa==24 then return
'Animation'elseif aa==25 then return'Arms'elseif aa==26 then return'Legs'elseif
aa==27 then return'Torso'elseif aa==28 then return'Right Arm'elseif aa==29 then
return'Left Arm'elseif aa==30 then return'Left Leg'elseif aa==31 then return
'Right Leg'elseif aa==32 then return'Package'elseif aa==33 then return
'YouTube Video'elseif aa==34 then return'Game Pass'elseif aa==0 then return
'Product'end return''end function currencyTypeToString(aa)if aa==Enum.
CurrencyType.Tix then return'Tix'else return'R$'end end function
setCurrencyAmountAndType(aa,V)if e==Enum.CurrencyType.Default or e==Enum.
CurrencyType.Robux then if aa~=nil and aa~=0 then f=aa e=Enum.CurrencyType.Robux
else f=V e=Enum.CurrencyType.Tix end elseif e==Enum.CurrencyType.Tix then if V~=
nil and V~=0 then f=V e=Enum.CurrencyType.Tix else f=aa e=Enum.CurrencyType.
Robux end else return false end if f==nil then return false end return true end
function getPlayerBalance()local aa=nil local V,W=ypcall(function()aa=game:
HttpGetAsync(getSecureApiBaseUrl()..'currency/balance')end)if not V then print(
'Get player balance failed because',W)return nil end if aa==''then return nil
end aa=getRbxUtility().DecodeJSON(aa)return aa end function
openBuyCurrencyWindow()j=true game:GetService'GuiService':OpenBrowserWindow(b..
'Upgrades/Robux.aspx')end function openBCUpSellWindow()Game:GetService
'GuiService':OpenBrowserWindow(b..'Upgrades/BuildersClubMemberships.aspx')end
function updateAfterBalanceText(aa,V)if isFreeItem()then p.BodyFrame.
AfterBalanceButton.Text=U return true,false end local W=nil if e==Enum.
CurrencyType.Robux then W='robux'elseif e==Enum.CurrencyType.Tix then W=
'tickets'end if not W then return false end local X=tonumber(aa[W])if not X then
return false end local Y=X-f if not V then if Y<0 and W=='robux'then if n==nil
then n=p.BodyFrame.AfterBalanceButton.MouseButton1Click:connect(
openBuyCurrencyWindow)end p.BodyFrame.AfterBalanceButton.Text='You need '..
currencyTypeToString(e)..' '..tostring(-Y)..
' more to buy this, click here to purchase more.'return true,true elseif Y<0 and
W=='tickets'then p.BodyFrame.AfterBalanceButton.Text='You need '..tostring(-Y)..
' '..currencyTypeToString(e)..' more to buy this item.'return true,true end end
if n then n:disconnect()n=nil end p.BodyFrame.AfterBalanceButton.Text=
'Your balance after this transaction will be '..currencyTypeToString(e)..' '..
tostring(Y)..'.'return true,false end function isFreeItem()return c and c[
'IsForSale']==true and c['IsPublicDomain']==true end function
membershipTypeToNumber(aa)if aa==Enum.MembershipType.None then return 0 elseif
aa==Enum.MembershipType.BuildersClub then return 1 elseif aa==Enum.
MembershipType.TurboBuildersClub then return 2 elseif aa==Enum.MembershipType.
OutrageousBuildersClub then return 3 end return-1 end function canPurchaseItem()
local aa,V,W,X=false,false,nil,false if l then local Y=nil X=ypcall(function()Y=
Game:HttpGetAsync(getSecureApiBaseUrl()..'marketplace/productDetails?productid='
..tostring(h))end)if X then c=getRbxUtility().DecodeJSON(Y)end else X=ypcall(
function()c=game:GetService'MarketplaceService':GetProductInfo(d)end)end if c==
nil or not X then W=
[[In-game sales are temporarily disabled. Please try again later.]]return true,
nil,nil,true,W end if not l then if not d then print
'current asset id is nil, this should always have a value'return false end if d
<=0 then print[[current asset id is negative, this should always be positive]]
return false end local Y,Z=ypcall(function()aa=game:HttpGetAsync(
getSecureApiBaseUrl()..'ownership/hasAsset?userId='..tostring(game.Players.
LocalPlayer.userId)..'&assetId='..tostring(d))end)if not Y then print(
'could not tell if player owns asset because',Z)return false end if aa==true or
aa=='true'then W='You already own this item.'return true,nil,nil,true,W end end
p.BodyFrame.AfterBalanceButton.Visible=true if type(c)~='table'then c=
getRbxUtility().DecodeJSON(c)end if not c then W=
'Could not get product info. Please try again later.'return true,nil,nil,true,W
end if c['IsForSale']==false and c['IsPublicDomain']==false then W=
'This item is no longer for sale.'return true,nil,nil,true,W end if not
setCurrencyAmountAndType(tonumber(c['PriceInRobux']),tonumber(c['PriceInTickets'
]))then W=
[[We could retrieve the price of the item correctly. Please try again later.]]
return true,nil,nil,true,W end local Y=getPlayerBalance()if not Y then W=
'Could not retrieve your balance. Please try again later.'return true,nil,nil,
true,W end if tonumber(c['MinimumMembershipLevel'])>membershipTypeToNumber(game.
Players.LocalPlayer.MembershipType)then V=true end local Z,_=
updateAfterBalanceText(Y,V)if V then p.BodyFrame.AfterBalanceButton.Active=true
return true,_,V,false end if c['ContentRatingTypeId']==1 then if game.Players.
LocalPlayer:GetUnder13()then W=
[[Your account is under 13 so purchase of this item is not allowed.]]return true
,nil,nil,true,W end end if(c['IsLimited']==true or c['IsLimitedUnique']==true)
and(c['Remaining']==''or c['Remaining']==0 or c['Remaining']==nil)then W=
[[All copies of this item have been sold out! Try buying from other users on the website.]]
return true,nil,nil,true,W end if not Z then W=
[[Could not update your balance. Please check back after some time.]]return true
,nil,nil,true,W end p.BodyFrame.AfterBalanceButton.Active=true return true,_ end
function startSpinner()u=true Spawn(function()local aa=0 while u do local V=0
while V<8 do if V==aa or V==((aa+1)%8)then v[V+1].Image=
'http://www.roblox.com/Asset/?id=45880668'else v[V+1].Image=
'http://www.roblox.com/Asset/?id=45880710'end V=V+1 end aa=(aa+1)%8 wait(
6.666666666666666E-2)end end)end function stopSpinner()u=false end function
setButtonsVisible(...)local aa,V,W={...},select('#',...),p.BodyFrame:
GetChildren()for X=1,#W do if W[X]:IsA'GuiButton'then W[X].Visible=false for Y=1
,V do if W[X]==aa[Y]then W[X].Visible=true break end end end end end function
createSpinner(aa,V,W)local X=Instance.new'Frame'X.Name='Spinner'X.Size=aa X.
Position=V X.BackgroundTransparency=1 X.ZIndex=10 X.Parent=W v={}local Y=1 while
Y<=8 do local Z=Instance.new'ImageLabel'Z.Name='Spinner'..Y Z.Size=UDim2.new(0,
16,0,16)Z.Position=UDim2.new(0.5+0.3*math.cos(math.rad(45*Y)),-8,0.5+0.3*math.
sin(math.rad(45*Y)),-8)Z.BackgroundTransparency=1 Z.ZIndex=10 Z.Image=
'http://www.roblox.com/Asset/?id=45880710'Z.Parent=X v[Y]=Z Y=Y+1 end end
function createPurchasePromptGui()p=Instance.new'Frame'p.Name='PurchaseFrame'p.
Size=UDim2.new(0,660,0,400)p.Position=s p.Visible=false p.BackgroundColor3=
Color3.new(0.5529411764705883,0.5529411764705883,0.5529411764705883)p.
BorderColor3=Color3.new(0.8,0.8,0.8)p.Parent=game.CoreGui.RobloxGui local aa=
Instance.new'Frame'aa.Name='BodyFrame'aa.Size=UDim2.new(1,0,1,-60)aa.Position=
UDim2.new(0,0,0,60)aa.BackgroundColor3=Color3.new(0.2627450980392157,
0.2627450980392157,0.2627450980392157)aa.BorderSizePixel=0 aa.ZIndex=8 aa.Parent
=p local V=createTextObject('TitleLabel','Buy Item','TextLabel',Enum.FontSize.
Size48)V.ZIndex=8 V.Size=UDim2.new(1,0,0,60)local W=V:Clone()W.Name=
'TitleBackdrop'W.TextColor3=Color3.new(0.12549019607843137,0.12549019607843137,
0.12549019607843137)W.BackgroundTransparency=0 W.BackgroundColor3=Color3.new(
0.21176470588235294,0.3764705882352941,0.6705882352941176)W.Position=UDim2.new(0
,0,0,-2)W.ZIndex=8 W.Parent=p V.Parent=p local X,Y=90,createImageButton
'CancelButton'Y.Position=UDim2.new(0.5,(X/2),1,-120)Y.BackgroundTransparency=1 Y
.BorderSizePixel=0 Y.Parent=aa Y.Modal=true Y.ZIndex=8 Y.Image=D Y.
MouseButton1Down:connect(function()Y.Image=E end)Y.MouseButton1Up:connect(
function()Y.Image=D end)Y.MouseLeave:connect(function()Y.Image=D end)Y.
MouseButton1Click:connect(doDeclinePurchase)local Z=createImageButton'BuyButton'
Z.Position=UDim2.new(0.5,-153-(X/2),1,-120)Z.BackgroundTransparency=1 Z.
BorderSizePixel=0 Z.Image=A Z.ZIndex=8 Z.MouseButton1Down:connect(function()Z.
Image=B end)Z.MouseButton1Up:connect(function()Z.Image=A end)Z.MouseLeave:
connect(function()Z.Image=A end)Z.Parent=aa local _=Z:Clone()_.Name=
'BuyDisabledButton'_.AutoButtonColor=false _.Visible=false _.Active=false _.
Image=C _.ZIndex=8 _.Parent=aa local ab=Z:Clone()ab.BackgroundTransparency=1 ab.
Name='FreeButton'ab.Visible=false ab.ZIndex=8 ab.Image=H ab.MouseButton1Down:
connect(function()ab.Image=I end)ab.MouseButton1Up:connect(function()ab.Image=H
end)ab.MouseLeave:connect(function()ab.Image=H end)ab.Parent=aa local ac=Z:
Clone()ac.Name='OkButton'ac.BackgroundTransparency=1 ac.Visible=false ac.
Position=UDim2.new(0.5,-ac.Size.X.Offset/2,1,-120)ac.Modal=true ac.Image=F ac.
ZIndex=8 ac.MouseButton1Down:connect(function()ac.Image=G end)ac.MouseButton1Up:
connect(function()ac.Image=F end)ac.MouseLeave:connect(function()ac.Image=F end)
ac.Parent=aa local ad=ac:Clone()ad.ZIndex=8 ad.Name='OkPurchasedButton'ad.
MouseButton1Down:connect(function()ad.Image=G end)ad.MouseButton1Up:connect(
function()ad.Image=F end)ad.MouseLeave:connect(function()ad.Image=F end)ad.
Parent=aa ac.MouseButton1Click:connect(function()userPurchaseActionsEnded(false)
end)ad.MouseButton1Click:connect(function()if l then
userPurchaseProductActionsEnded(true)else signalPromptEnded(true)end end)Z.
MouseButton1Click:connect(function()doAcceptPurchase(Enum.CurrencyType.Robux)end
)ab.MouseButton1Click:connect(function()doAcceptPurchase(false)end)local ae=
Instance.new'ImageLabel'ae.Name='ItemPreview'ae.BackgroundColor3=Color3.new(
0.12549019607843137,0.12549019607843137,0.12549019607843137)ae.BorderColor3=
Color3.new(0.5529411764705883,0.5529411764705883,0.5529411764705883)ae.Position=
UDim2.new(0,30,0,20)ae.Size=UDim2.new(0,180,0,180)ae.ZIndex=9 ae.Parent=aa local
af=createTextObject('ItemDescription',
[[Would you like to buy the 'itemName' for currencyType currencyAmount?]],
'TextLabel',Enum.FontSize.Size24)af.Position=UDim2.new(1,20,0,0)af.Size=UDim2.
new(0,410,1,0)af.ZIndex=8 af.Parent=ae local ag=createTextObject(
'AfterBalanceButton','Place holder text ip sum lorem dodo ashs','TextButton',
Enum.FontSize.Size24)ag.AutoButtonColor=false ag.TextColor3=Color3.new(
0.8705882352941177,0.23137254901960785,0.11764705882352941)ag.Position=UDim2.
new(0,5,1,-55)ag.Size=UDim2.new(1,-10,0,50)ag.ZIndex=8 ag.Parent=aa local ah=
Instance.new'Frame'ah.Name='PurchasingFrame'ah.Size=UDim2.new(1,0,1,0)ah.
BackgroundColor3=Color3.new(0,0,0)ah.BackgroundTransparency=0.2 ah.
BorderSizePixel=0 ah.ZIndex=9 ah.Visible=false ah.Active=true ah.Parent=p local
ai=createTextObject('PurchasingLabel','Purchasing...','TextLabel',Enum.FontSize.
Size48)ai.Size=UDim2.new(1,0,1,0)ai.ZIndex=10 ai.Parent=ah createSpinner(UDim2.
new(0,50,0,50),UDim2.new(0.5,-25,0.5,30),ai)end function showPurchasing()
startSpinner()p.PurchasingFrame.Visible=true end function hidePurchasing()p.
PurchasingFrame.Visible=false stopSpinner()end function createTextObject(aa,ab,
ac,ad)local ae=Instance.new(ac)ae.Font=Enum.Font.ArialBold ae.TextColor3=Color3.
new(0.8509803921568627,0.8509803921568627,0.8509803921568627)ae.TextWrapped=true
ae.Name=aa ae.Text=ab ae.BackgroundTransparency=1 ae.BorderSizePixel=0 ae.
FontSize=ad return ae end function createImageButton(aa)local ab=Instance.new
'ImageButton'ab.Size=UDim2.new(0,153,0,46)ab.Name=aa return ab end function
setHeaderText(aa)p.TitleLabel.Text=aa p.TitleBackdrop.Text=aa end function
cutSizeInHalfRecursive(aa)end function doubleSizeRecursive(aa)end function
modifyForSmallScreen()cutSizeInHalfRecursive(p)end function modifyForLargeScreen
()doubleSizeRecursive(p)end function changeGuiToScreenSize(aa)if aa then
modifyForSmallScreen()else modifyForLargeScreen()end end function
doPurchasePrompt(aa,ab,ac,ad,ae)if not p then createPurchasePromptGui()end if aa
==game.Players.LocalPlayer then if o then return end o=true d=ab h=ae e=ad g=ac
l=(h~=nil)showPurchasePrompt()end end function userPurchaseProductActionsEnded(
aa)j=false if aa then closePurchasePrompt()if i then local ab=false if tostring(
i['isValid']):lower()=='true'then ab=true end Game:GetService
'MarketplaceService':SignalPromptProductPurchaseFinished(tonumber(i['playerId'])
,tonumber(i['productId']),ab)else print
'Something went wrong, no currentServerResponseTable'end
removeCurrentPurchaseInfo()else local ab=string.gsub(Q,'itemName',tostring(c[
'Name']))p.BodyFrame.ItemPreview.ItemDescription.Text=ab setButtonsVisible(p.
BodyFrame.OkPurchasedButton)hidePurchasing()end end function
doProcessServerPurchaseResponse(aa)if not aa then print
'Server response table was nil, cancelling purchase'purchaseFailed()return end
if aa['playerId']and tonumber(aa['playerId'])==game.Players.LocalPlayer.userId
then i=aa userPurchaseProductActionsEnded(false)end end preloadAssets()game:
GetService'MarketplaceService'.PromptProductPurchaseRequested:connect(function(
aa,ab,ac,ad)doPurchasePrompt(aa,nil,ac,ad,ab)end)Game:GetService
'MarketplaceService'.PromptPurchaseRequested:connect(function(aa,ab,ac,ad)
doPurchasePrompt(aa,ab,ac,ad,nil)end)Game:GetService'MarketplaceService'.
ServerPurchaseVerification:connect(function(aa)doProcessServerPurchaseResponse(
aa)end)if m then Game:GetService'GuiService'.BrowserWindowClosed:connect(
function()doPlayerFundsCheck(false)end)end Game.CoreGui.RobloxGui.Changed:
connect(function()local aa=(game.CoreGui.RobloxGui.AbsoluteSize.Y<=w)if aa and
not t then changeGuiToScreenSize(true)elseif not aa and t then
changeGuiToScreenSize(false)end t=aa end)t=(game.CoreGui.RobloxGui.AbsoluteSize.
Y<=w)if t then changeGuiToScreenSize(true)end