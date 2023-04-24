print'[Mercury]: Loaded corescript 152908679'local a a=function(b,c,d)if not(d~=
nil)then d=c c=nil end local e=Instance.new(b)if c then e.Name=c end local f for
g,h in pairs(d)do if type(g)=='string'then if g=='Parent'then f=h else e[g]=h
end elseif type(g)=='number'and type(h)=='userdata'then h.Parent=e end end e.
Parent=f return e end local b,c,d,e,f,g,h,i,j,k=Game:GetService
'ContextActionService',Game:GetService'UserInputService'.TouchEnabled,{},{},nil,
nil,'http://www.banland.xyz/asset/?id=97166756',
'http://www.banland.xyz/asset/?id=97166444',{},{UDim2.new(0,123,0,70),UDim2.new(
0,30,0,60),UDim2.new(0,180,0,160),UDim2.new(0,85,0,-25),UDim2.new(0,185,0,-25),
UDim2.new(0,185,0,260),UDim2.new(0,216,0,65)}local l=#k do local m=Game:
GetService'ContentProvider'm:Preload(h)m:Preload(i)end while not Game.Players do
wait()end while not Game.Players.LocalPlayer do wait()end local m m=function()if
not f and c then f=a('ScreenGui','ContextActionGui',{a('Frame',
'ContextButtonFrame',{BackgroundTransparency=1,Size=UDim2.new(0.3,0,0.5,0),
Position=UDim2.new(0.7,0,0.5,0)})})end end local n n=function(o,p,q)if p.
UserInputType==Enum.UserInputType.Touch then o.Image=h return b:CallFunction(q,
Enum.UserInputState.Begin)end end local o o=function(p,q,r)if q.UserInputType==
Enum.UserInputType.Touch then p.Image=h return b:CallFunction(r,Enum.
UserInputState.Change)end end local p p=function(q,r,s)q.Image=i if r.
UserInputType==Enum.UserInputType.Touch and r.UserInputState==Enum.
UserInputState.End then return b:CallFunction(s,Enum.UserInputState.End,r)end
end local q q=function()return Game:GetService'GuiService':GetScreenResolution()
.y<=320 end local r r=function(s,t)local u,v=a('ImageButton',
'ContextActionButton',{BackgroundTransparency=1,Size=UDim2.new((function()if q()
then return 0,90,0,90 else return 0,70,0,70 end end)()),Active=true,Image=i,
Parent=g}),nil Game:GetService'UserInputService'.InputEnded:connect(function(w)j
[w]=nil end)u.InputBegan:connect(function(w)if j[w]then return end if w.
UserInputState==Enum.UserInputState.Begin and not(v~=nil)then v=w return n(u,w,s
)end end)u.InputChanged:connect(function(w)if j[w]or v~=w then return end return
o(u,w,s)end)u.InputEnded:connect(function(w)if j[w]or v~=w then return end v=nil
j[w]=true return p(u,w,s)end)local w=a('ImageLabel','ActionIcon',{Position=UDim2
.new(0.175,0,0.175,0),Size=UDim2.new(0.65,0,0.65,0),BackgroundTransparency=1})if
t['image']and type(t['image'])=='string'then w.Image=t['image']end w.Parent=u
local x=a('TextLabel','ActionTitle',{Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,Font=Enum.Font.SourceSansBold,TextColor3=Color3.new(1,1
,1),TextStrokeTransparency=0,FontSize=Enum.FontSize.Size18,TextWrapped=true,Text
=''})if t['title']and type(t['title'])=='string'then x.Text=t['title']end x.
Parent=u return u end local s s=function(t,u)local v,w=r(t,u),nil for x=1,#e do
if e[x]=='empty'then w=x break end end if not w then w=#e+1 end if w>l then
return end e[w]=v d[t]['button']=v v.Position=k[w]v.Parent=g if f and not(f.
Parent~=nil)then f.Parent=Game.Players.LocalPlayer.PlayerGui end end local t t=
function(u)if not d[u]then return end local v=d[u]['button']if v then v.Parent=
nil for w=1,#e do if e[w]==v then e[w]='empty'break end end v:Destroy()end d[u]=
nil end local u u=function(v,w,x)if d[v]then t(v)end d[v]={x}if w and c then m()
return s(v,x)end end b.BoundActionChanged:connect(function(v,w,x)if d[v]and x
then do local y=d[v]['button']if y then if w=='image'then y.ActionIcon.Image=x[w
]elseif w=='title'then y.ActionTitle.Text=x[w]elseif w=='position'then y.
Position=x[w]end end end end end)b.BoundActionAdded:connect(function(v,w,x)
return u(v,w,x)end)b.BoundActionRemoved:connect(function(v,w)return t(v)end)b.
GetActionButtonEvent:connect(function(v)if d[v]then return b:
FireActionButtonFoundSignal(v,d[v]['button'])end end)local v=b:
GetAllBoundActionInfo()for w,x in pairs(v)do u(w,x['createTouchButton'],x)end