local a=false local function WaitForChild(b,c)while b:FindFirstChild(c)==nil do
b.ChildAdded:wait(0.03)end return b[c]end local function typedef(b)return b end
local function IsPhone()local b=Game:GetService'CoreGui'local c=WaitForChild(b,
'RobloxGui')if c.AbsoluteSize.Y<600 then return true end return false end
local function StringTrim(b)return(b:gsub('^%s*(.-)%s*$','%1'))end while Game.
Players.LocalPlayer==nil do wait(0.03)end local b=Game.Players.LocalPlayer while
b.Character==nil do wait(0.03)end local c=LoadLibrary'RbxUtility'local d,e,f,g,h
,i,j=typedef(c),Game.Workspace.CurrentCamera,Game:GetService'CoreGui',Game:
GetService'Players',Game:GetService'GuiService',nil,nil do i={}local k={}local l
,m={__call=function(l,m)return l[m]or l[tonumber(m)]end,__index={GetEnumItems=
function(l)local m={}for n,o in pairs(l)do if type(n)=='number'then m[#m+1]=o
end end table.sort(m,function(p,q)return p.Value<q.Value end)return m end},
__tostring=function(l)return'Enum.'..l[k]end},{__call=function(l,m)return m==l
or m==l.Name or m==l.Value end,__tostring=function(l)return'Enum.'..l[k]..'.'..l
.Name end}j=function(n)return function(o)local p={[k]=n}for q,r in pairs(o)do
local s=setmetatable({Name=r,Value=q,Enum=p,[k]=n},m)p[q]=s p[r]=s p[s]=s end i[
n]=p return setmetatable(p,l)end end end local k,l={Mouse=b:GetMouse(),Speed=0,
Simulating=false,Configuration={DefaultSpeed=1},UserIsScrolling=false},{
ChatColors={BrickColor.new'Bright red',BrickColor.new'Bright blue',BrickColor.
new'Earth green',BrickColor.new'Bright violet',BrickColor.new'Bright orange',
BrickColor.new'Bright yellow',BrickColor.new'Light reddish violet',BrickColor.
new'Brick yellow'},Gui=nil,Frame=nil,RenderFrame=nil,TapToChatLabel=nil,
ClickToChatButton=nil,ScrollingLock=false,EventListener=nil,MessageQueue={},
Configuration={FontSize=Enum.FontSize.Size12,NumFontSize=12,HistoryLength=20,
Size=UDim2.new(0.38,0,0.2,0),MessageColor=Color3.new(1,1,1),AdminMessageColor=
Color3.new(1,0.8431372549019608,0),XScale=0.025,LifeTime=45,Position=UDim2.new(0
,2,0.05,0),DefaultTweenSpeed=0.15},SlotPositions_List={},CachedSpaceStrings_List
={},MouseOnFrame=false,GotFocus=false,Messages_List={},MessageThread=nil,
Admins_List={'taskmanager','Heliodex','tako'},SafeChat_List={[
'Use the Chat menu to talk to me.']={'/sc 0',true},['I can only see menu chats.'
]={'/sc 1',true},['Hello']={['Hi']={'/sc 2_0',true,['Hi there!']=true,[
'Hi everyone']=true},['Howdy']={'/sc 2_1',true,['Howdy partner!']=true},[
'Greetings']={'/sc 2_2',true,['Greetings everyone']=true,[
'Greetings Robloxians!']=true,['Seasons greetings!']=true},['Welcome']={
'/sc 2_3',true,['Welcome to my place']=true,['Welcome to my barbeque']=true,[
'Welcome to our base']=true},['Hey there!']={'/sc 2_4',true},["What's up?"]={
'/sc 2_5',true,['How are you doing?']=true,["How's it going?"]=true,[
"What's new?"]=true},['Good day']={'/sc 2_6',true,['Good morning']=true,[
'Good evening']=true,['Good afternoon']=true,['Good night']=true},['Silly']={
'/sc 2_7',true,['Waaaaaaaz up?!']=true,['Hullo!']=true,[
'Behold greatness, mortals!']=true,['Pardon me, is this Sparta?']=true,[
'THIS IS SPARTAAAA!']=true},['Happy Holidays!']={'/sc 2_8',true,[
'Happy New Year!']=true,["Happy Valentine's Day!"]=true,[
'Beware the Ides of March!']=true,["Happy St. Patrick's Day!"]=true,[
'Happy Easter!']=true,['Happy Earth Day!']=true,['Happy 4th of July!']=true,[
'Happy Thanksgiving!']=true,['Happy Halloween!']=true,['Happy Hanukkah!']=true,[
'Merry Christmas!']=true,['Happy May Day!']=true,['Happy Towel Day!']=true,[
'Happy Mercury Day!']=true,['Happy LOL Day!']=true},[1]='/sc 2'},['Goodbye']={[
'Good Night']={'/sc 3_0',true,['Sweet dreams']=true,['Go to sleep!']=true,[
'Lights out!']=true,['Bedtime']=true,['Going to bed now']=true},['Later']={
'/sc 3_1',true,['See ya later']=true,['Later gator!']=true,['See you tomorrow']=
true},['Bye']={'/sc 3_2',true,['Hasta la bye bye!']=true},["I'll be right back"]
={'/sc 3_3',true},['I have to go']={'/sc 3_4',true},['Farewell']={'/sc 3_5',true
,['Take care']=true,['Have a nice day']=true,['Goodluck!']=true,[
'Ta-ta for now!']=true},['Peace']={'/sc 3_6',true,['Peace out!']=true,[
'Peace dudes!']=true,['Rest in pieces!']=true},['Silly']={'/sc 3_7',true,[
'To the batcave!']=true,['Over and out!']=true,['Happy trails!']=true,[
"I've got to book it!"]=true,['Tootles!']=true,['Smell you later!']=true,['GG!']
=true,['My house is on fire! gtg.']=true},[1]='/sc 3'},['Friend']={[
'Wanna be friends?']={'/sc 4_0',true},['Follow me']={'/sc 4_1',true,[
'Come to my place!']=true,['Come to my base!']=true,['Follow me, team!']=true,[
'Follow me']=true},['Your place is cool']={'/sc 4_2',true,['Your place is fun']=
true,['Your place is awesome']=true,['Your place looks good']=true,[
'This place is awesome!']=true},['Thank you']={'/sc 4_3',true,[
'Thanks for playing']=true,['Thanks for visiting']=true,['Thanks for everything'
]=true,['No, thank you']=true,['Thanx']=true},['No problem']={'/sc 4_4',true,[
"Don't worry"]=true,["That's ok"]=true,['np']=true},['You are ...']={'/sc 4_5',
true,['You are great!']=true,['You are good!']=true,['You are cool!']=true,[
'You are funny!']=true,['You are silly!']=true,['You are awesome!']=true,[
"You are doing something I don't like, please stop"]=true},['I like ...']={
'/sc 4_6',true,['I like your name']=true,['I like your shirt']=true,[
'I like your place']=true,['I like your style']=true,['I like you']=true,[
'I like items']=true,['I like money']=true},['Sorry']={'/sc 4_7',true,['My bad!'
]=true,["I'm sorry"]=true,['Whoops!']=true,['Please forgive me.']=true,[
'I forgive you.']=true,["I didn't mean to do that."]=true,[
"Sorry, I'll stop now."]=true},[1]='/sc 4'},['Questions']={['Who?']={'/sc 5_0',
true,['Who wants to be my friend?']=true,['Who wants to be on my team?']=true,[
'Who made this brilliant game?']=true},['What?']={'/sc 5_1',true,[
'What is your favorite animal?']=true,['What is your favorite game?']=true,[
'What is your favorite movie?']=true,['What is your favorite TV show?']=true,[
'What is your favorite music?']=true,['What are your hobbies?']=true,['LOLWUT?']
=true},['When?']={'/sc 5_2',true,['When are you online?']=true,[
'When is the new version coming out?']=true,['When can we play again?']=true,[
'When will your place be done?']=true},['Where?']={'/sc 5_3',true,[
'Where do you want to go?']=true,['Where are you going?']=true,['Where am I?!']=
true,['Where did you go?']=true},['How?']={'/sc 5_4',true,['How are you today?']
=true,['How did you make this cool place?']=true,['LOLHOW?']=true},['Can I...']=
{'/sc 5_5',true,['Can I have a tour?']=true,['Can I be on your team?']=true,[
'Can I be your friend?']=true,['Can I try something?']=true,[
'Can I have that please?']=true,['Can I have that back please?']=true,[
'Can I have borrow your hat?']=true,['Can I have borrow your gear?']=true},[1]=
'/sc 5'},['Answers']={['You need help?']={'/sc 6_0',true,[
'Check out the news section']=true,['Check out the help section']=true,[
'Read the wiki!']=true,['All the answers are in the wiki!']=true,[
'I will help you with this.']=true},['Some people ...']={'/sc 6_1',true,['Me']=
true,['Not me']=true,['You']=true,['All of us']=true,['Everyone but you']=true,[
'Builderman!']=true,['Telamon!']=true,['My team']=true,['My group']=true,['Mom']
=true,['Dad']=true,['Sister']=true,['Brother']=true,['Cousin']=true,[
'Grandparent']=true,['Friend']=true},['Time ...']={'/sc 6_2',true,[
'In the morning']=true,['In the afternoon']=true,['At night']=true,['Tomorrow']=
true,['This week']=true,['This month']=true,['Sometime']=true,['Sometimes']=true
,['Whenever you want']=true,['Never']=true,['After this']=true,['In 10 minutes']
=true,['In a couple hours']=true,['In a couple days']=true},['Animals']={
'/sc 6_3',true,['Cats']={['Lion']=true,['Tiger']=true,['Leopard']=true,[
'Cheetah']=true},['Dogs']={['Wolves']=true,['Beagle']=true,['Collie']=true,[
'Dalmatian']=true,['Poodle']=true,['Spaniel']=true,['Shepherd']=true,['Terrier']
=true,['Retriever']=true},['Horses']={['Ponies']=true,['Stallions']=true,[
'Pwnyz']=true},['Reptiles']={['Dinosaurs']=true,['Lizards']=true,['Snakes']=true
,['Turtles!']=true},['Hamster']=true,['Monkey']=true,['Bears']=true,['Fish']={[
'Goldfish']=true,['Sharks']=true,['Sea Bass']=true,['Halibut']=true,[
'Tropical Fish']=true},['Birds']={['Eagles']=true,['Penguins']=true,['Parakeets'
]=true,['Owls']=true,['Hawks']=true,['Pidgeons']=true},['Elephants']=true,[
'Mythical Beasts']={['Dragons']=true,['Unicorns']=true,['Sea Serpents']=true,[
'Sphinx']=true,['Cyclops']=true,['Minotaurs']=true,['Goblins']=true,[
'Honest Politicians']=true,['Ghosts']=true,['Scylla and Charybdis']=true}},[
'Games']={'/sc 6_4',true,['Action']=true,['Puzzle']=true,['Strategy']=true,[
'Racing']=true,['RPG']=true,['Obstacle Course']=true,['Tycoon']=true,['Roblox']=
{['BrickBattle']=true,['Community Building']=true,['Roblox Minigames']=true,[
'Contest Place']=true},['Board games']={['Chess']=true,['Checkers']=true,[
'Settlers of Catan']=true,['Tigris and Euphrates']=true,['El Grande']=true,[
'Stratego']=true,['Carcassonne']=true}},['Sports']={'/sc 6_5',true,['Hockey']=
true,['Soccer']=true,['Football']=true,['Baseball']=true,['Basketball']=true,[
'Volleyball']=true,['Tennis']=true,['Sports team practice']=true,['Watersports']
={['Surfing']=true,['Swimming']=true,['Water Polo']=true},['Winter sports']={[
'Skiing']=true,['Snowboarding']=true,['Sledding']=true,['Skating']=true},[
'Adventure']={['Rock climbing']=true,['Hiking']=true,['Fishing']=true,[
'Horseback riding']=true},['Wacky']={['Foosball']=true,['Calvinball']=true,[
'Croquet']=true,['Cricket']=true,['Dodgeball']=true,['Squash']=true,[
'Trampoline']=true}},['Movies/TV']={'/sc 6_6',true,['Science Fiction']=true,[
'Animated']={['Anime']=true},['Comedy']=true,['Romantic']=true,['Action']=true,[
'Fantasy']=true},['Music']={'/sc 6_7',true,['Country']=true,['Jazz']=true,['Rap'
]=true,['Hip-hop']=true,['Techno']=true,['Classical']=true,['Pop']=true,['Rock']
=true},['Hobbies']={'/sc 6_8',true,['Computers']={['Building computers']=true,[
'Videogames']=true,['Coding']=true,['Hacking']=true},['The Internet']={[
'lol. teh internets!']=true,['Watching vids']=true},['Dance']=true,['Gymnastics'
]=true,['Listening to music']=true,['Arts and crafts']=true,['Martial Arts']={[
'Karate']=true,['Judo']=true,['Taikwon Do']=true,['Wushu']=true,[
'Street fighting']=true},['Music lessons']={['Playing in my band']=true,[
'Playing piano']=true,['Playing guitar']=true,['Playing violin']=true,[
'Playing drums']=true,['Playing a weird instrument']=true}},['Location']={
'/sc 6_9',true,['USA']={['West']={['Alaska']=true,['Arizona']=true,['California'
]=true,['Colorado']=true,['Hawaii']=true,['Idaho']=true,['Montana']=true,[
'Nevada']=true,['New Mexico']=true,['Oregon']=true,['Utah']=true,['Washington']=
true,['Wyoming']=true},['South']={['Alabama']=true,['Arkansas']=true,['Florida']
=true,['Georgia']=true,['Kentucky']=true,['Louisiana']=true,['Mississippi']=true
,['North Carolina']=true,['Oklahoma']=true,['South Carolina']=true,['Tennessee']
=true,['Texas']=true,['Virginia']=true,['West Virginia']=true},['Northeast']={[
'Connecticut']=true,['Delaware']=true,['Maine']=true,['Maryland']=true,[
'Massachusetts']=true,['New Hampshire']=true,['New Jersey']=true,['New York']=
true,['Pennsylvania']=true,['Rhode Island']=true,['Vermont']=true},['Midwest']={
['Illinois']=true,['Indiana']=true,['Iowa']=true,['Kansas']=true,['Michigan']=
true,['Minnesota']=true,['Missouri']=true,['Nebraska']=true,['North Dakota']=
true,['Ohio']=true,['South Dakota']=true,['Wisconsin']=true}},['Canada']={[
'Alberta']=true,['British Columbia']=true,['Manitoba']=true,['New Brunswick']=
true,['Newfoundland']=true,['Northwest Territories']=true,['Nova Scotia']=true,[
'Nunavut']=true,['Ontario']=true,['Prince Edward Island']=true,['Quebec']=true,[
'Saskatchewan']=true,['Yukon']=true},['Mexico']=true,['Central America']=true,[
'Europe']={['France']=true,['Germany']=true,['Spain']=true,['Italy']=true,[
'Poland']=true,['Switzerland']=true,['Greece']=true,['Romania']=true,[
'Netherlands']=true,['Great Britain']={['England']=true,['Scotland']=true,[
'Wales']=true,['Northern Ireland']=true}},['Asia']={['China']=true,['India']=
true,['Japan']=true,['Korea']=true,['Russia']=true,['Vietnam']=true},[
'South America']={['Argentina']=true,['Brazil']=true},['Africa']={['Eygpt']=true
,['Swaziland']=true},['Australia']=true,['Middle East']=true,['Antarctica']=true
,['New Zealand']=true},['Age']={'/sc 6_10',true,['Rugrat']=true,['Kid']=true,[
'Tween']=true,['Teen']=true,['Twenties']=true,['Old']=true,['Ancient']=true,[
'Mesozoic']=true,["I don't want to say my age. Don't ask."]=true},['Mood']={
'/sc 6_11',true,['Good']=true,['Great!']=true,['Not bad']=true,['Sad']=true,[
'Hyper']=true,['Chill']=true,['Happy']=true,['Kind of mad']=true},['Boy']={
'/sc 6_12',true},['Girl']={'/sc 6_13',true},[
"I don't want to say boy or girl. Don't ask."]={'/sc 6_14',true},[1]='/sc 6'},[
'Game']={["Let's build"]={'/sc 7_0',true},["Let's battle"]={'/sc 7_1',true},[
'Nice one!']={'/sc 7_2',true},['So far so good']={'/sc 7_3',true},['Lucky shot!'
]={'/sc 7_4',true},['Oh man!']={'/sc 7_5',true},['I challenge you to a fight!']=
{'/sc 7_6',true},['Help me with this']={'/sc 7_7',true},["Let's go to your game"
]={'/sc 7_8',true},['Can you show me how do to that?']={'/sc 7_9',true},[
'Backflip!']={'/sc 7_10',true},['Frontflip!']={'/sc 7_11',true},['Dance!']={
'/sc 7_12',true},["I'm on your side!"]={'/sc 7_13',true},['Game Commands']={
'/sc 7_14',true,['regen']=true,['reset']=true,['go']=true,['fix']=true,[
'respawn']=true},[1]='/sc 7'},['Silly']={['Muahahahaha!']=true,[
'all your base are belong to me!']=true,['GET OFF MAH LAWN']=true,[
'TEH EPIK DUCK IS COMING!!!']=true,['ROFL']=true,['1337']={true,[
'i r teh pwnz0r!']=true,['w00t!']=true,['z0mg h4x!']=true,['ub3rR0xXorzage!']=
true}},['Yes']={['Absolutely!']=true,['Rock on!']=true,['Totally!']=true,[
'Juice!']=true,['Yay!']=true,['Yesh']=true},['No']={['Ummm. No.']=true,['...']=
true,['Stop!']=true,['Go away!']=true,["Don't do that"]=true,[
'Stop breaking the rules']=true,["I don't want to"]=true},['Ok']={['Well... ok']
=true,['Sure']=true},['Uncertain']={['Maybe']=true,["I don't know"]=true,['idk']
=true,["I can't decide"]=true,['Hmm...']=true},[':-)']={[':-(']=true,[':D']=true
,[':-O']=true,['lol']=true,['=D']=true,['D=']=true,['XD']=true,[';D']=true,[';)'
]=true,['O_O']=true,['=)']=true,['@_@']=true,['&gt;_&lt;']=true,['T_T']=true,[
'^_^']=true,['<(0_0<) <(0_0)> (>0_0)> KIRBY DANCE']=true,[")';"]=true,[':3']=
true},['Ratings']={['Rate it!']=true,['I give it a 1 out of 10']=true,[
'I give it a 2 out of 10']=true,['I give it a 3 out of 10']=true,[
'I give it a 4 out of 10']=true,['I give it a 5 out of 10']=true,[
'I give it a 6 out of 10']=true,['I give it a 7 out of 10']=true,[
'I give it a 8 out of 10']=true,['I give it a 9 out of 10']=true,[
'I give it a 10 out of 10!']=true}},j'SafeChat'{'Level1','Level2','Level3'},
SafeChatTree={},TempSpaceLabel=nil}local function GetNameValue(m)local n=0 for o
=1,#m do local p,q=string.byte(string.sub(m,o,o)),#m-o+1 if#m%2==1 then q=q-1
end if q%4>=2 then p=-p end n=n+p end return n%8 end function l:ComputeChatColor
(m)return self.ChatColors[GetNameValue(m)+1].Color end function l:
EnableScrolling(m)self.MouseOnFrame=false if self.RenderFrame then self.
RenderFrame.MouseEnter:connect(function()local n=b.Character local o,p=
WaitForChild(n,'Torso'),WaitForChild(n,'Head')if m then self.MouseOnFrame=true e
.CameraType='Scriptable'Spawn(function()local q=e.CoordinateFrame.p-o.Position
while l.MouseOnFrame do e.CoordinateFrame=CFrame.new(o.Position+q,p.Position)
wait(0.015)end end)end end)self.RenderFrame.MouseLeave:connect(function()e.
CameraType='Custom'self.MouseOnFrame=false end)end end function l:IsTouchDevice(
)local m=false pcall(function()m=Game:GetService'UserInputService'.TouchEnabled
end)return m end function l:UpdateQueue(m,n)for o=#self.MessageQueue,1,-1 do if
self.MessageQueue[o]then for p,q in pairs(self.MessageQueue[o])do if q and type(
q)~='table'and type(q)~='number'then if q:IsA'TextLabel'or q:IsA'TextButton'then
if n then q.Position=q.Position-UDim2.new(0,0,n,0)else if m==self.MessageQueue[o
]then q.Position=UDim2.new(self.Configuration.XScale,0,q.Position.Y.Scale-m[
'Message'].Size.Y.Scale,0)Spawn(function()wait(0.05)while q.TextTransparency>=0
do q.TextTransparency=q.TextTransparency-0.2 wait(0.03)end if q==m['Message']
then q.TextStrokeTransparency=0.8 else q.TextStrokeTransparency=1 end end)else q
.Position=UDim2.new(self.Configuration.XScale,0,q.Position.Y.Scale-m['Message'].
Size.Y.Scale,0)end if q.Position.Y.Scale<-1E-2 then q.Visible=false q:Destroy()
end end end end end end end end function l:CreateScrollBar()end function l:
CheckIfInBounds(m)if#l.MessageQueue<3 then return true end if m>0 and l.
MessageQueue[1]and l.MessageQueue[1]['Player']and l.MessageQueue[1]['Player'].
Position.Y.Scale==0 then return true elseif m<0 and l.MessageQueue[1]and l.
MessageQueue[1]['Player']and l.MessageQueue[1]['Player'].Position.Y.Scale<0 then
return true else return false end return false end function l:ComputeSpaceString
(m)local n=' 'if not self.TempSpaceLabel then self.TempSpaceLabel=d.Create
'TextButton'{Size=UDim2.new(0,m.AbsoluteSize.X,0,m.AbsoluteSize.Y),FontSize=self
.Configuration.FontSize,Parent=self.RenderFrame,BackgroundTransparency=1,Text=n,
Name='SpaceButton'}else self.TempSpaceLabel.Text=n end while self.TempSpaceLabel
.TextBounds.X<m.TextBounds.X do n=n..' 'self.TempSpaceLabel.Text=n end n=n..' '
self.CachedSpaceStrings_List[m.Text]=n self.TempSpaceLabel.Text=''return n end
function l:UpdateChat(m,n)local o={['Player']=m,['Message']=n}if coroutine.
status(l.MessageThread)=='dead'then table.insert(l.Messages_List,o)l.
MessageThread=coroutine.create(function()for p=1,#l.Messages_List do local q=l.
Messages_List[p]l:CreateMessage(q['Player'],q['Message'])end l.Messages_List={}
end)coroutine.resume(l.MessageThread)else table.insert(l.Messages_List,o)end end
function l:RecalculateSpacing()end function l:CreateMessage(m,n)local o if not m
then o=''else o=m.Name end n=StringTrim(n)local p,q if#self.MessageQueue>self.
Configuration.HistoryLength then self.MessageQueue[#self.MessageQueue]=nil end p
=d.Create'TextLabel'{Name=o,Text=o..':',FontSize=l.Configuration.FontSize,
TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top,
Parent=self.RenderFrame,TextWrapped=false,Size=UDim2.new(1,0,0.1,0),
BackgroundTransparency=1,TextTransparency=1,Position=UDim2.new(0,0,1,0),
BorderSizePixel=0,TextStrokeColor3=Color3.new(0.5,0.5,0.5),
TextStrokeTransparency=0.75}if m.Neutral then p.TextColor3=l:ComputeChatColor(o)
else p.TextColor3=m.TeamColor.Color end local r if not self.
CachedSpaceStrings_List[o]then r=l:ComputeSpaceString(p)else r=self.
CachedSpaceStrings_List[o]end q=d.Create'TextLabel'{Name=o..' - message',Size=
UDim2.new(1,0,0.5,0),TextColor3=l.Configuration.MessageColor,FontSize=l.
Configuration.FontSize,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=
Enum.TextYAlignment.Top,Text='',Parent=self.RenderFrame,TextWrapped=true,
BackgroundTransparency=1,TextTransparency=1,Position=UDim2.new(0,0,1,0),
BorderSizePixel=0,TextStrokeColor3=Color3.new(0,0,0)}q.Text=r..n if not o then p
.Text=''q.TextColor3=Color3.new(0,0.4,1)end for s,t in pairs(self.Admins_List)do
if string.lower(t)==string.lower(o)then q.TextColor3=self.Configuration.
AdminMessageColor end end p.Visible=true q.Visible=true local u=q.TextBounds.Y q
.Size=UDim2.new(1,0,u/self.RenderFrame.AbsoluteSize.Y,0)p.Size=q.Size local v={}
v['Player']=p v['Message']=q v['SpawnTime']=tick()table.insert(self.MessageQueue
,1,v)l:UpdateQueue(v)end function l:ScreenSizeChanged()wait()while self.Frame.
AbsoluteSize.Y>120 do self.Frame.Size=self.Frame.Size-UDim2.new(0,0,0.005,0)end
l:RecalculateSpacing()end function l:FindButtonTree(m,n)local o={}n=n or self.
SafeChatTree for p,q in pairs(n)do if p==m then o=n[p]elseif type(n[p])=='table'
then o=l:FindButtonTree(m,n[p])end end return o end function l:
ToggleSafeChatMenu(m)local n=l:FindButtonTree(m,self.SafeChatTree)if n then for
o,p in pairs(n)do if o:IsA'TextButton'or o:IsA'ImageButton'then o.Visible=not o.
Visible end end return true end return false end function l:
CreateSafeChatOptions(m,n)local o,p={},0 o[n]={}o[n][1]=m[1]n=n or self.
SafeChatButton for q,r in pairs(m)do if type(q)=='string'then local s=d.Create
'TextButton'{Name=q,Text=q,Size=UDim2.new(0,100,0,20),TextXAlignment=Enum.
TextXAlignment.Center,TextColor3=Color3.new(0.2,0.1,0.1),BackgroundTransparency=
0.5,BackgroundColor3=Color3.new(1,1,1),Parent=self.SafeChatFrame,Visible=false,
Position=UDim2.new(0,n.Position.X.Scale+105,0,n.Position.Y.Scale-((p-3)*100))}p=
p+1 if type(m[q])=='table'then o[n][s]=l:CreateSafeChatOptions(m[q],s)end s.
MouseEnter:connect(function()l:ToggleSafeChatMenu(s)end)s.MouseLeave:connect(
function()l:ToggleSafeChatMenu(s)end)s.MouseButton1Click:connect(function()local
t=l:FindButtonTree(s)pcall(function()g:Chat(t[1])end)end)end end return o end
function l:CreateSafeChatGui()self.SafeChatFrame=d.Create'Frame'{Name=
'SafeChatFrame',Size=UDim2.new(1,0,1,0),Parent=self.Gui,BackgroundTransparency=1
,d.Create'ImageButton'{Name='SafeChatButton',Size=UDim2.new(0,44,0,31),Position=
UDim2.new(0,1,0.35,0),BackgroundTransparency=1,Image=
'http://www.roblox.com/asset/?id=97080365'}}self.SafeChatButton=self.
SafeChatFrame.SafeChatButton self.SafeChatTree[self.SafeChatButton]=l:
CreateSafeChatOptions(self.SafeChat_List,self.SafeChatButton)self.SafeChatButton
.MouseButton1Click:connect(function()l:ToggleSafeChatMenu(self.SafeChatButton)
end)end function l:FocusOnChatBar()if self.ClickToChatButton then self.
ClickToChatButton.Visible=false end self.GotFocus=true if self.Frame[
'Background']then self.Frame.Background.Visible=false end self.ChatBar:
CaptureFocus()end function l:CreateTouchButton()self.ChatTouchFrame=d.Create
'Frame'{Name='ChatTouchFrame',Size=UDim2.new(0,128,0,32),Position=UDim2.new(0,88
,0,0),BackgroundTransparency=1,Parent=self.Gui,d.Create'ImageButton'{Name=
'ChatLabel',Size=UDim2.new(0,74,0,28),Position=UDim2.new(0,0,0,0),
BackgroundTransparency=1,ZIndex=2},d.Create'ImageLabel'{Name='Background',Size=
UDim2.new(1,0,1,0),Position=UDim2.new(0,0,0,0),BackgroundTransparency=1,Image=
'http://www.roblox.com/asset/?id=97078724'}}self.TapToChatLabel=self.
ChatTouchFrame.ChatLabel self.TouchLabelBackground=self.ChatTouchFrame.
Background self.ChatBar=d.Create'TextBox'{Name='ChatBar',Size=UDim2.new(1,0,0.2,
0),Position=UDim2.new(0,0,0.8,800),Text='',ZIndex=1,BackgroundTransparency=1,
Parent=self.Frame,TextXAlignment=Enum.TextXAlignment.Left,TextColor3=Color3.new(
1,1,1),ClearTextOnFocus=false}self.TapToChatLabel.MouseButton1Click:connect(
function()self.TapToChatLabel.Visible=false self.ChatBar:CaptureFocus()self.
GotFocus=true if self.TouchLabelBackground then self.TouchLabelBackground.
Visible=false end end)end function l:CreateChatBar()local m,n=pcall(function()
return h.UseLuaChat end)if a or(m and n)then self.ClickToChatButton=d.Create
'TextButton'{Name='ClickToChat',Size=UDim2.new(1,0,0,20),BackgroundTransparency=
1,ZIndex=2,Parent=self.Gui,Text='To chat click here or press "/" key',TextColor3
=Color3.new(1,1,0.9),Position=UDim2.new(0,0,1,0),TextXAlignment=Enum.
TextXAlignment.Left,FontSize=Enum.FontSize.Size12}self.ChatBar=d.Create'TextBox'
{Name='ChatBar',Size=UDim2.new(1,0,0,20),Position=UDim2.new(0,0,1,0),Text='',
ZIndex=1,BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=0.25,Parent=
self.Gui,TextXAlignment=Enum.TextXAlignment.Left,TextColor3=Color3.new(1,1,1),
FontSize=Enum.FontSize.Size12,ClearTextOnFocus=false}local o,p=pcall(function()h
:SetGlobalGuiInset(0,0,0,20)end)if not o then h:SetGlobalSizeOffsetPixel(0,-20)
end h:AddSpecialKey(Enum.SpecialKey.ChatHotkey)h.SpecialKeyPressed:connect(
function(q)if q==Enum.SpecialKey.ChatHotkey then l:FocusOnChatBar()end end)self.
ClickToChatButton.MouseButton1Click:connect(function()l:FocusOnChatBar()end)end
end function l:CreateGui()self.Gui=WaitForChild(f,'RobloxGui')self.Frame=d.
Create'Frame'{Name='ChatFrame',Size=UDim2.new(0,500,0,120),Position=UDim2.new(0,
0,0,5),BackgroundTransparency=1,ZIndex=0,Parent=self.Gui,Active=false,d.Create
'ImageLabel'{Name='Background',Image='http://www.roblox.com/asset/?id=97120937',
Size=UDim2.new(1.3,0,1.64,0),Position=UDim2.new(0,0,0,0),BackgroundTransparency=
1,ZIndex=0,Visible=false},d.Create'Frame'{Name='Border',Size=UDim2.new(1,0,0,1),
Position=UDim2.new(0,0,0.8,0),BackgroundTransparency=0,BackgroundColor3=Color3.
new(0.9254901960784314,0.9254901960784314,0.9254901960784314),BorderSizePixel=0,
Visible=false},d.Create'Frame'{Name='ChatRenderFrame',Size=UDim2.new(1.02,0,1.01
,0),Position=UDim2.new(0,0,0,0),BackgroundTransparency=1,ZIndex=0,Active=false}}
Spawn(function()wait(0.5)if IsPhone()then self.Frame.Size=UDim2.new(0,280,0,120)
end end)self.RenderFrame=self.Frame.ChatRenderFrame if l:IsTouchDevice()then
self.Frame.Position=self.Configuration.Position self.RenderFrame.Size=UDim2.new(
1,0,1,0)elseif self.Frame.AbsoluteSize.Y>120 then l:ScreenSizeChanged()self.Gui.
Changed:connect(function(m)if m=='AbsoluteSize'then l:ScreenSizeChanged()end end
)end if a or b.ChatMode==Enum.ChatMode.TextAndMenu then if l:IsTouchDevice()then
l:CreateTouchButton()else l:CreateChatBar()end if self.ChatBar then self.ChatBar
.FocusLost:connect(function(m)l.GotFocus=false if l:IsTouchDevice()then self.
ChatBar.Visible=false self.TapToChatLabel.Visible=true if self.
TouchLabelBackground then self.TouchLabelBackground.Visible=true end end if m
and self.ChatBar.Text~=''then local n=self.ChatBar.Text if string.sub(self.
ChatBar.Text,1,1)=='%'then n='(TEAM) '..string.sub(n,2,#n)pcall(function()g:
TeamChat(n)end)else pcall(function()g:Chat(n)end)end if self.ClickToChatButton
then self.ClickToChatButton.Visible=true end self.ChatBar.Text=''end Spawn(
function()wait(5)if not l.GotFocus then l.Frame.Background.Visible=false end end
)end)end end end function k:OnMouseScroll()Spawn(function()while k.Speed~=0 do
if k.Speed>1 then while k.Speed>0 do k.Speed=k.Speed-1 wait(0.25)end elseif k.
Speed<0 then while k.Speed<0 do k.Speed=k.Speed+1 wait(0.25)end end wait(0.03)
end end)if l:CheckIfInBounds(k.Speed)then return end l:ScrollQueue()end function
k:ApplySpeed(m)k.Speed=k.Speed+m if not self.Simulating then k:OnMouseScroll()
end end function k:Initialize()self.Mouse.WheelBackward:connect(function()k:
ApplySpeed(self.Configuration.DefaultSpeed)end)self.Mouse.WheelForward:connect(
function()k:ApplySpeed(self.Configuration.DefaultSpeed)end)end function l:
FindMessageInSafeChat(m,n)local o=false for p,q in pairs(n)do if p==m then
return true end if type(n[p])=='table'then o=l:FindMessageInSafeChat(m,n[p])if o
then return true end end end return o end function l:PlayerChatted(...)local m,n
,o={...},nil,nil if m[2]then n=m[2]end if m[3]then o=m[3]if string.sub(o,1,1)==
'%'then o='(TEAM) '..string.sub(o,2,#o)end end if g.ClassicChat then if not(
string.sub(o,1,3)=='/e 'or string.sub(o,1,7)=='/emote ')and(a or b.ChatMode==
Enum.ChatMode.TextAndMenu)or(b.ChatMode==Enum.ChatMode.Menu and string.sub(o,1,3
)=='/sc')or(l:FindMessageInSafeChat(o,self.SafeChat_List))then l:UpdateChat(n,o)
end end end function l:CullThread()while true do if#self.MessageQueue>0 then for
m,n in pairs(self.MessageQueue)do if n['SpawnTime']and n['Player']and n[
'Message']and tick()-n['SpawnTime']>self.Configuration.LifeTime then n['Player']
.Visible=false n['Message'].Visible=false end end end wait(5)end end function l:
LockAllFields(m)local n=m:GetChildren()for o=1,#n do n[o].RobloxLocked=true if#n
[o]:GetChildren()>0 then l:LockAllFields(n[o])end end end function l:
CoreGuiChanged(m,n)if m==Enum.CoreGuiType.Chat or m==Enum.CoreGuiType.All then
if self.Frame then self.Frame.Visible=n end if not l:IsTouchDevice()and self.
ChatBar then self.ChatBar.Visible=n if n then h:SetGlobalGuiInset(0,0,0,20)else
h:SetGlobalGuiInset(0,0,0,0)end end end end function l:Initialize()l:CreateGui()
pcall(function()l:CoreGuiChanged(Enum.CoreGuiType.Chat,Game.StarterGui:
GetCoreGuiEnabled(Enum.CoreGuiType.Chat))Game.StarterGui.CoreGuiChangedSignal:
connect(function(m,n)l:CoreGuiChanged(m,n)end)end)self.EventListener=g.
PlayerChatted:connect(function(...)l:PlayerChatted(...)end)self.MessageThread=
coroutine.create(function()end)coroutine.resume(self.MessageThread)k:Initialize(
)g.ChildAdded:connect(function()l.EventListener:disconnect()self.EventListener=g
.PlayerChatted:connect(function(...)l:PlayerChatted(...)end)end)Spawn(function()
l:CullThread()end)self.Frame.RobloxLocked=true l:LockAllFields(self.Frame)self.
Frame.DescendantAdded:connect(function(m)l:LockAllFields(m)end)end l:Initialize(
)