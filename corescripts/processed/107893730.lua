local a a=function(b,c,d)if not(d~=nil)then d=c c=nil end local e=a(b)if c then
e.Name=c end local f for g,h in pairs(d)do if type(g)=='string'then if g==
'Parent'then f=h else e[g]=h end elseif type(g)=='number'and type(h)=='userdata'
then h.Parent=e end end e.Parent=f return e end while not Game do wait(0.1)end
while not game:GetService'MarketplaceService'do wait(0.1)end while not game:
FindFirstChild'CoreGui'do wait(0.1)end while not game.CoreGui:FindFirstChild
'RobloxGui'do wait(0.1)end local b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y
,z=nil,game:GetService'ContentProvider'.BaseUrl:lower(),nil,nil,nil,nil,nil,nil,
nil,false,nil,false,true,nil,false,nil,0.3,UDim2.new(0.5,-330,0.5,-200),UDim2.
new(0.5,-330,1,25),nil,false,nil,450,{},nil z=function(A)return
'http://www.roblox.com/Asset/?id='..tostring(A)end local A=z'42557901'table.
insert(y,A)local B=z'104651457'table.insert(y,B)local C=z'104651515'table.
insert(y,C)local D=z'104651532'table.insert(y,D)local E=z'104651592'table.
insert(y,E)local F=z'104651639'table.insert(y,F)local G=z'104651665'table.
insert(y,G)local H=z'104651707'table.insert(y,H)local I=z'104651733'table.
insert(y,I)local J=z'104651761'table.insert(y,J)local K=z'102481431'table.
insert(y,K)local L=z'102481419'table.insert(y,L)local M,N,O,P,Q,R,S,T,U,V,W=
'Buy','Take','An Error Occurred','in-game purchases are disabled',
'Roblox is performing maintenance','Your purchase of itemName succeeded!',
[[Your purchase of itemName failed because errorReason. Your account has not been charged. Please try again soon.]]
,[[Would you like to buy 'itemName' for currencyType currencyAmount?]],
"Would you like to take the assetType 'itemName' for FREE?",
[[Your balance of Robux or Tix will not be affected by this transaction.]],nil W
=function()local X=string.gsub(c,'http','https')X=string.gsub(X,'www','api')
return X end local X X=function()if not b then b=LoadLibrary'RbxUtility'end
return b end local Y Y=function()for Z=1,#y do game:GetService'ContentProvider':
Preload(y[Z])end end local Z Z=function()e=nil f=nil g=nil h=nil i=nil d=nil j=
nil k=false end local _ _=function()q.PurchasingFrame.Visible=false v=false end
local aa aa=function()return q:TweenPosition(t,Enum.EasingDirection.Out,Enum.
EasingStyle.Quad,r,true,function()game.GuiService:RemoveCenterDialog(q)_()q.
Visible=false p=false end)end local ab ab=function(...)local ac,ad,ae={...},
select('#',...),q.BodyFrame:GetChildren()for af=1,#ae do if ae[af]:IsA
'GuiButton'then ae[af].Visible=false for ag=1,ad do if ae[af]==ac[ag]then ae[af]
.Visible=true break end end end end end local ac ac=function(ad)aa()if m then
game:GetService'MarketplaceService':SignalPromptProductPurchaseFinished(game.
Players.LocalPlayer.userId,i,ad)else game:GetService'MarketplaceService':
SignalPromptPurchaseFinished(game.Players.LocalPlayer,e,ad)end return Z()end
local ad ad=function(ae)k=false if ae then local af=string.gsub(R,'itemName',
tostring(d['Name']))q.BodyFrame.ItemPreview.ItemDescription.Text=af ab(q.
BodyFrame.OkPurchasedButton)return _()else return ac(ae)end end local ae ae=
function()return d and d['IsForSale']==true and d['IsPublicDomain']==true end
local af af=function(ag)q.TitleLabel.Text=ag q.TitleBackdrop.Text=ag end local
ag ag=function(ah)if 1==ah then return'Image'elseif 2==ah then return'T-Shirt'
elseif 3==ah then return'Audio'elseif 4==ah then return'Mesh'elseif 5==ah then
return'Lua'elseif 6==ah then return'HTML'elseif 7==ah then return'Text'elseif 8
==ah then return'Hat'elseif 9==ah then return'Place'elseif 10==ah then return
'Model'elseif 11==ah then return'Shirt'elseif 12==ah then return'Pants'elseif 13
==ah then return'Decal'elseif 16==ah then return'Avatar'elseif 17==ah then
return'Head'elseif 18==ah then return'Face'elseif 19==ah then return'Gear'elseif
21==ah then return'Badge'elseif 22==ah then return'Group Emblem'elseif 24==ah
then return'Animation'elseif 25==ah then return'Arms'elseif 26==ah then return
'Legs'elseif 27==ah then return'Torso'elseif 28==ah then return'Right Arm'elseif
29==ah then return'Left Arm'elseif 30==ah then return'Left Leg'elseif 31==ah
then return'Right Leg'elseif 32==ah then return'Package'elseif 33==ah then
return'YouTube Video'elseif 34==ah then return'Game Pass'elseif 0==ah then
return'Product'else return''end end local ah ah=function(ai)if ai==Enum.
CurrencyType.Tix then return'Tix'else return'R$'end end local ai ai=function(aj)
local ak=''if not i then i=d['ProductId']end if ae()then ak=string.gsub(U,
'itemName',tostring(d['Name']))ak=string.gsub(ak,'assetType',tostring(ag(d[
'AssetTypeId'])))af(N)else ak=string.gsub(T,'itemName',tostring(d['Name']))ak=
string.gsub(ak,'currencyType',tostring(ah(f)))ak=string.gsub(ak,'currencyAmount'
,tostring(g))af(M)end q.BodyFrame.ItemPreview.ItemDescription.Text=ak if m then
q.BodyFrame.ItemPreview.Image=c..'thumbs/asset.ashx?assetid='..tostring(d[
'IconImageAssetId'])..'&x=100&y=100&format=png'else q.BodyFrame.ItemPreview.
Image=c..'thumbs/asset.ashx?assetid='..tostring(e)..'&x=100&y=100&format=png'end
end local aj aj=function(ak,al)if f==Enum.CurrencyType.Default or f==Enum.
CurrencyType.Robux then if(ak~=nil)and ak~=0 then g=ak f=Enum.CurrencyType.Robux
else g=al f=Enum.CurrencyType.Tix end elseif f==Enum.CurrencyType.Tix then if(al
~=nil)and al~=0 then g=al f=Enum.CurrencyType.Tix else g=ak f=Enum.CurrencyType.
Robux end else return false end if not(g~=nil)then return false end return true
end local ak ak=function()local al,am,an am,an=pcall(function()al=game:
HttpGetAsync(tostring(W())..'currency/balance')end)if not am then print(
'Get player balance failed because',an)return nil end if al==''then return nil
end al=X().DecodeJSON(al)return al end local al al=function(am)if Enum.
MembershipType.None==am then return 0 elseif Enum.MembershipType.BuildersClub==
am then return 1 elseif Enum.MembershipType.TurboBuildersClub==am then return 2
elseif Enum.MembershipType.OutrageousBuildersClub==am then return 3 else return-
1 end end local am am=function()k=true return game:GetService'GuiService':
OpenBrowserWindow(tostring(c)..'Upgrades/Robux.aspx')end local an an=function(ao
,ap)if ae()then q.BodyFrame.AfterBalanceButton.Text=V return true,false end
local aq if f==Enum.CurrencyType.Robux then aq='robux'elseif f==Enum.
CurrencyType.Tix then aq='tickets'end if not aq then return false end local ar=
tonumber(ao[aq])if not ar then return false end local as=ar-g if not ap then if
as<0 and aq=='robux'then if not(o~=nil)then o=q.BodyFrame.AfterBalanceButton.
MouseButton1Click:connect(am)end q.BodyFrame.AfterBalanceButton.Text='You need '
..tostring(ah(f))..' '..tostring(-as)..
' more to buy this, click here to purchase more.'return true,true elseif as<0
and aq=='tickets'then q.BodyFrame.AfterBalanceButton.Text='You need '..tostring(
-as)..' '..tostring(ah(f))..' more to buy this item.'return true,true end end if
o then o:disconnect()o=nil end q.BodyFrame.AfterBalanceButton.Text=
'Your balance after this transaction will be '..tostring(ah(f))..' '..tostring(
as)..'.'return true,false end local ao ao=function()local ap,aq,ar,as=false,
false,nil,false if m then local at as=pcall(function()at=Game:HttpGetAsync(
tostring(W())..'marketplace/productDetails?productid='..tostring(i))end)if as
then d=X().DecodeJSON(at)end else as=pcall(function()d=game:GetService
'MarketplaceService':GetProductInfo(e)end)end if not(d~=nil)or not as then ar=
[[In-game sales are temporarily disabled. Please try again later.]]return true,
nil,nil,true,ar end if not m then if not e then print
'current asset id is nil, this should always have a value'return false end if e
<=0 then print[[current asset id is negative, this should always be positive]]
return false end local at,au at,au=pcall(function()ap=game:HttpGetAsync(W()..
'ownership/hasAsset?userId='..tostring(game.Players.LocalPlayer.userId)..
'&assetId='..tostring(e))end)if not at then print(
'could not tell if player owns asset because',au)return false end if ap==true or
ap=='true'then ar='You already own this item.'return true,nil,nil,true,ar end
end q.BodyFrame.AfterBalanceButton.Visible=true if type(d)~='table'then d=X().
DecodeJSON(d)end if not d then ar=
'Could not get product info. Please try again later.'return true,nil,nil,true,ar
end if d['IsForSale']==false and d['IsPublicDomain']==false then ar=
'This item is no longer for sale.'return true,nil,nil,true,ar end if not aj(
tonumber(d['PriceInRobux']),tonumber(d['PriceInTickets']))then ar=
[[We could retrieve the price of the item correctly. Please try again later.]]
return true,nil,nil,true,ar end local at=ak()if not at then ar=
'Could not retrieve your balance. Please try again later.'return true,nil,nil,
true,ar end if tonumber(d['MinimumMembershipLevel'])>al(game.Players.LocalPlayer
.MembershipType)then aq=true end local au,av au,av=an(at,aq)if aq then q.
BodyFrame.AfterBalanceButton.Active=true return true,av,aq,false end if d[
'ContentRatingTypeId']==1 then if game.Players.LocalPlayer:GetUnder13()then ar=
[[Your account is under 13 so purchase of this item is not allowed.]]return true
,nil,nil,true,ar end end if(d['IsLimited']==true or d['IsLimitedUnique']==true)
and(d['Remaining']==''or d['Remaining']==0 or not(d['Remaining']~=nil))then ar=
[[All copies of this item have been sold out! Try buying from other users on the website.]]
return true,nil,nil,true,ar end if not au then ar=
[[Could not update your balance. Please check back after some time.]]return true
,nil,nil,true,ar end q.BodyFrame.AfterBalanceButton.Active=true return true,av
end local ap ap=function(aq)if k then local ar,as ar,as=ao()if ar and as then
local at=1000 while(at>0 or aq)and as and k and ar do wait(0.1)ar,as=ao()at=at-1
end end if ar and not as then return ab(q.BodyFrame.BuyButton,q.BodyFrame.
CancelButton,q.BodyFrame.AfterBalanceButton)end end end local aq aq=function()
return Game:GetService'GuiService':OpenBrowserWindow(tostring(c)..
'Upgrades/BuildersClubMemberships.aspx')end local ar ar=function()return ad(
false)end local as as=function()local at,au,av,aw,ax at,au,av,aw,ax=ao()if at
then ai()if aw and ax then q.BodyFrame.ItemPreview.ItemDescription.Text=ax q.
BodyFrame.AfterBalanceButton.Visible=false end game.GuiService:AddCenterDialog(q
,Enum.CenterDialogType.ModalDialog,function()q.Visible=true if ae()then ab(q.
BodyFrame.FreeButton,q.BodyFrame.CancelButton,q.BodyFrame.AfterBalanceButton)
elseif av then q.BodyFrame.AfterBalanceButton.Text=
[[You require an upgrade to your Builders Club membership to purchase this item. Click here to upgrade.]]
if not l then l=q.BodyFrame.AfterBalanceButton.MouseButton1Click:connect(
function()if q.BodyFrame.AfterBalanceButton.Text==
[[You require an upgrade to your Builders Club membership to purchase this item. Click here to upgrade.]]
then return aq()end end)end ab(q.BodyFrame.BuyDisabledButton,q.BodyFrame.
CancelButton,q.BodyFrame.AfterBalanceButton)elseif au then ab(q.BodyFrame.
BuyDisabledButton,q.BodyFrame.CancelButton,q.BodyFrame.AfterBalanceButton)elseif
aw then ab(q.BodyFrame.BuyDisabledButton,q.BodyFrame.CancelButton)else ab(q.
BodyFrame.BuyButton,q.BodyFrame.CancelButton)end q:TweenPosition(s,Enum.
EasingDirection.Out,Enum.EasingStyle.Quad,r,true)if at and au and not n then k=
true return ap(true)end end,function()q.Visible=false end)return q else return
ar()end end local at at=function(au)local av=game:GetService'InsertService':
LoadAsset(au)if not av then return nil end if av:IsA'Tool'then return av end
local aw=av:GetChildren()for ax=1,#aw do if aw[ax]:IsA'Tool'then return aw[ax]
end end return nil end local au au=function(av)local aw='Item'if d then aw=d[
'Name']end local ax=string.gsub(S,'itemName',tostring(aw))if av then ax=string.
gsub(ax,'errorReason',tostring(P))else ax=string.gsub(ax,'errorReason',tostring(
Q))end q.BodyFrame.ItemPreview.ItemDescription.Text=ax q.BodyFrame.ItemPreview.
Image=A ab(q.BodyFrame.OkButton)af(O)return _()end local av av=function()v=true
return Spawn(function()local aw=0 while v do local ax=0 while ax<8 do w[ax+1].
Image='http://www.roblox.com/Asset/?id='..(function()if ax==aw or ax==(aw+1)%8
then return'45880668'else return'45880710'end end)()ax=ax+1 end aw=(aw+1)%8
wait(6.666666666666666E-2)end end)end local aw aw=function()av()q.
PurchasingFrame.Visible=true end local ax ax=function(ay)if ay==Enum.
CurrencyType.Robux or ay==Enum.CurrencyType.Default then return 1 elseif ay==
Enum.CurrencyType.Tix then return 2 end end local ay ay=function(az)aw()local aA
,aB,aC=tick(),'none',nil if m then aC=W()..
'marketplace/submitpurchase?productId='..tostring(i)..'&currencyTypeId='..
tostring(ax(f))..'&expectedUnitPrice='..tostring(g)..'&placeId='..tostring(Game.
PlaceId)else aC=W()..'marketplace/purchase?productId='..tostring(i)..
'&currencyTypeId='..tostring(ax(f))..'&purchasePrice='..tostring(g)..
'&locationType=Game'..'&locationId='..tostring(Game.PlaceId)end local aD,aE aD,
aE=pcall(function()aB=game:HttpPostAsync(aC,'RobloxPurchaseRequest')end)print(
'doAcceptPurchase success from ypcall is ',aD,'reason is',aE)if(tick()-aA)<1
then wait(1)end if aB=='none'or not(aB~=nil)or aB==''then print(
'did not get a proper response from web on purchase of',e,i)au()return end aB=X(
).DecodeJSON(aB)if aB then if aB['success']==false then if aB['status']~=
'AlreadyOwned'then print('web return response of fail on purchase of',e,i)au(aB[
'status']=='EconomyDisabled')return end end else print(
'web return response of non parsable JSON on purchase of',e)au()return end if h
and aD and e and tonumber(d['AssetTypeId'])==19 then local aF=at(tonumber(e))if
aF then aF.Parent=game.Players.LocalPlayer.Backpack end end if m then if not aB[
'receipt']then print(
[[tried to buy productId, but no receipt returned. productId was]],i)au()return
end return Game:GetService'MarketplaceService':SignalClientPurchaseSuccess(
tostring(aB['receipt']),game.Players.LocalPlayer.userId,i)else return ad(aD)end
end local az az=function(aA,aB,aC)local aD=a('Frame','Spinner',{Size=aA,Position
=aB,BackgroundTransparency=1,ZIndex=10,Parent=aC})w={}local aE=1 while aE<=8 do
local aF=a('ImageLabel','Spinner'..tostring(aE),{Size=UDim2.new(0,16,0,16),
Position=UDim2.new(0.5+0.3*math.cos(math.rad(45*aE)),-8,0.5+0.3*math.sin(math.
rad(45*aE)),-8),BackgroundTransparency=1,ZIndex=10,Image=
'http://www.roblox.com/Asset/?id=45880710',Parent=aD})w[aE]=aF aE=aE+1 end end
local aA aA=function(aB,aC,aD,aE)return a(aD,aB,{Font=Enum.Font.ArialBold,
TextColor3=Color3.new(0.8509803921568627,0.8509803921568627,0.8509803921568627),
TextWrapped=true,Text=aC,BackgroundTransparency=1,BorderSizePixel=0,FontSize=aE}
)end local aB aB=function(aC)return a('ImageButton',aC,{Size=UDim2.new(0,153,0,
46),Name=aC})end local aC aC=function(aD)k=false if aD then aa()if j then local
aE=false if(tostring(j['isValid'])):lower()=='true'then aE=true end Game:
GetService'MarketplaceService':SignalPromptProductPurchaseFinished(tonumber(j[
'playerId']),tonumber(j['productId']),aE)else print
'Something went wrong, no currentServerResponseTable'end return Z()else local aE
=string.gsub(R,'itemName',tostring(d['Name']))q.BodyFrame.ItemPreview.
ItemDescription.Text=aE ab(q.BodyFrame.OkPurchasedButton)return _()end end local
aD aD=function()q=a('Frame','PurchaseFrame',{Size=UDim2.new(0,660,0,400),
Position=t,Visible=false,BackgroundColor3=Color3.new(0.5529411764705883,
0.5529411764705883,0.5529411764705883),BorderColor3=Color3.new(0.8,0.8,0.8),
Parent=game.CoreGui.RobloxGui,a('Frame','BodyFrame',{Size=UDim2.new(1,0,1,-60),
Position=UDim2.new(0,0,0,60),BackgroundColor3=Color3.new(0.2627450980392157,
0.2627450980392157,0.2627450980392157),BorderSizePixel=0,ZIndex=8})})local aE=q.
BodyFrame do local aF=aA('TitleLabel','Buy Item','TextLabel',Enum.FontSize.
Size48)aF.ZIndex=8 aF.Size=UDim2.new(1,0,0,60)do local aG=aF:Clone()aG.Name=
'TitleBackdrop'aG.TextColor3=Color3.new(0.12549019607843137,0.12549019607843137,
0.12549019607843137)aG.BackgroundTransparency=0 aG.BackgroundColor3=Color3.new(
0.21176470588235294,0.3764705882352941,0.6705882352941176)aG.Position=UDim2.new(
0,0,0,-2)aG.ZIndex=8 aG.Parent=q end aF.Parent=q end local aF=90 do local aG=aB
'CancelButton'aG.Position=UDim2.new(0.5,aF/2,1,-120)aG.BackgroundTransparency=1
aG.BorderSizePixel=0 aG.Parent=aE aG.Modal=true aG.ZIndex=8 aG.Image=E aG.
MouseButton1Down:connect(function()aG.Image=F end)aG.MouseButton1Up:connect(
function()aG.Image=E end)aG.MouseLeave:connect(function()aG.Image=E end)aG.
MouseButton1Click:connect(ar)end local aG=aB'BuyButton'aG.Position=UDim2.new(0.5
,-153-(aF/2),1,-120)aG.BackgroundTransparency=1 aG.BorderSizePixel=0 aG.Image=B
aG.ZIndex=8 aG.MouseButton1Down:connect(function()aG.Image=C end)aG.
MouseButton1Up:connect(function()aG.Image=B end)aG.MouseLeave:connect(function()
aG.Image=B end)aG.Parent=aE do local aH=aG:Clone()aH.Name='BuyDisabledButton'aH.
AutoButtonColor=false aH.Visible=false aH.Active=false aH.Image=D aH.ZIndex=8 aH
.Parent=aE end local aH=aG:Clone()aH.BackgroundTransparency=1 aH.Name=
'FreeButton'aH.Visible=false aH.ZIndex=8 aH.Image=I aH.MouseButton1Down:connect(
function()aH.Image=J end)aH.MouseButton1Up:connect(function()aH.Image=I end)aH.
MouseLeave:connect(function()aH.Image=I end)aH.Parent=aE local aI=aG:Clone()aI.
Name='OkButton'aI.BackgroundTransparency=1 aI.Visible=false aI.Position=UDim2.
new(0.5,-aI.Size.X.Offset/2,1,-120)aI.Modal=true aI.Image=G aI.ZIndex=8 aI.
MouseButton1Down:connect(function()aI.Image=H end)aI.MouseButton1Up:connect(
function()aI.Image=G end)aI.MouseLeave:connect(function()aI.Image=G end)aI.
Parent=aE do local aJ=aI:Clone()aJ.ZIndex=8 aJ.Name='OkPurchasedButton'aJ.
MouseButton1Down:connect(function()aJ.Image=H end)aJ.MouseButton1Up:connect(
function()aJ.Image=G end)aJ.MouseLeave:connect(function()aJ.Image=G end)aJ.
Parent=aE aJ.MouseButton1Click:connect(function()if m then return aC(true)else
return ac(true)end end)end aI.MouseButton1Click:connect(function()return ad(
false)end)aG.MouseButton1Click:connect(function()return ay(Enum.CurrencyType.
Robux)end)aH.MouseButton1Click:connect(function()return ay(false)end)local aJ=a(
'ImageLabel','ItemPreview',{BackgroundColor3=Color3.new(0.12549019607843137,
0.12549019607843137,0.12549019607843137),BorderColor3=Color3.new(
0.5529411764705883,0.5529411764705883,0.5529411764705883),Position=UDim2.new(0,
30,0,20),Size=UDim2.new(0,180,0,180),ZIndex=9,Parent=aE})do local aK=aA(
'ItemDescription',
[[Would you like to buy the 'itemName' for currencyType currencyAmount?]],
'TextLabel',Enum.FontSize.Size24)aK.Position=UDim2.new(1,20,0,0)aK.Size=UDim2.
new(0,410,1,0)aK.ZIndex=8 aK.Parent=aJ end do local aK=aA('AfterBalanceButton',
'Place holder text ip sum lorem dodo ashs','TextButton',Enum.FontSize.Size24)aK.
AutoButtonColor=false aK.TextColor3=Color3.new(0.8705882352941177,
0.23137254901960785,0.11764705882352941)aK.Position=UDim2.new(0,5,1,-55)aK.Size=
UDim2.new(1,-10,0,50)aK.ZIndex=8 aK.Parent=aE end local aK,aL=a('Frame',
'PurchasingFrame',{Size=UDim2.new(1,0,1,0),BackgroundColor3=Color3.new(0,0,0),
BackgroundTransparency=0.2,BorderSizePixel=0,ZIndex=9,Visible=false,Active=true,
Parent=q}),aA('PurchasingLabel','Purchasing...','TextLabel',Enum.FontSize.Size48
)aL.Size=UDim2.new(1,0,1,0)aL.ZIndex=10 aL.Parent=aK return az(UDim2.new(0,50,0,
50),UDim2.new(0.5,-25,0.5,30),aL)end local aE aE=function(aF)end local aF aF=
function(aG)end local aG aG=function(aH)if aH then return aE(q)else return aF(q)
end end local aH aH=function(aI,aJ,aK,aL,aM)if not q then aD()end if aI==game.
Players.LocalPlayer then if p then return end p=true e=aJ i=aM f=aL h=aK m=(i~=
nil)return as()end end local aI aI=function(aJ)if not aJ then print
'Server response table was nil, cancelling purchase'au()return end if aJ[
'playerId']and tonumber(aJ['playerId'])==game.Players.LocalPlayer.userId then j=
aJ return aC(false)end end Y()game:GetService'MarketplaceService'.
PromptProductPurchaseRequested:connect(function(aJ,aK,aL,aM)return aH(aJ,nil,aL,
aM,aK)end)Game:GetService'MarketplaceService'.PromptPurchaseRequested:connect(
function(aJ,aK,aL,aM)return aH(aJ,aK,aL,aM,nil)end)Game:GetService
'MarketplaceService'.ServerPurchaseVerification:connect(function(aJ)return aI(aJ
)end)if n then Game:GetService'GuiService'.BrowserWindowClosed:connect(function(
)return ap(false)end)end Game.CoreGui.RobloxGui.Changed:connect(function()local
aJ=game.CoreGui.RobloxGui.AbsoluteSize.Y<=x if aJ and not u then aG(true)elseif
not aJ and u then aG(false)end u=aJ end)u=game.CoreGui.RobloxGui.AbsoluteSize.Y
<=x if u then return aG(true)end