local a=false local function WaitForChild(b,c)while b:FindFirstChild(c)==nil do
b.ChildAdded:wait(0.03)end return b[c]end local function typedef(b)return b end
local function IsPhone()local b=Game:GetService'CoreGui'local c=WaitForChild(b,
'RobloxGui')if c.AbsoluteSize.Y<600 then return true end return false end
local function StringTrim(b)return(b:gsub('^%s*(.-)%s*$','%1'))end while Game.
Players.LocalPlayer==nil do wait(0.03)end local b=Game.Players.LocalPlayer while
b.Character==nil do wait(0.03)end local c=LoadLibrary'RbxUtility'local d,e,f,g,h
,i=typedef(c),Game.Workspace.CurrentCamera,Game:GetService'CoreGui',Game:
GetService'Players',Game:GetService'GuiService',nil do i={}local j={}local k,l={
__call=function(k,l)return k[l]or k[tonumber(l)]end,__index={GetEnumItems=
function(k)local l={}for m,n in pairs(k)do if type(m)=='number'then l[#l+1]=n
end end table.sort(l,function(o,p)return o.Value<p.Value end)return l end},
__tostring=function(k)return'Enum.'..k[j]end},{__call=function(k,l)return l==k
or l==k.Name or l==k.Value end,__tostring=function(k)return'Enum.'..k[j]..'.'..k
.Name end}function CreateEnum(m)return function(n)local o={[j]=m}for p,q in
pairs(n)do local r=setmetatable({Name=q,Value=p,Enum=o,[j]=m},l)o[p]=r o[q]=r o[
r]=r end i[m]=o return setmetatable(o,k)end end end local j,k={Mouse=b:GetMouse(
),Speed=0,Simulating=false,Configuration={DefaultSpeed=1},UserIsScrolling=false}
,{ChatColors={BrickColor.new'Bright red',BrickColor.new'Bright blue',BrickColor.
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
'I give it a 10 out of 10!']=true}},CreateEnum'SafeChat'{'Level1','Level2',
'Level3'},SafeChatTree={},TempSpaceLabel=nil}local function GetNameValue(l)local
m=0 for n=1,#l do local o,p=string.byte(string.sub(l,n,n)),#l-n+1 if#l%2==1 then
p=p-1 end if p%4>=2 then o=-o end m=m+o end return m%8 end function k:
ComputeChatColor(l)return self.ChatColors[GetNameValue(l)+1].Color end function
k:EnableScrolling(l)self.MouseOnFrame=false if self.RenderFrame then self.
RenderFrame.MouseEnter:connect(function()local m=b.Character local n,o=
WaitForChild(m,'Torso'),WaitForChild(m,'Head')if l then self.MouseOnFrame=true e
.CameraType='Scriptable'Spawn(function()local p=e.CoordinateFrame.p-n.Position
while k.MouseOnFrame do e.CoordinateFrame=CFrame.new(n.Position+p,o.Position)
wait(0.015)end end)end end)self.RenderFrame.MouseLeave:connect(function()e.
CameraType='Custom'self.MouseOnFrame=false end)end end function k:IsTouchDevice(
)local l=false pcall(function()l=Game:GetService'UserInputService'.TouchEnabled
end)return l end function k:UpdateQueue(l,m)for n=#self.MessageQueue,1,-1 do if
self.MessageQueue[n]then for o,p in pairs(self.MessageQueue[n])do if p and type(
p)~='table'and type(p)~='number'then if p:IsA'TextLabel'or p:IsA'TextButton'then
if m then p.Position=p.Position-UDim2.new(0,0,m,0)else if l==self.MessageQueue[n
]then p.Position=UDim2.new(self.Configuration.XScale,0,p.Position.Y.Scale-l[
'Message'].Size.Y.Scale,0)Spawn(function()wait(0.05)while p.TextTransparency>=0
do p.TextTransparency=p.TextTransparency-0.2 wait(0.03)end if p==l['Message']
then p.TextStrokeTransparency=0.8 else p.TextStrokeTransparency=1 end end)else p
.Position=UDim2.new(self.Configuration.XScale,0,p.Position.Y.Scale-l['Message'].
Size.Y.Scale,0)end if p.Position.Y.Scale<-1E-2 then p.Visible=false p:Destroy()
end end end end end end end end function k:CreateScrollBar()end function k:
CheckIfInBounds(l)if#k.MessageQueue<3 then return true end if l>0 and k.
MessageQueue[1]and k.MessageQueue[1]['Player']and k.MessageQueue[1]['Player'].
Position.Y.Scale==0 then return true elseif l<0 and k.MessageQueue[1]and k.
MessageQueue[1]['Player']and k.MessageQueue[1]['Player'].Position.Y.Scale<0 then
return true else return false end return false end function k:ComputeSpaceString
(l)local m=' 'if not self.TempSpaceLabel then self.TempSpaceLabel=d.Create
'TextButton'{Size=UDim2.new(0,l.AbsoluteSize.X,0,l.AbsoluteSize.Y),FontSize=self
.Configuration.FontSize,Parent=self.RenderFrame,BackgroundTransparency=1,Text=m,
Name='SpaceButton'}else self.TempSpaceLabel.Text=m end while self.TempSpaceLabel
.TextBounds.X<l.TextBounds.X do m=m..' 'self.TempSpaceLabel.Text=m end m=m..' '
self.CachedSpaceStrings_List[l.Text]=m self.TempSpaceLabel.Text=''return m end
function k:UpdateChat(l,m)local n={['Player']=l,['Message']=m}if coroutine.
status(k.MessageThread)=='dead'then table.insert(k.Messages_List,n)k.
MessageThread=coroutine.create(function()for o=1,#k.Messages_List do local p=k.
Messages_List[o]k:CreateMessage(p['Player'],p['Message'])end k.Messages_List={}
end)coroutine.resume(k.MessageThread)else table.insert(k.Messages_List,n)end end
function k:RecalculateSpacing()end function k:CreateMessage(l,m)local n if not l
then n=''else n=l.Name end m=StringTrim(m)local o,p if#self.MessageQueue>self.
Configuration.HistoryLength then self.MessageQueue[#self.MessageQueue]=nil end o
=d.Create'TextLabel'{Name=n,Text=n..':',FontSize=k.Configuration.FontSize,
TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top,
Parent=self.RenderFrame,TextWrapped=false,Size=UDim2.new(1,0,0.1,0),
BackgroundTransparency=1,TextTransparency=1,Position=UDim2.new(0,0,1,0),
BorderSizePixel=0,TextStrokeColor3=Color3.new(0.5,0.5,0.5),
TextStrokeTransparency=0.75}if l.Neutral then o.TextColor3=k:ComputeChatColor(n)
else o.TextColor3=l.TeamColor.Color end local q if not self.
CachedSpaceStrings_List[n]then q=k:ComputeSpaceString(o)else q=self.
CachedSpaceStrings_List[n]end p=d.Create'TextLabel'{Name=n..' - message',Size=
UDim2.new(1,0,0.5,0),TextColor3=k.Configuration.MessageColor,FontSize=k.
Configuration.FontSize,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=
Enum.TextYAlignment.Top,Text='',Parent=self.RenderFrame,TextWrapped=true,
BackgroundTransparency=1,TextTransparency=1,Position=UDim2.new(0,0,1,0),
BorderSizePixel=0,TextStrokeColor3=Color3.new(0,0,0)}p.Text=q..m if not n then o
.Text=''p.TextColor3=Color3.new(0,0.4,1)end for r,s in pairs(self.Admins_List)do
if string.lower(s)==string.lower(n)then p.TextColor3=self.Configuration.
AdminMessageColor end end o.Visible=true p.Visible=true local t=p.TextBounds.Y p
.Size=UDim2.new(1,0,t/self.RenderFrame.AbsoluteSize.Y,0)o.Size=p.Size local u={}
u['Player']=o u['Message']=p u['SpawnTime']=tick()table.insert(self.MessageQueue
,1,u)k:UpdateQueue(u)end function k:ScreenSizeChanged()wait()while self.Frame.
AbsoluteSize.Y>120 do self.Frame.Size=self.Frame.Size-UDim2.new(0,0,0.005,0)end
k:RecalculateSpacing()end function k:FindButtonTree(l,m)local n={}m=m or self.
SafeChatTree for o,p in pairs(m)do if o==l then n=m[o]elseif type(m[o])=='table'
then n=k:FindButtonTree(l,m[o])end end return n end function k:
ToggleSafeChatMenu(l)local m=k:FindButtonTree(l,self.SafeChatTree)if m then for
n,o in pairs(m)do if n:IsA'TextButton'or n:IsA'ImageButton'then n.Visible=not n.
Visible end end return true end return false end function k:
CreateSafeChatOptions(l,m)local n,o={},0 n[m]={}n[m][1]=l[1]m=m or self.
SafeChatButton for p,q in pairs(l)do if type(p)=='string'then local r=d.Create
'TextButton'{Name=p,Text=p,Size=UDim2.new(0,100,0,20),TextXAlignment=Enum.
TextXAlignment.Center,TextColor3=Color3.new(0.2,0.1,0.1),BackgroundTransparency=
0.5,BackgroundColor3=Color3.new(1,1,1),Parent=self.SafeChatFrame,Visible=false,
Position=UDim2.new(0,m.Position.X.Scale+105,0,m.Position.Y.Scale-((o-3)*100))}o=
o+1 if type(l[p])=='table'then n[m][r]=k:CreateSafeChatOptions(l[p],r)end r.
MouseEnter:connect(function()k:ToggleSafeChatMenu(r)end)r.MouseLeave:connect(
function()k:ToggleSafeChatMenu(r)end)r.MouseButton1Click:connect(function()local
s=k:FindButtonTree(r)pcall(function()g:Chat(s[1])end)end)end end return n end
function k:CreateSafeChatGui()self.SafeChatFrame=d.Create'Frame'{Name=
'SafeChatFrame',Size=UDim2.new(1,0,1,0),Parent=self.Gui,BackgroundTransparency=1
,d.Create'ImageButton'{Name='SafeChatButton',Size=UDim2.new(0,44,0,31),Position=
UDim2.new(0,1,0.35,0),BackgroundTransparency=1,Image=
'http://www.roblox.com/asset/?id=97080365'}}self.SafeChatButton=self.
SafeChatFrame.SafeChatButton self.SafeChatTree[self.SafeChatButton]=k:
CreateSafeChatOptions(self.SafeChat_List,self.SafeChatButton)self.SafeChatButton
.MouseButton1Click:connect(function()k:ToggleSafeChatMenu(self.SafeChatButton)
end)end function k:FocusOnChatBar()if self.ClickToChatButton then self.
ClickToChatButton.Visible=false end self.GotFocus=true if self.Frame[
'Background']then self.Frame.Background.Visible=false end self.ChatBar:
CaptureFocus()end function k:CreateTouchButton()self.ChatTouchFrame=d.Create
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
Visible=false end end)end function k:CreateChatBar()local l,m=pcall(function()
return h.UseLuaChat end)if a or(l and m)then self.ClickToChatButton=d.Create
'TextButton'{Name='ClickToChat',Size=UDim2.new(1,0,0,20),BackgroundTransparency=
1,ZIndex=2,Parent=self.Gui,Text='To chat click here or press "/" key',TextColor3
=Color3.new(1,1,0.9),Position=UDim2.new(0,0,1,0),TextXAlignment=Enum.
TextXAlignment.Left,FontSize=Enum.FontSize.Size12}self.ChatBar=d.Create'TextBox'
{Name='ChatBar',Size=UDim2.new(1,0,0,20),Position=UDim2.new(0,0,1,0),Text='',
ZIndex=1,BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=0.25,Parent=
self.Gui,TextXAlignment=Enum.TextXAlignment.Left,TextColor3=Color3.new(1,1,1),
FontSize=Enum.FontSize.Size12,ClearTextOnFocus=false}local n,o=pcall(function()h
:SetGlobalGuiInset(0,0,0,20)end)if not n then h:SetGlobalSizeOffsetPixel(0,-20)
end h:AddSpecialKey(Enum.SpecialKey.ChatHotkey)h.SpecialKeyPressed:connect(
function(p)if p==Enum.SpecialKey.ChatHotkey then k:FocusOnChatBar()end end)self.
ClickToChatButton.MouseButton1Click:connect(function()k:FocusOnChatBar()end)end
end function k:CreateGui()self.Gui=WaitForChild(f,'RobloxGui')self.Frame=d.
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
end end)self.RenderFrame=self.Frame.ChatRenderFrame if k:IsTouchDevice()then
self.Frame.Position=self.Configuration.Position self.RenderFrame.Size=UDim2.new(
1,0,1,0)elseif self.Frame.AbsoluteSize.Y>120 then k:ScreenSizeChanged()self.Gui.
Changed:connect(function(l)if l=='AbsoluteSize'then k:ScreenSizeChanged()end end
)end if a or b.ChatMode==Enum.ChatMode.TextAndMenu then if k:IsTouchDevice()then
k:CreateTouchButton()else k:CreateChatBar()end if self.ChatBar then self.ChatBar
.FocusLost:connect(function(l)k.GotFocus=false if k:IsTouchDevice()then self.
ChatBar.Visible=false self.TapToChatLabel.Visible=true if self.
TouchLabelBackground then self.TouchLabelBackground.Visible=true end end if l
and self.ChatBar.Text~=''then local m=self.ChatBar.Text if string.sub(self.
ChatBar.Text,1,1)=='%'then m='(TEAM) '..string.sub(m,2,#m)pcall(function()g:
TeamChat(m)end)else pcall(function()g:Chat(m)end)end if self.ClickToChatButton
then self.ClickToChatButton.Visible=true end self.ChatBar.Text=''end Spawn(
function()wait(5)if not k.GotFocus then k.Frame.Background.Visible=false end end
)end)end end end function j:OnMouseScroll()Spawn(function()while j.Speed~=0 do
if j.Speed>1 then while j.Speed>0 do j.Speed=j.Speed-1 wait(0.25)end elseif j.
Speed<0 then while j.Speed<0 do j.Speed=j.Speed+1 wait(0.25)end end wait(0.03)
end end)if k:CheckIfInBounds(j.Speed)then return end k:ScrollQueue()end function
j:ApplySpeed(l)j.Speed=j.Speed+l if not self.Simulating then j:OnMouseScroll()
end end function j:Initialize()self.Mouse.WheelBackward:connect(function()j:
ApplySpeed(self.Configuration.DefaultSpeed)end)self.Mouse.WheelForward:connect(
function()j:ApplySpeed(self.Configuration.DefaultSpeed)end)end function k:
FindMessageInSafeChat(l,m)local n=false for o,p in pairs(m)do if o==l then
return true end if type(m[o])=='table'then n=k:FindMessageInSafeChat(l,m[o])if n
then return true end end end return n end function k:PlayerChatted(...)local l,m
,n={...},nil,nil if l[2]then m=l[2]end if l[3]then n=l[3]if string.sub(n,1,1)==
'%'then n='(TEAM) '..string.sub(n,2,#n)end end if g.ClassicChat then if not(
string.sub(n,1,3)=='/e 'or string.sub(n,1,7)=='/emote ')and(a or b.ChatMode==
Enum.ChatMode.TextAndMenu)or(b.ChatMode==Enum.ChatMode.Menu and string.sub(n,1,3
)=='/sc')or(k:FindMessageInSafeChat(n,self.SafeChat_List))then k:UpdateChat(m,n)
end end end function k:CullThread()while true do if#self.MessageQueue>0 then for
l,m in pairs(self.MessageQueue)do if m['SpawnTime']and m['Player']and m[
'Message']and tick()-m['SpawnTime']>self.Configuration.LifeTime then m['Player']
.Visible=false m['Message'].Visible=false end end end wait(5)end end function k:
LockAllFields(l)local m=l:GetChildren()for n=1,#m do m[n].RobloxLocked=true if#m
[n]:GetChildren()>0 then k:LockAllFields(m[n])end end end function k:
CoreGuiChanged(l,m)if l==Enum.CoreGuiType.Chat or l==Enum.CoreGuiType.All then
if self.Frame then self.Frame.Visible=m end if not k:IsTouchDevice()and self.
ChatBar then self.ChatBar.Visible=m if m then h:SetGlobalGuiInset(0,0,0,20)else
h:SetGlobalGuiInset(0,0,0,0)end end end end function k:Initialize()k:CreateGui()
pcall(function()k:CoreGuiChanged(Enum.CoreGuiType.Chat,Game.StarterGui:
GetCoreGuiEnabled(Enum.CoreGuiType.Chat))Game.StarterGui.CoreGuiChangedSignal:
connect(function(l,m)k:CoreGuiChanged(l,m)end)end)self.EventListener=g.
PlayerChatted:connect(function(...)k:PlayerChatted(...)end)self.MessageThread=
coroutine.create(function()end)coroutine.resume(self.MessageThread)j:Initialize(
)g.ChildAdded:connect(function()k.EventListener:disconnect()self.EventListener=g
.PlayerChatted:connect(function(...)k:PlayerChatted(...)end)end)Spawn(function()
k:CullThread()end)self.Frame.RobloxLocked=true k:LockAllFields(self.Frame)self.
Frame.DescendantAdded:connect(function(l)k:LockAllFields(l)end)end k:Initialize(
)