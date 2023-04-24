print'[Mercury]: Loaded corescript 97188756'local a,b=false,nil b=function(c,d)
while not(c:FindFirstChild(d)~=nil)do c.ChildAdded:wait(0.03)end return c[d]end
local c c=function()local d=Game:GetService'CoreGui'local e=b(d,'RobloxGui')if e
.AbsoluteSize.Y<600 then return true end return false end local d d=function(e)
return e:gsub('^%s*(.-)%s*$','%1')end while not(Game.Players.LocalPlayer~=nil)do
wait(0.03)end local e=Game.Players.LocalPlayer while not(e.Character~=nil)do
wait(0.03)end local f,g=Game.Workspace.CurrentCamera,nil g=function(h,i,j)if not
(j~=nil)then j=i i=nil end local k=Instance.new(h)if i then k.Name=i end local l
for m,n in pairs(j)do if type(m)=='string'then if m=='Parent'then l=n else k[m]=
n end elseif type(m)=='number'and type(n)=='userdata'then n.Parent=k end end k.
Parent=l return k end local h,i,j,k,l,m=Game:GetService'CoreGui',Game:GetService
'Players',Game:GetService'GuiService',{},{},nil m=function(n)return function(o)
local p={[l]=n}for q,r in pairs(o)do local s=setmetatable({Name=r,Value=q,Enum=p
,[l]=n},{__call=function(s,t)return t==s or t==s.Name or t==s.Value end,
__tostring=function(s)return'Enum.'..tostring(s[l])..'.'..tostring(s.Name)end})p
[q]=s p[r]=s p[s]=s end k[n]=p return setmetatable(p,{__call=function(s,t)return
s[t]or s[tonumber(t)]end,__index={GetEnumItems=function(s)o={}for t,u in pairs(s
)do if type(t)=='number'then o[#o+1]=u end end table.sort(o,function(v,w)return
v.Value<w.Value end)return o end},__tostring=function(s)return'Enum.'..tostring(
s[l])end})end end local n,o,p={Mouse=e:GetMouse(),Speed=0,Simulating=false,
Configuration={DefaultSpeed=1},UserIsScrolling=false},{ChatColors={BrickColor.
new'Bright red',BrickColor.new'Bright blue',BrickColor.new'Earth green',
BrickColor.new'Bright violet',BrickColor.new'Bright orange',BrickColor.new
'Bright yellow',BrickColor.new'Light reddish violet',BrickColor.new
'Brick yellow'},Gui=nil,Frame=nil,RenderFrame=nil,TapToChatLabel=nil,
ClickToChatButton=nil,ScrollingLock=false,EventListener=nil,MessageQueue={},
Configuration={FontSize=Enum.FontSize.Size12,NumFontSize=12,HistoryLength=20,
Size=UDim2.new(0.38,0,0.2,0),MessageColor=Color3.new(1,1,1),AdminMessageColor=
Color3.new(1,0.8431372549019608,0),XScale=0.025,LifeTime=45,Position=UDim2.new(0
,2,0.05,0),DefaultTweenSpeed=0.15},SlotPositions_List={},CachedSpaceStrings_List
={},MouseOnFrame=false,GotFocus=false,Messages_List={},MessageThread=nil,
Admins_List={'taskmanager','Heliodex','tako'},SafeChat_List={[
'Use the Chat menu to talk to me.']={'/sc0',true},['I can only see menu chats.']
={'/sc1',true},Hello={Hi={'/sc2_0',true,['Hi there!']=true,['Hi everyone']=true}
,Howdy={'/sc2_1',true,['Howdy partner!']=true},Greetings={'/sc2_2',true,[
'Greetings everyone']=true,['Greetings Robloxians!']=true,['Seasons greetings!']
=true},Welcome={'/sc2_3',true,['Welcome to my place']=true,[
'Welcome to my barbeque']=true,['Welcome to our base']=true},['Hey there!']={
'/sc2_4',true},["What's up?"]={'/sc2_5',true,['How are you doing?']=true,[
"How's it going?"]=true,["What's new?"]=true},['Good day']={'/sc2_6',true,[
'Good morning']=true,['Good evening']=true,['Good afternoon']=true,['Good night'
]=true},Silly={'/sc2_7',true,['Waaaaaaaz up?!']=true,['Hullo!']=true,[
'Behold greatness, mortals!']=true,['Pardon me, is this Sparta?']=true,[
'THIS IS SPARTAAAA!']=true},['Happy Holidays!']={'/sc2_8',true,[
'Happy New Year!']=true,["Happy Valentine's Day!"]=true,[
'Beware the Ides of March!']=true,["Happy St. Patrick's Day!"]=true,[
'Happy Easter!']=true,['Happy Earth Day!']=true,['Happy 4th of July!']=true,[
'Happy Thanksgiving!']=true,['Happy Halloween!']=true,['Happy Hanukkah!']=true,[
'Merry Christmas!']=true,['Happy May Day!']=true,['Happy Towel Day!']=true,[
'Happy Mercury Day!']=true,['Happy LOL Day!']=true},'/sc2'},Goodbye={[
'Good Night']={'/sc3_0',true,['Sweet dreams']=true,['Go to sleep!']=true,[
'Lights out!']=true,Bedtime=true,['Going to bed now']=true},Later={'/sc3_1',true
,['See ya later']=true,['Later gator!']=true,['See you tomorrow']=true},Bye={
'/sc3_2',true,['Hasta la bye bye!']=true},["I'll be right back"]={'/sc3_3',true}
,['I have to go']={'/sc3_4',true},Farewell={'/sc3_5',true,['Take care']=true,[
'Have a nice day']=true,['Goodluck!']=true,['Ta-ta for now!']=true},Peace={
'/sc3_6',true,['Peace out!']=true,['Peace dudes!']=true,['Rest in pieces!']=true
},Silly={'/sc3_7',true,['To the batcave!']=true,['Over and out!']=true,[
'Happy trails!']=true,["I've got to book it!"]=true,['Tootles!']=true,[
'Smell you later!']=true,['GG!']=true,['My house is on fire! gtg.']=true},'/sc3'
},Friend={['Wanna be friends?']={'/sc4_0',true},['Follow me']={'/sc4_1',true,[
'Come to my place!']=true,['Come to my base!']=true,['Follow me, team!']=true,[
'Follow me']=true},['Your place is cool']={'/sc4_2',true,['Your place is fun']=
true,['Your place is awesome']=true,['Your place looks good']=true,[
'This place is awesome!']=true},['Thank you']={'/sc4_3',true,[
'Thanks for playing']=true,['Thanks for visiting']=true,['Thanks for everything'
]=true,['No, thank you']=true,Thanx=true},['No problem']={'/sc4_4',true,[
"Don't worry"]=true,["That's ok"]=true,np=true},['You are ...']={'/sc4_5',true,[
'You are great!']=true,['You are good!']=true,['You are cool!']=true,[
'You are funny!']=true,['You are silly!']=true,['You are awesome!']=true,[
"You are doing something I don't like, please stop"]=true},['I like ...']={
'/sc4_6',true,['I like your name']=true,['I like your shirt']=true,[
'I like your place']=true,['I like your style']=true,['I like you']=true,[
'I like items']=true,['I like money']=true},Sorry={'/sc4_7',true,['My bad!']=
true,["I'm sorry"]=true,['Whoops!']=true,['Please forgive me.']=true,[
'I forgive you.']=true,["I didn't mean to do that."]=true,[
"Sorry, I'll stop now."]=true},'/sc4'},Questions={['Who?']={'/sc5_0',true,[
'Who wants to be my friend?']=true,['Who wants to be on my team?']=true,[
'Who made this brilliant game?']=true},['What?']={'/sc5_1',true,[
'What is your favorite animal?']=true,['What is your favorite game?']=true,[
'What is your favorite movie?']=true,['What is your favorite TV show?']=true,[
'What is your favorite music?']=true,['What are your hobbies?']=true,['LOLWUT?']
=true},['When?']={'/sc5_2',true,['When are you online?']=true,[
'When is the new version coming out?']=true,['When can we play again?']=true,[
'When will your place be done?']=true},['Where?']={'/sc5_3',true,[
'Where do you want to go?']=true,['Where are you going?']=true,['Where am I?!']=
true,['Where did you go?']=true},['How?']={'/sc5_4',true,['How are you today?']=
true,['How did you make this cool place?']=true,['LOLHOW?']=true},['Can I...']={
'/sc5_5',true,['Can I have a tour?']=true,['Can I be on your team?']=true,[
'Can I be your friend?']=true,['Can I try something?']=true,[
'Can I have that please?']=true,['Can I have that back please?']=true,[
'Can I have borrow your hat?']=true,['Can I have borrow your gear?']=true},
'/sc5'},Answers={['You need help?']={'/sc6_0',true,['Check out the news section'
]=true,['Check out the help section']=true,['Read the wiki!']=true,[
'All the answers are in the wiki!']=true,['I will help you with this.']=true},[
'Some people ...']={'/sc6_1',true,Me=true,['Not me']=true,You=true,['All of us']
=true,['Everyone but you']=true,['Builderman!']=true,['Telamon!']=true,[
'My team']=true,['My group']=true,Mom=true,Dad=true,Sister=true,Brother=true,
Cousin=true,Grandparent=true,Friend=true},['Time ...']={'/sc6_2',true,[
'In the morning']=true,['In the afternoon']=true,['At night']=true,Tomorrow=true
,['This week']=true,['This month']=true,Sometime=true,Sometimes=true,[
'Whenever you want']=true,Never=true,['After this']=true,['In 10 minutes']=true,
['In a couple hours']=true,['In a couple days']=true},Animals={'/sc6_3',true,
Cats={Lion=true,Tiger=true,Leopard=true,Cheetah=true},Dogs={Wolves=true,Beagle=
true,Collie=true,Dalmatian=true,Poodle=true,Spaniel=true,Shepherd=true,Terrier=
true,Retriever=true},Horses={Ponies=true,Stallions=true,Pwnyz=true},Reptiles={
Dinosaurs=true,Lizards=true,Snakes=true,['Turtles!']=true},Hamster=true,Monkey=
true,Bears=true,Fish={Goldfish=true,Sharks=true,['Sea Bass']=true,Halibut=true,[
'Tropical Fish']=true},Birds={Eagles=true,Penguins=true,Parakeets=true,Owls=true
,Hawks=true,Pidgeons=true},Elephants=true,['Mythical Beasts']={Dragons=true,
Unicorns=true,['Sea Serpents']=true,Sphinx=true,Cyclops=true,Minotaurs=true,
Goblins=true,['Honest Politicians']=true,Ghosts=true,['Scylla and Charybdis']=
true}},Games={'/sc6_4',true,Action=true,Puzzle=true,Strategy=true,Racing=true,
RPG=true,['Obstacle Course']=true,Tycoon=true,Roblox={BrickBattle=true,[
'Community Building']=true,['Roblox Minigames']=true,['Contest Place']=true},[
'Board games']={Chess=true,Checkers=true,['Settlers of Catan']=true,[
'Tigris and Euphrates']=true,['El Grande']=true,Stratego=true,Carcassonne=true}}
,Sports={'/sc6_5',true,Hockey=true,Soccer=true,Football=true,Baseball=true,
Basketball=true,Volleyball=true,Tennis=true,['Sports team practice']=true,
Watersports={Surfing=true,Swimming=true,['Water Polo']=true},['Winter sports']={
Skiing=true,Snowboarding=true,Sledding=true,Skating=true},Adventure={[
'Rock climbing']=true,Hiking=true,Fishing=true,['Horseback riding']=true},Wacky=
{Foosball=true,Calvinball=true,Croquet=true,Cricket=true,Dodgeball=true,Squash=
true,Trampoline=true}},['Movies/TV']={'/sc6_6',true,['Science Fiction']=true,
Animated={Anime=true},Comedy=true,Romantic=true,Action=true,Fantasy=true},Music=
{'/sc6_7',true,Country=true,Jazz=true,Rap=true,['Hip-hop']=true,Techno=true,
Classical=true,Pop=true,Rock=true},Hobbies={'/sc6_8',true,Computers={[
'Building computers']=true,Videogames=true,Coding=true,Hacking=true},[
'The Internet']={['lol. teh internets!']=true,['Watching vids']=true},Dance=true
,Gymnastics=true,['Listening to music']=true,['Arts and crafts']=true,[
'Martial Arts']={Karate=true,Judo=true,['Taikwon Do']=true,Wushu=true,[
'Street fighting']=true},['Music lessons']={['Playing in my band']=true,[
'Playing piano']=true,['Playing guitar']=true,['Playing violin']=true,[
'Playing drums']=true,['Playing a weird instrument']=true}},Location={'/sc6_9',
true,USA={West={Alaska=true,Arizona=true,California=true,Colorado=true,Hawaii=
true,Idaho=true,Montana=true,Nevada=true,['New Mexico']=true,Oregon=true,Utah=
true,Washington=true,Wyoming=true},South={Alabama=true,Arkansas=true,Florida=
true,Georgia=true,Kentucky=true,Louisiana=true,Mississippi=true,[
'North Carolina']=true,Oklahoma=true,['South Carolina']=true,Tennessee=true,
Texas=true,Virginia=true,['West Virginia']=true},Northeast={Connecticut=true,
Delaware=true,Maine=true,Maryland=true,Massachusetts=true,['New Hampshire']=true
,['New Jersey']=true,['New York']=true,Pennsylvania=true,['Rhode Island']=true,
Vermont=true},Midwest={Illinois=true,Indiana=true,Iowa=true,Kansas=true,Michigan
=true,Minnesota=true,Missouri=true,Nebraska=true,['North Dakota']=true,Ohio=true
,['South Dakota']=true,Wisconsin=true}},Canada={Alberta=true,['British Columbia'
]=true,Manitoba=true,['New Brunswick']=true,Newfoundland=true,[
'Northwest Territories']=true,['Nova Scotia']=true,Nunavut=true,Ontario=true,[
'Prince Edward Island']=true,Quebec=true,Saskatchewan=true,Yukon=true},Mexico=
true,['Central America']=true,Europe={France=true,Germany=true,Spain=true,Italy=
true,Poland=true,Switzerland=true,Greece=true,Romania=true,Netherlands=true,[
'Great Britain']={England=true,Scotland=true,Wales=true,['Northern Ireland']=
true}},Asia={China=true,India=true,Japan=true,Korea=true,Russia=true,Vietnam=
true},['South America']={Argentina=true,Brazil=true},Africa={Eygpt=true,
Swaziland=true},Australia=true,['Middle East']=true,Antarctica=true,[
'New Zealand']=true},Age={'/sc6_10',true,Rugrat=true,Kid=true,Tween=true,Teen=
true,Twenties=true,Old=true,Ancient=true,Mesozoic=true,[
"I don't want to say my age. Don't ask."]=true},Mood={'/sc6_11',true,Good=true,[
'Great!']=true,['Not bad']=true,Sad=true,Hyper=true,Chill=true,Happy=true,[
'Kind of mad']=true},Boy={'/sc6_12',true},Girl={'/sc6_13',true},[
"I don't want to say boy or girl. Don't ask."]={'/sc6_14',true},'/sc6'},Game={[
"Let's build"]={'/sc7_0',true},["Let's battle"]={'/sc7_1',true},['Nice one!']={
'/sc7_2',true},['So far so good']={'/sc7_3',true},['Lucky shot!']={'/sc7_4',true
},['Oh man!']={'/sc7_5',true},['I challenge you to a fight!']={'/sc7_6',true},[
'Help me with this']={'/sc7_7',true},["Let's go to your game"]={'/sc7_8',true},[
'Can you show me how do to that?']={'/sc7_9',true},['Backflip!']={'/sc7_10',true
},['Frontflip!']={'/sc7_11',true},['Dance!']={'/sc7_12',true},[
"I'm on your side!"]={'/sc7_13',true},['Game Commands']={'/sc7_14',true,regen=
true,reset=true,go=true,fix=true,respawn=true},'/sc7'},Silly={['Muahahahaha!']=
true,['all your base are belong to me!']=true,['GET OFF MAH LAWN']=true,[
'TEH EPIK DUCK IS COMING!!!']=true,ROFL=true,['1337']={true,['i r teh pwnz0r!']=
true,['w00t!']=true,['z0mg h4x!']=true,['ub3rR0xXorzage!']=true}},Yes={[
'Absolutely!']=true,['Rock on!']=true,['Totally!']=true,['Juice!']=true,['Yay!']
=true,Yesh=true},No={['Ummm. No.']=true,['...']=true,['Stop!']=true,['Go away!']
=true,["Don't do that"]=true,['Stop breaking the rules']=true,["I don't want to"
]=true},Ok={['Well... ok']=true,Sure=true},Uncertain={Maybe=true,["I don't know"
]=true,idk=true,["I can't decide"]=true,['Hmm...']=true},[':-)']={[':-(']=true,[
':D']=true,[':-O']=true,lol=true,['=D']=true,['D=']=true,XD=true,[';D']=true,[
';)']=true,O_O=true,['=)']=true,['@_@']=true,['&gt;_&lt;']=true,T_T=true,['^_^']
=true,['<(0_0<) <(0_0)> (>0_0)> KIRBY DANCE']=true,[")';"]=true,[':3']=true},
Ratings={['Rate it!']=true,['I give it a 1 out of 10']=true,[
'I give it a 2 out of 10']=true,['I give it a 3 out of 10']=true,[
'I give it a 4 out of 10']=true,['I give it a 5 out of 10']=true,[
'I give it a 6 out of 10']=true,['I give it a 7 out of 10']=true,[
'I give it a 8 out of 10']=true,['I give it a 9 out of 10']=true,[
'I give it a 10 out of 10!']=true}},m'SafeChat'{'Level1','Level2','Level3'},
SafeChatTree={},TempSpaceLabel=nil},nil p=function(q)local r=0 for s=1,#q do
local t,u=string.byte(string.sub(q,s,s)),#q-s+1 if#q%2==1 then u=u-1 end if u%4
>=2 then t=-t end r=r+t end return r%8 end o.ComputeChatColor=function(q,r)
return q.ChatColors[p(r)+1].Color end o.EnableScrolling=function(q,r)q.
MouseOnFrame=false if q.RenderFrame then q.RenderFrame.MouseEnter:connect(
function()local s=e.Character local t,u=b(s,'Torso'),b(s,'Head')if r then q.
MouseOnFrame=true f.CameraType='Scriptable'return Spawn(function()local v=f.
CoordinateFrame.p-t.Position while o.MouseOnFrame do f.CoordinateFrame=CFrame.
new(t.Position+v,u.Position)wait(0.015)end end)end end)return q.RenderFrame.
MouseLeave:connect(function()f.CameraType='Custom'q.MouseOnFrame=false end)end
end o.IsTouchDevice=function(q)local r=false pcall(function()r=Game:GetService
'UserInputService'.TouchEnabled end)return r end o.UpdateQueue=function(q,r,s)
for t=#q.MessageQueue,1,-1 do if q.MessageQueue[t]then for u,v in pairs(q.
MessageQueue[t])do if v and type(v)~='table'and type(v)~='number'then if v:IsA
'TextLabel'or v:IsA'TextButton'then if s then v.Position=v.Position-UDim2.new(0,
0,s,0)else if r==q.MessageQueue[t]then v.Position=UDim2.new(q.Configuration.
XScale,0,v.Position.Y.Scale-r['Message'].Size.Y.Scale,0)Spawn(function()wait(
0.05)while v.TextTransparency>=0 do v.TextTransparency=v.TextTransparency-0.2
wait(0.03)end if v==r['Message']then v.TextStrokeTransparency=0.8 else v.
TextStrokeTransparency=1 end end)else v.Position=UDim2.new(q.Configuration.
XScale,0,v.Position.Y.Scale-r['Message'].Size.Y.Scale,0)end if v.Position.Y.
Scale<-1E-2 then v.Visible=false v:Destroy()end end end end end end end end o.
CreateScrollBar=function(q)end o.CheckIfInBounds=function(q,r)if#o.MessageQueue<
3 then return true end if r>0 and o.MessageQueue[1]and o.MessageQueue[1][
'Player']and o.MessageQueue[1]['Player'].Position.Y.Scale==0 then return true
elseif r<0 and o.MessageQueue[1]and o.MessageQueue[1]['Player']and o.
MessageQueue[1]['Player'].Position.Y.Scale<0 then return true else return false
end end o.ComputeSpaceString=function(q,r)local s=' 'if not q.TempSpaceLabel
then q.TempSpaceLabel=g('TextButton','SpaceButton',{Size=UDim2.new(0,r.
AbsoluteSize.X,0,r.AbsoluteSize.Y),FontSize=q.Configuration.FontSize,Parent=q.
RenderFrame,BackgroundTransparency=1,Text=s})else q.TempSpaceLabel.Text=s end
while q.TempSpaceLabel.TextBounds.X<r.TextBounds.X do s=s..' 'q.TempSpaceLabel.
Text=s end s=s..' 'q.CachedSpaceStrings_List[r.Text]=s q.TempSpaceLabel.Text=''
return s end o.UpdateChat=function(q,r,s)local t={Player=r,Message=s}if
coroutine.status(o.MessageThread)=='dead'then table.insert(o.Messages_List,t)o.
MessageThread=coroutine.create(function()for u=1,#o.Messages_List do local v=o.
Messages_List[u]o:CreateMessage(v['Player'],v['Message'])end o.Messages_List={}
end)return coroutine.resume(o.MessageThread)else return table.insert(o.
Messages_List,t)end end o.CreateMessage=function(q,r,s)local t if not r then t=
''else t=r.Name end s=d(s)local u,v if#q.MessageQueue>q.Configuration.
HistoryLength then q.MessageQueue[#q.MessageQueue]=nil end u=g('TextLabel',t,{
Text=t..':',FontSize=o.Configuration.FontSize,TextXAlignment=Enum.TextXAlignment
.Left,TextYAlignment=Enum.TextYAlignment.Top,Parent=q.RenderFrame,TextWrapped=
false,Size=UDim2.new(1,0,0.1,0),BackgroundTransparency=1,TextTransparency=1,
Position=UDim2.new(0,0,1,0),BorderSizePixel=0,TextStrokeColor3=Color3.new(0.5,
0.5,0.5),TextStrokeTransparency=0.75})if r.Neutral then u.TextColor3=o:
ComputeChatColor(t)else u.TextColor3=r.TeamColor.Color end local w if not q.
CachedSpaceStrings_List[t]then w=o:ComputeSpaceString(u)else w=q.
CachedSpaceStrings_List[t]end v=g('TextLabel',tostring(t)..' - message',{Size=
UDim2.new(1,0,0.5,0),TextColor3=o.Configuration.MessageColor,FontSize=o.
Configuration.FontSize,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=
Enum.TextYAlignment.Top,Text='',Parent=q.RenderFrame,TextWrapped=true,
BackgroundTransparency=1,TextTransparency=1,Position=UDim2.new(0,0,1,0),
BorderSizePixel=0,TextStrokeColor3=Color3.new(0,0,0)})v.Text=w..s if not t then
u.Text=''v.TextColor3=Color3.new(0,0.4,1)end for x,y in pairs(q.Admins_List)do
if string.lower(y)==string.lower(t)then v.TextColor3=q.Configuration.
AdminMessageColor end end u.Visible=true v.Visible=true local z=v.TextBounds.Y v
.Size=UDim2.new(1,0,z/q.RenderFrame.AbsoluteSize.Y,0)u.Size=v.Size local A={}A[
'Player']=u A['Message']=v A['SpawnTime']=tick()table.insert(q.MessageQueue,1,A)
return o:UpdateQueue(A)end o.ScreenSizeChanged=function(q)wait()while q.Frame.
AbsoluteSize.Y>120 do q.Frame.Size=q.Frame.Size-UDim2.new(0,0,0.005,0)end end o.
FindButtonTree=function(q,r,s)local t={}s=s or q.SafeChatTree for u,v in pairs(s
)do if u==r then t=s[u]elseif type(s[u])=='table'then t=o:FindButtonTree(r,s[u])
end end return t end o.ToggleSafeChatMenu=function(q,r)local s=o:FindButtonTree(
r,q.SafeChatTree)if s then for t,u in pairs(s)do if t:IsA'TextButton'or t:IsA
'ImageButton'then t.Visible=not t.Visible end end return true end return false
end o.CreateSafeChatOptions=function(q,r,s)local t,u={},0 t[s]={}t[s][1]=r[1]s=s
or q.SafeChatButton for v,w in pairs(r)do if type(v)=='string'then local x=g(
'TextButton',v,{Text=v,Size=UDim2.new(0,100,0,20),TextXAlignment=Enum.
TextXAlignment.Center,TextColor3=Color3.new(0.2,0.1,0.1),BackgroundTransparency=
0.5,BackgroundColor3=Color3.new(1,1,1),Parent=q.SafeChatFrame,Visible=false,
Position=UDim2.new(0,s.Position.X.Scale+105,0,s.Position.Y.Scale-(u-3)*100)})u=u
+1 if type(r[v])=='table'then t[s][x]=o:CreateSafeChatOptions(r[v],x)end x.
MouseEnter:connect(function()return o:ToggleSafeChatMenu(x)end)x.MouseLeave:
connect(function()return o:ToggleSafeChatMenu(x)end)x.MouseButton1Click:connect(
function()local y=o:FindButtonTree(x)return pcall(function()return i:Chat(y[1])
end)end)end end return t end o.CreateSafeChatGui=function(q)q.SafeChatFrame=g(
'Frame','SafeChatFrame',{Size=UDim2.new(1,0,1,0),Parent=q.Gui,
BackgroundTransparency=1,g('ImageButton','SafeChatButton',{Size=UDim2.new(0,44,0
,31),Position=UDim2.new(0,1,0.35,0),BackgroundTransparency=1,Image=
'http://www.roblox.com/asset/?id=97080365'})})q.SafeChatButton=q.SafeChatFrame.
SafeChatButton q.SafeChatTree[q.SafeChatButton]=o:CreateSafeChatOptions(q.
SafeChat_List,q.SafeChatButton)return q.SafeChatButton.MouseButton1Click:
connect(function()return o:ToggleSafeChatMenu(q.SafeChatButton)end)end o.
FocusOnChatBar=function(q)if q.ClickToChatButton then q.ClickToChatButton.
Visible=false end q.GotFocus=true if q.Frame['Background']then q.Frame.
Background.Visible=false end return q.ChatBar:CaptureFocus()end o.
CreateTouchButton=function(q)q.ChatTouchFrame=g('Frame','ChatTouchFrame',{Size=
UDim2.new(0,128,0,32),Position=UDim2.new(0,88,0,0),BackgroundTransparency=1,
Parent=q.Gui,g('ImageButton','ChatLabel',{Size=UDim2.new(0,74,0,28),Position=
UDim2.new(0,0,0,0),BackgroundTransparency=1,ZIndex=2}),g('ImageLabel',
'Background',{Size=UDim2.new(1,0,1,0),Position=UDim2.new(0,0,0,0),
BackgroundTransparency=1,Image='http://www.roblox.com/asset/?id=97078724'})})q.
TapToChatLabel=q.ChatTouchFrame.ChatLabel q.TouchLabelBackground=q.
ChatTouchFrame.Background q.ChatBar=g('TextBox','ChatBar',{Size=UDim2.new(1,0,
0.2,0),Position=UDim2.new(0,0,0.8,800),Text='',ZIndex=1,BackgroundTransparency=1
,Parent=q.Frame,TextXAlignment=Enum.TextXAlignment.Left,TextColor3=Color3.new(1,
1,1),ClearTextOnFocus=false})return q.TapToChatLabel.MouseButton1Click:connect(
function()q.TapToChatLabel.Visible=false q.ChatBar:CaptureFocus()q.GotFocus=true
if q.TouchLabelBackground then q.TouchLabelBackground.Visible=false end end)end
o.CreateChatBar=function(q)local r,s r,s=pcall(function()return j.UseLuaChat end
)if a or(r and s)then q.ClickToChatButton=g('TextButton','ClickToChat',{Size=
UDim2.new(1,0,0,20),BackgroundTransparency=1,ZIndex=2,Parent=q.Gui,Text=
'To chat click here or press "/" key',TextColor3=Color3.new(1,1,0.9),Position=
UDim2.new(0,0,1,0),TextXAlignment=Enum.TextXAlignment.Left,FontSize=Enum.
FontSize.Size12})q.ChatBar=g('TextBox','ChatBar',{Size=UDim2.new(1,0,0,20),
Position=UDim2.new(0,0,1,0),Text='',ZIndex=1,BackgroundColor3=Color3.new(0,0,0),
BackgroundTransparency=0.25,Parent=q.Gui,TextXAlignment=Enum.TextXAlignment.Left
,TextColor3=Color3.new(1,1,1),FontSize=Enum.FontSize.Size12,ClearTextOnFocus=
false})local t,u t,u=pcall(function()return j:SetGlobalGuiInset(0,0,0,20)end)if
not t then j:SetGlobalSizeOffsetPixel(0,-20)end j:AddSpecialKey(Enum.SpecialKey.
ChatHotkey)j.SpecialKeyPressed:connect(function(v)if v==Enum.SpecialKey.
ChatHotkey then return o:FocusOnChatBar()end end)return q.ClickToChatButton.
MouseButton1Click:connect(function()return o:FocusOnChatBar()end)end end o.
CreateGui=function(q)q.Gui=b(h,'RobloxGui')q.Frame=g('Frame','ChatFrame',{Size=
UDim2.new(0,500,0,120),Position=UDim2.new(0,0,0,5),BackgroundTransparency=1,
ZIndex=0,Parent=q.Gui,Active=false,g('ImageLabel','Background',{Image=
'http://www.roblox.com/asset/?id=97120937',Size=UDim2.new(1.3,0,1.64,0),Position
=UDim2.new(0,0,0,0),BackgroundTransparency=1,ZIndex=0,Visible=false}),g('Frame',
'Border',{Size=UDim2.new(1,0,0,1),Position=UDim2.new(0,0,0.8,0),
BackgroundTransparency=0,BackgroundColor3=Color3.new(0.9254901960784314,
0.9254901960784314,0.9254901960784314),BorderSizePixel=0,Visible=false}),g(
'Frame','ChatRenderFrame',{Size=UDim2.new(1.02,0,1.01,0),Position=UDim2.new(0,0,
0,0),BackgroundTransparency=1,ZIndex=0,Active=false})})Spawn(function()wait(0.5)
if c()then q.Frame.Size=UDim2.new(0,280,0,120)end end)q.RenderFrame=q.Frame.
ChatRenderFrame if o:IsTouchDevice()then q.Frame.Position=q.Configuration.
Position q.RenderFrame.Size=UDim2.new(1,0,1,0)elseif q.Frame.AbsoluteSize.Y>120
then o:ScreenSizeChanged()q.Gui.Changed:connect(function(r)if r=='AbsoluteSize'
then return o:ScreenSizeChanged()end end)end if a or e.ChatMode==Enum.ChatMode.
TextAndMenu then if o:IsTouchDevice()then o:CreateTouchButton()else o:
CreateChatBar()end if q.ChatBar then return q.ChatBar.FocusLost:connect(function
(r)o.GotFocus=false if o:IsTouchDevice()then q.ChatBar.Visible=false q.
TapToChatLabel.Visible=true if q.TouchLabelBackground then q.
TouchLabelBackground.Visible=true end end if r and q.ChatBar.Text~=''then local
s=q.ChatBar.Text if string.sub(q.ChatBar.Text,1,1)=='%'then s='(TEAM) '..
tostring(string.sub(s,2,#s))pcall(function()return i:TeamChat(s)end)else pcall(
function()return i:Chat(s)end)end if q.ClickToChatButton then q.
ClickToChatButton.Visible=true end q.ChatBar.Text=''end return Spawn(function()
wait(5)if not o.GotFocus then o.Frame.Background.Visible=false end end)end)end
end end n.OnMouseScroll=function(q)Spawn(function()while n.Speed~=0 do if n.
Speed>1 then while n.Speed>0 do n.Speed=n.Speed-1 wait(0.25)end elseif n.Speed<0
then while n.Speed<0 do n.Speed=n.Speed+1 wait(0.25)end end wait(0.03)end end)if
o:CheckIfInBounds(n.Speed)then return end return o:ScrollQueue()end n.ApplySpeed
=function(q,r)n.Speed=n.Speed+r if not q.Simulating then return n:OnMouseScroll(
)end end n.Initialize=function(q)q.Mouse.WheelBackward:connect(function()return
n:ApplySpeed(q.Configuration.DefaultSpeed)end)return q.Mouse.WheelForward:
connect(function()return n:ApplySpeed(q.Configuration.DefaultSpeed)end)end o.
FindMessageInSafeChat=function(q,r,s)local t=false for u,v in pairs(s)do if u==r
then return true end if type(s[u])=='table'then t=o:FindMessageInSafeChat(r,s[u]
)if t then return true end end end return t end o.PlayerChatted=function(q,...)
local r,s,t={...},nil,nil if r[2]then s=r[2]end if r[3]then t=r[3]if string.sub(
t,1,1)=='%'then t='(TEAM) '..tostring(string.sub(t,2,#t))end end if i.
ClassicChat then if not(string.sub(t,1,3)=='/e 'or string.sub(t,1,7)=='/emote ')
and(a or e.ChatMode==Enum.ChatMode.TextAndMenu)or(e.ChatMode==Enum.ChatMode.Menu
and string.sub(t,1,3)=='/sc')or o:FindMessageInSafeChat(t,q.SafeChat_List)then
return o:UpdateChat(s,t)end end end o.CullThread=function(q)while true do if#q.
MessageQueue>0 then for r,s in pairs(q.MessageQueue)do if s['SpawnTime']and s[
'Player']and s['Message']and tick()-s['SpawnTime']>q.Configuration.LifeTime then
s['Player'].Visible=false s['Message'].Visible=false end end end wait(5)end end
o.LockAllFields=function(q,r)local s=r:GetChildren()for t=1,#s do s[t].
RobloxLocked=true if#s[t]:GetChildren()>0 then o:LockAllFields(s[t])end end end
o.CoreGuiChanged=function(q,r,s)if r==Enum.CoreGuiType.Chat or r==Enum.
CoreGuiType.All then if q.Frame then q.Frame.Visible=s end if not o:
IsTouchDevice()and q.ChatBar then q.ChatBar.Visible=s return j:
SetGlobalGuiInset(0,0,0,(function()if s then return 20 else return 0 end end)())
end end end o.Initialize=function(q)o:CreateGui()pcall(function()o:
CoreGuiChanged(Enum.CoreGuiType.Chat,Game.StarterGui:GetCoreGuiEnabled(Enum.
CoreGuiType.Chat))return Game.StarterGui.CoreGuiChangedSignal:connect(function(r
,s)return o:CoreGuiChanged(r,s)end)end)q.EventListener=i.PlayerChatted:connect(
function(...)return o:PlayerChatted(...)end)q.MessageThread=coroutine.create(
function()end)coroutine.resume(q.MessageThread)n:Initialize()i.ChildAdded:
connect(function()o.EventListener:disconnect()q.EventListener=i.PlayerChatted:
connect(function(...)return o:PlayerChatted(...)end)end)Spawn(function()return o
:CullThread()end)q.Frame.RobloxLocked=true o:LockAllFields(q.Frame)return q.
Frame.DescendantAdded:connect(function(r)return o:LockAllFields(r)end)end return
o:Initialize()