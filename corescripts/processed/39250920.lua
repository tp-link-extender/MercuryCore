print'[Mercury]: Loaded corescript 39250920'local a a=function(b,c,d)if not(d~=
nil)then d=c c=nil end local e=Instance.new(b)if c then e.Name=c end local f for
g,h in pairs(d)do if type(g)=='string'then if g=='Parent'then f=h else e[g]=h
end elseif type(g)=='number'and type(h)=='userdata'then h.Parent=e end end e.
Parent=f return e end local b b=function(c,d)while not c[d]do c.Changed:wait()
end end local c c=function(d,e)while not d:FindFirstChild(e)do d.ChildAdded:
wait()end end local d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x=nil,{},nil,{},nil,
nil,nil,'You are too far away to chat!',300,'Chat ended because you walked away'
,350,"Chat ended because you didn't reply",350,nil,nil,nil,nil,nil,{},{},nil c(
game,'CoreGui')c(game.CoreGui,'RobloxGui')if game.CoreGui.RobloxGui:
FindFirstChild'ControlFrame'then x=game.CoreGui.RobloxGui.ControlFrame else x=
game.CoreGui.RobloxGui end local y y=function()if h then return h.Tone else
return Enum.DialogTone.Neutral end end local z z=function()r=a('BillboardGui',
'ChatNotificationGui',{ExtentsOffset=Vector3.new(0,1,0),Size=UDim2.new(4,0,
5.42857122,0),SizeOffset=Vector2.new(0,0),StudsOffset=Vector3.new(0.4,4.3,0),
Enabled=true,RobloxLocked=true,Active=true,a('ImageLabel','Image',{Active=false,
BackgroundTransparency=1,Position=UDim2.new(0,0,0,0),Size=UDim2.new(1,0,1,0),
Image='',RobloxLocked=true,a('ImageButton','Button',{AutoButtonColor=false,
Position=UDim2.new(0.088,0,0.053,0),Size=UDim2.new(0.83,0,0.46,0),Image='',
BackgroundTransparency=1,RobloxLocked=true})})})end local A A=function(B)if B==
Enum.DialogTone.Neutral then return Enum.ChatColor.Blue elseif B==Enum.
DialogTone.Friendly then return Enum.ChatColor.Green elseif B==Enum.DialogTone.
Enemy then return Enum.ChatColor.Red end end local B B=function(C,D)if D==Enum.
DialogTone.Neutral then C.BackgroundColor3=Color3.new(0,0,0.7019607843137254)C.
Number.TextColor3=Color3.new(0.17647058823529413,0.5568627450980392,
0.9607843137254902)elseif D==Enum.DialogTone.Friendly then C.BackgroundColor3=
Color3.new(0,0.30196078431372547,0)C.Number.TextColor3=Color3.new(0,
0.7450980392156863,0)elseif D==Enum.DialogTone.Enemy then C.BackgroundColor3=
Color3.new(0.5490196078431373,0,0)C.Number.TextColor3=Color3.new(1,
0.34509803921568627,0.30980392156862746)end end local C C=function(D)for E,F in
pairs(e)do B(F,D)end return B(f,D)end local D D=function(E)if E==Enum.DialogTone
.Neutral then d.Style=Enum.FrameStyle.ChatBlue d.Tail.Image=
'rbxasset://textures/chatBubble_botBlue_tailRight.png'elseif E==Enum.DialogTone.
Friendly then d.Style=Enum.FrameStyle.ChatGreen d.Tail.Image=
'rbxasset://textures/chatBubble_botGreen_tailRight.png'elseif E==Enum.DialogTone
.Enemy then d.Style=Enum.FrameStyle.ChatRed d.Tail.Image=
'rbxasset://textures/chatBubble_botRed_tailRight.png'end return C(E)end local E
E=function(F,G,H)if H==Enum.DialogTone.Neutral then F.Image.Image=
'rbxasset://textures/chatBubble_botBlue_notify_bkg.png'elseif H==Enum.DialogTone
.Friendly then F.Image.Image=
'rbxasset://textures/chatBubble_botGreen_notify_bkg.png'elseif H==Enum.
DialogTone.Enemy then F.Image.Image=
'rbxasset://textures/chatBubble_botRed_notify_bkg.png'end if G==Enum.
DialogPurpose.Quest then F.Image.Button.Image=
'rbxasset://textures/chatBubble_bot_notify_bang.png'elseif G==Enum.DialogPurpose
.Help then F.Image.Button.Image=
'rbxasset://textures/chatBubble_bot_notify_question.png'elseif G==Enum.
DialogPurpose.Shop then F.Image.Button.Image=
'rbxasset://textures/chatBubble_bot_notify_money.png'end end local F F=function(
)s=a('Frame','DialogScriptMessage',{Style=Enum.FrameStyle.RobloxRound,Visible=
false,a('TextLabel','Text',{Position=UDim2.new(0,0,0,-1),Size=UDim2.new(1,0,1,0)
,FontSize=Enum.FontSize.Size14,BackgroundTransparency=1,TextColor3=Color3.new(1,
1,1),RobloxLocked=true})})end local G G=function(H,I)s.Text.Text=H s.Size=UDim2.
new(0,I,0,40)s.Position=UDim2.new(0.5,-I/2,0.5,-40)s.Visible=true wait(2)s.
Visible=false return s end local H H=function(I)local J=math.min(string.len(I),
100)return wait(0.75+(J/75)*1.5)end local I I=function(J,K)if K==Enum.DialogTone
.Neutral then J.BackgroundColor3=Color3.new(7.8431372549019605E-3,
0.4235294117647059,1)J.Number.TextColor3=Color3.new(1,1,1)elseif K==Enum.
DialogTone.Friendly then J.BackgroundColor3=Color3.new(0,0.5019607843137255,0)J.
Number.TextColor3=Color3.new(1,1,1)elseif K==Enum.DialogTone.Enemy then J.
BackgroundColor3=Color3.new(0.8,0,0)J.Number.TextColor3=Color3.new(1,1,1)end end
local J J=function()if j then j:Remove()j=nil end local K=h h=nil if K and K.
InUse then do local L=u:Clone()L.archivable=false L.Disabled=false L.Parent=K
end end for L,M in pairs(v)do if L and M then M.Enabled=not L.InUse end end i=
nil end local L L=function()print'Wander'd.Visible=false J()return G(m,n)end
local M M=function()print'Timeout'd.Visible=false J()return G(o,p)end local N N=
function()print'Done'return J()end local O O=function(P)if string.len(P)==0 then
return'...'else return P end end local P P=function(Q)if j then j:Remove()j=nil
end j=t:Clone()j.archivable=false j.Disabled=false j.Parent=Q return j end local
Q Q=function(R,S)if not h then return end i=R local T={}for U,V in pairs(S)do if
V:IsA'DialogChoice'then table.insert(T,V)end end table.sort(T,function(W,X)
return W.Name<X.Name end)if#T==0 then N()return end local W,X=1,0 g={}for Y,Z in
pairs(e)do Z.Visible=false end for _,aa in pairs(T)do if W<=#e then e[W].Size=
UDim2.new(1,0,0,72)e[W].UserPrompt.Text=aa.UserDialog local ab=math.ceil(e[W].
UserPrompt.TextBounds.Y/24)*24 e[W].Position=UDim2.new(0,0,0,X)e[W].Size=UDim2.
new(1,0,0,ab)e[W].Visible=true g[e[W]]=aa X=X+ab W=W+1 end end f.Position=UDim2.
new(0,0,0,X)f.Number.Text=W..')'d.Size=UDim2.new(0,350,0,X+24+32)d.Position=
UDim2.new(0,20,0,-d.Size.Y.Offset-20)D(y())d.Visible=true end local aa aa=
function(ab)P(h)d.Visible=false if ab==f then game.Chat:Chat(game.Players.
LocalPlayer.Character,'Goodbye!',A(y()))return N()else local R=g[ab]game.Chat:
Chat(game.Players.LocalPlayer.Character,O(R.UserDialog),A(y()))wait(1)h:
SignalDialogChoiceSelected(q,R)game.Chat:Chat(i,O(R.ResponseDialog),A(y()))H(R.
ResponseDialog)return Q(i,R:GetChildren())end end local ab ab=function(R)local S
=a('TextButton',{BackgroundColor3=Color3.new(0,0,0.7019607843137254),
AutoButtonColor=false,BorderSizePixel=0,Text='',RobloxLocked=true,a('TextLabel',
'Number',{TextColor3=Color3.new(0.4980392156862745,0.8313725490196079,1),Text=R,
FontSize=Enum.FontSize.Size14,BackgroundTransparency=1,Position=UDim2.new(0,4,0,
2),Size=UDim2.new(0,20,0,24),TextXAlignment=Enum.TextXAlignment.Left,
TextYAlignment=Enum.TextYAlignment.Top,RobloxLocked=true}),a('TextLabel',
'UserPrompt',{BackgroundTransparency=1,TextColor3=Color3.new(1,1,1),FontSize=
Enum.FontSize.Size14,Position=UDim2.new(0,28,0,2),Size=UDim2.new(1,-32,1,-4),
TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top,
TextWrap=true,RobloxLocked=true})})S.MouseEnter:connect(function()return I(S,y()
)end)S.MouseLeave:connect(function()return B(S,y())end)S.MouseButton1Click:
connect(function()return aa(S)end)return S end local R R=function(S)e[1]=ab'1)'e
[2]=ab'2)'e[3]=ab'3)'e[4]=ab'4)'f=ab'5)'f.UserPrompt.Text='Goodbye!'f.Size=UDim2
.new(1,0,0,28)d=a('Frame','UserDialogArea',{Size=UDim2.new(0,350,0,200),Style=
Enum.FrameStyle.ChatBlue,Visible=false,a('ImageLabel','Tail',{Size=UDim2.new(0,
62,0,53),Position=UDim2.new(1,8,0.25),Image=
'rbxasset://textures/chatBubble_botBlue_tailRight.png',BackgroundTransparency=1,
RobloxLocked=true})})for T,W in pairs(e)do W.RobloxLocked=true W.Parent=d f.
RobloxLocked=true end f.Parent=d d.RobloxLocked=true d.Parent=S end local S S=
function(T)while not Instance.Lock(T,q)do wait()end if T.InUse then Instance.
Unlock(T)return else T.InUse=true Instance.Unlock(T)end h=T game.Chat:Chat(T.
Parent,T.InitialPrompt,A(T.Tone))H(T.InitialPrompt)return Q(T.Parent,T:
GetChildren())end local T T=function()while h do if h.Parent and(q:
DistanceFromCharacter(h.Parent.Position>=h.ConversationDistance))then L()end
wait(1)end end local W W=function(X)if X.Parent and X.Parent:IsA'BasePart'then
if q:DistanceFromCharacter(X.Parent.Position)>=X.ConversationDistance then G(k,l
)return end for _,ac in pairs(v)do if _ and ac then ac.Enabled=false end end P(_
)delay(1,T)return S(_)end end local ac ac=function(X)if v[X]then v[X]:Remove()v[
X]=nil end if w[X]then w[X]:disconnect()w[X]=nil end end local X X=function(_)if
_.Parent then if _.Parent:IsA'BasePart'then local ad=r:clone()ad.Enabled=not _.
InUse ad.Adornee=_.Parent ad.RobloxLocked=true ad.Parent=game.CoreGui ad.Image.
Button.MouseButton1Click:connect(function()return W(_)end)E(ad,_.Purpose,_.Tone)
v[_]=ad w[_]=_.Changed:connect(function(ae)if ae=='Parent'and _.Parent then ac(_
)return X(_)elseif ae=='InUse'then ad.Enabled=not h and not _.InUse if _==h then
return M()end elseif ae=='Tone'or ae=='Purpose'then return E(ad,_.Purpose,_.Tone
)end end)else w[_]=_.Changed:connect(function(ad)if ad=='Parent'and _.Parent
then ac(_)return X(_)end end)end end end local ad ad=function()local ae=game:
GetService'InsertService':LoadAsset(39226062)if type(ae)=='string'then wait(0.1)
ae=game:GetService'InsertService':LoadAsset(39226062)end if type(ae)=='string'
then return end c(ae,'TimeoutScript')t=ae.TimeoutScript c(ae,
'ReenableDialogScript')u=ae.ReenableDialogScript end local ae ae=function()b(
game.Players,'LocalPlayer')q=game.Players.LocalPlayer b(q,'Character')ad()z()F()
s.RobloxLocked=true s.Parent=x c(x,'BottomLeftControl')local _=a('Frame',
'DialogFrame',{Position=UDim2.new(0,0,0,0),Size=UDim2.new(0,0,0,0),
BackgroundTransparency=1,RobloxLocked=true,Parent=x.BottomLeftControl})R(_)game.
CollectionService.ItemAdded:connect(function(af)if af:IsA'Dialog'then return X(
af)end end)game.CollectionService.ItemRemoved:connect(function(af)if af:IsA
'Dialog'then return ac(af)end end)for af,ag in pairs(game.CollectionService:
GetCollection'Dialog')do if ag:IsA'Dialog'then X(ag)end end end return ae()