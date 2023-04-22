local forceChatGUI = false
local WaitForChild
WaitForChild = function(parent, childName)
	while not (parent:FindFirstChild(childName) ~= nil) do
		parent.ChildAdded:wait(0.03)
	end
	return parent[childName]
end
local IsPhone
IsPhone = function()
	local cGui = Game:GetService("CoreGui")
	local rGui = WaitForChild(cGui, "RobloxGui")
	if rGui.AbsoluteSize.Y < 600 then
		return true
	end
	return false
end
local StringTrim
StringTrim = function(str)
	return str:gsub("^%s*(.-)%s*$", "%1")
end
while not (Game.Players.LocalPlayer ~= nil) do
	wait(0.03)
end
local Player = Game.Players.LocalPlayer
while not (Player.Character ~= nil) do
	wait(0.03)
end
local Camera = Game.Workspace.CurrentCamera
local New
New = function(className, name, props)
	if not (props ~= nil) then
		props = name
		name = nil
	end
	local obj = Instance.new(className)
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
local CoreGuiService = Game:GetService("CoreGui")
local PlayersService = Game:GetService("Players")
local GuiService = Game:GetService("GuiService")
local Enums = { }
local EnumName = { }
local CreateEnum
CreateEnum = function(enumName)
	return function(t)
		local e = {
			[EnumName] = enumName
		}
		for i, name in pairs(t) do
			local item = setmetatable({
				Name = name,
				Value = i,
				Enum = e,
				[EnumName] = enumName,
			}, {
				__call = function(self, value)
					return value == self or value == self.Name or value == self.Value
				end,
				__tostring = function(self)
					return "Enum." .. tostring(self[EnumName]) .. "." .. tostring(self.Name)
				end
			})
			e[i] = item
			e[name] = item
			e[item] = item
		end
		Enums[enumName] = e
		return setmetatable(e, {
			__call = function(self, value)
				return self[value] or self[tonumber(value)]
			end,
			__index = {
				GetEnumItems = function(self)
					t = { }
					for i, item in pairs(self) do
						if type(i) == "number" then
							t[#t + 1] = item
						end
					end
					table.sort(t, function(a, b)
						return a.Value < b.Value
					end)
					return t
				end
			},
			__tostring = function(self)
				return "Enum." .. tostring(self[EnumName])
			end
		})
	end
end
local Input = {
	Mouse = Player:GetMouse(),
	Speed = 0,
	Simulating = false,
	Configuration = {
		DefaultSpeed = 1
	},
	UserIsScrolling = false
}
local Chat = {
	ChatColors = {
		BrickColor.new("Bright red"),
		BrickColor.new("Bright blue"),
		BrickColor.new("Earth green"),
		BrickColor.new("Bright violet"),
		BrickColor.new("Bright orange"),
		BrickColor.new("Bright yellow"),
		BrickColor.new("Light reddish violet"),
		BrickColor.new("Brick yellow")
	},
	Gui = nil,
	Frame = nil,
	RenderFrame = nil,
	TapToChatLabel = nil,
	ClickToChatButton = nil,
	ScrollingLock = false,
	EventListener = nil,
	MessageQueue = { },
	Configuration = {
		FontSize = Enum.FontSize.Size12,
		NumFontSize = 12,
		HistoryLength = 20,
		Size = UDim2.new(0.38, 0, 0.20, 0),
		MessageColor = Color3.new(1, 1, 1),
		AdminMessageColor = Color3.new(1, 215 / 255, 0),
		XScale = 0.025,
		LifeTime = 45,
		Position = UDim2.new(0, 2, 0.05, 0),
		DefaultTweenSpeed = 0.15
	},
	SlotPositions_List = { },
	CachedSpaceStrings_List = { },
	MouseOnFrame = false,
	GotFocus = false,
	Messages_List = { },
	MessageThread = nil,
	Admins_List = {
		"taskmanager",
		"Heliodex",
		"tako"
	},
	SafeChat_List = {
		["Use the Chat menu to talk to me."] = {
			"/sc0",
			true
		},
		["I can only see menu chats."] = {
			"/sc1",
			true
		},
		Hello = {
			Hi = {
				"/sc2_0",
				true,
				["Hi there!"] = true,
				["Hi everyone"] = true
			},
			Howdy = {
				"/sc2_1",
				true,
				["Howdy partner!"] = true
			},
			Greetings = {
				"/sc2_2",
				true,
				["Greetings everyone"] = true,
				["Greetings Robloxians!"] = true,
				["Seasons greetings!"] = true
			},
			Welcome = {
				"/sc2_3",
				true,
				["Welcome to my place"] = true,
				["Welcome to my barbeque"] = true,
				["Welcome to our base"] = true
			},
			["Hey there!"] = {
				"/sc2_4",
				true
			},
			["What's up?"] = {
				"/sc2_5",
				true,
				["How are you doing?"] = true,
				["How's it going?"] = true,
				["What's new?"] = true
			},
			["Good day"] = {
				"/sc2_6",
				true,
				["Good morning"] = true,
				["Good evening"] = true,
				["Good afternoon"] = true,
				["Good night"] = true
			},
			Silly = {
				"/sc2_7",
				true,
				["Waaaaaaaz up?!"] = true,
				["Hullo!"] = true,
				["Behold greatness, mortals!"] = true,
				["Pardon me, is this Sparta?"] = true,
				["THIS IS SPARTAAAA!"] = true
			},
			["Happy Holidays!"] = {
				"/sc2_8",
				true,
				["Happy New Year!"] = true,
				["Happy Valentine's Day!"] = true,
				["Beware the Ides of March!"] = true,
				["Happy St. Patrick's Day!"] = true,
				["Happy Easter!"] = true,
				["Happy Earth Day!"] = true,
				["Happy 4th of July!"] = true,
				["Happy Thanksgiving!"] = true,
				["Happy Halloween!"] = true,
				["Happy Hanukkah!"] = true,
				["Merry Christmas!"] = true,
				["Happy May Day!"] = true,
				["Happy Towel Day!"] = true,
				["Happy Mercury Day!"] = true,
				["Happy LOL Day!"] = true
			},
			"/sc2"
		},
		Goodbye = {
			["Good Night"] = {
				"/sc3_0",
				true,
				["Sweet dreams"] = true,
				["Go to sleep!"] = true,
				["Lights out!"] = true,
				Bedtime = true,
				["Going to bed now"] = true
			},
			Later = {
				"/sc3_1",
				true,
				["See ya later"] = true,
				["Later gator!"] = true,
				["See you tomorrow"] = true
			},
			Bye = {
				"/sc3_2",
				true,
				["Hasta la bye bye!"] = true
			},
			["I'll be right back"] = {
				"/sc3_3",
				true
			},
			["I have to go"] = {
				"/sc3_4",
				true
			},
			Farewell = {
				"/sc3_5",
				true,
				["Take care"] = true,
				["Have a nice day"] = true,
				["Goodluck!"] = true,
				["Ta-ta for now!"] = true
			},
			Peace = {
				"/sc3_6",
				true,
				["Peace out!"] = true,
				["Peace dudes!"] = true,
				["Rest in pieces!"] = true
			},
			Silly = {
				"/sc3_7",
				true,
				["To the batcave!"] = true,
				["Over and out!"] = true,
				["Happy trails!"] = true,
				["I've got to book it!"] = true,
				["Tootles!"] = true,
				["Smell you later!"] = true,
				["GG!"] = true,
				["My house is on fire! gtg."] = true
			},
			"/sc3"
		},
		Friend = {
			["Wanna be friends?"] = {
				"/sc4_0",
				true
			},
			["Follow me"] = {
				"/sc4_1",
				true,
				["Come to my place!"] = true,
				["Come to my base!"] = true,
				["Follow me, team!"] = true,
				["Follow me"] = true
			},
			["Your place is cool"] = {
				"/sc4_2",
				true,
				["Your place is fun"] = true,
				["Your place is awesome"] = true,
				["Your place looks good"] = true,
				["This place is awesome!"] = true
			},
			["Thank you"] = {
				"/sc4_3",
				true,
				["Thanks for playing"] = true,
				["Thanks for visiting"] = true,
				["Thanks for everything"] = true,
				["No, thank you"] = true,
				Thanx = true
			},
			["No problem"] = {
				"/sc4_4",
				true,
				["Don't worry"] = true,
				["That's ok"] = true,
				np = true
			},
			["You are ..."] = {
				"/sc4_5",
				true,
				["You are great!"] = true,
				["You are good!"] = true,
				["You are cool!"] = true,
				["You are funny!"] = true,
				["You are silly!"] = true,
				["You are awesome!"] = true,
				["You are doing something I don't like, please stop"] = true
			},
			["I like ..."] = {
				"/sc4_6",
				true,
				["I like your name"] = true,
				["I like your shirt"] = true,
				["I like your place"] = true,
				["I like your style"] = true,
				["I like you"] = true,
				["I like items"] = true,
				["I like money"] = true
			},
			Sorry = {
				"/sc4_7",
				true,
				["My bad!"] = true,
				["I'm sorry"] = true,
				["Whoops!"] = true,
				["Please forgive me."] = true,
				["I forgive you."] = true,
				["I didn't mean to do that."] = true,
				["Sorry, I'll stop now."] = true
			},
			"/sc4"
		},
		Questions = {
			["Who?"] = {
				"/sc5_0",
				true,
				["Who wants to be my friend?"] = true,
				["Who wants to be on my team?"] = true,
				["Who made this brilliant game?"] = true
			},
			["What?"] = {
				"/sc5_1",
				true,
				["What is your favorite animal?"] = true,
				["What is your favorite game?"] = true,
				["What is your favorite movie?"] = true,
				["What is your favorite TV show?"] = true,
				["What is your favorite music?"] = true,
				["What are your hobbies?"] = true,
				["LOLWUT?"] = true
			},
			["When?"] = {
				"/sc5_2",
				true,
				["When are you online?"] = true,
				["When is the new version coming out?"] = true,
				["When can we play again?"] = true,
				["When will your place be done?"] = true
			},
			["Where?"] = {
				"/sc5_3",
				true,
				["Where do you want to go?"] = true,
				["Where are you going?"] = true,
				["Where am I?!"] = true,
				["Where did you go?"] = true
			},
			["How?"] = {
				"/sc5_4",
				true,
				["How are you today?"] = true,
				["How did you make this cool place?"] = true,
				["LOLHOW?"] = true
			},
			["Can I..."] = {
				"/sc5_5",
				true,
				["Can I have a tour?"] = true,
				["Can I be on your team?"] = true,
				["Can I be your friend?"] = true,
				["Can I try something?"] = true,
				["Can I have that please?"] = true,
				["Can I have that back please?"] = true,
				["Can I have borrow your hat?"] = true,
				["Can I have borrow your gear?"] = true
			},
			"/sc5"
		},
		Answers = {
			["You need help?"] = {
				"/sc6_0",
				true,
				["Check out the news section"] = true,
				["Check out the help section"] = true,
				["Read the wiki!"] = true,
				["All the answers are in the wiki!"] = true,
				["I will help you with this."] = true
			},
			["Some people ..."] = {
				"/sc6_1",
				true,
				Me = true,
				["Not me"] = true,
				You = true,
				["All of us"] = true,
				["Everyone but you"] = true,
				["Builderman!"] = true,
				["Telamon!"] = true,
				["My team"] = true,
				["My group"] = true,
				Mom = true,
				Dad = true,
				Sister = true,
				Brother = true,
				Cousin = true,
				Grandparent = true,
				Friend = true
			},
			["Time ..."] = {
				"/sc6_2",
				true,
				["In the morning"] = true,
				["In the afternoon"] = true,
				["At night"] = true,
				Tomorrow = true,
				["This week"] = true,
				["This month"] = true,
				Sometime = true,
				Sometimes = true,
				["Whenever you want"] = true,
				Never = true,
				["After this"] = true,
				["In 10 minutes"] = true,
				["In a couple hours"] = true,
				["In a couple days"] = true
			},
			Animals = {
				"/sc6_3",
				true,
				Cats = {
					Lion = true,
					Tiger = true,
					Leopard = true,
					Cheetah = true
				},
				Dogs = {
					Wolves = true,
					Beagle = true,
					Collie = true,
					Dalmatian = true,
					Poodle = true,
					Spaniel = true,
					Shepherd = true,
					Terrier = true,
					Retriever = true
				},
				Horses = {
					Ponies = true,
					Stallions = true,
					Pwnyz = true
				},
				Reptiles = {
					Dinosaurs = true,
					Lizards = true,
					Snakes = true,
					["Turtles!"] = true
				},
				Hamster = true,
				Monkey = true,
				Bears = true,
				Fish = {
					Goldfish = true,
					Sharks = true,
					["Sea Bass"] = true,
					Halibut = true,
					["Tropical Fish"] = true
				},
				Birds = {
					Eagles = true,
					Penguins = true,
					Parakeets = true,
					Owls = true,
					Hawks = true,
					Pidgeons = true
				},
				Elephants = true,
				["Mythical Beasts"] = {
					Dragons = true,
					Unicorns = true,
					["Sea Serpents"] = true,
					Sphinx = true,
					Cyclops = true,
					Minotaurs = true,
					Goblins = true,
					["Honest Politicians"] = true,
					Ghosts = true,
					["Scylla and Charybdis"] = true
				}
			},
			Games = {
				"/sc6_4",
				true,
				Action = true,
				Puzzle = true,
				Strategy = true,
				Racing = true,
				RPG = true,
				["Obstacle Course"] = true,
				Tycoon = true,
				Roblox = {
					BrickBattle = true,
					["Community Building"] = true,
					["Roblox Minigames"] = true,
					["Contest Place"] = true
				},
				["Board games"] = {
					Chess = true,
					Checkers = true,
					["Settlers of Catan"] = true,
					["Tigris and Euphrates"] = true,
					["El Grande"] = true,
					Stratego = true,
					Carcassonne = true
				}
			},
			Sports = {
				"/sc6_5",
				true,
				Hockey = true,
				Soccer = true,
				Football = true,
				Baseball = true,
				Basketball = true,
				Volleyball = true,
				Tennis = true,
				["Sports team practice"] = true,
				Watersports = {
					Surfing = true,
					Swimming = true,
					["Water Polo"] = true
				},
				["Winter sports"] = {
					Skiing = true,
					Snowboarding = true,
					Sledding = true,
					Skating = true
				},
				Adventure = {
					["Rock climbing"] = true,
					Hiking = true,
					Fishing = true,
					["Horseback riding"] = true
				},
				Wacky = {
					Foosball = true,
					Calvinball = true,
					Croquet = true,
					Cricket = true,
					Dodgeball = true,
					Squash = true,
					Trampoline = true
				}
			},
			["Movies/TV"] = {
				"/sc6_6",
				true,
				["Science Fiction"] = true,
				Animated = {
					Anime = true
				},
				Comedy = true,
				Romantic = true,
				Action = true,
				Fantasy = true
			},
			Music = {
				"/sc6_7",
				true,
				Country = true,
				Jazz = true,
				Rap = true,
				["Hip-hop"] = true,
				Techno = true,
				Classical = true,
				Pop = true,
				Rock = true
			},
			Hobbies = {
				"/sc6_8",
				true,
				Computers = {
					["Building computers"] = true,
					Videogames = true,
					Coding = true,
					Hacking = true
				},
				["The Internet"] = {
					["lol. teh internets!"] = true,
					["Watching vids"] = true
				},
				Dance = true,
				Gymnastics = true,
				["Listening to music"] = true,
				["Arts and crafts"] = true,
				["Martial Arts"] = {
					Karate = true,
					Judo = true,
					["Taikwon Do"] = true,
					Wushu = true,
					["Street fighting"] = true
				},
				["Music lessons"] = {
					["Playing in my band"] = true,
					["Playing piano"] = true,
					["Playing guitar"] = true,
					["Playing violin"] = true,
					["Playing drums"] = true,
					["Playing a weird instrument"] = true
				}
			},
			Location = {
				"/sc6_9",
				true,
				USA = {
					West = {
						Alaska = true,
						Arizona = true,
						California = true,
						Colorado = true,
						Hawaii = true,
						Idaho = true,
						Montana = true,
						Nevada = true,
						["New Mexico"] = true,
						Oregon = true,
						Utah = true,
						Washington = true,
						Wyoming = true
					},
					South = {
						Alabama = true,
						Arkansas = true,
						Florida = true,
						Georgia = true,
						Kentucky = true,
						Louisiana = true,
						Mississippi = true,
						["North Carolina"] = true,
						Oklahoma = true,
						["South Carolina"] = true,
						Tennessee = true,
						Texas = true,
						Virginia = true,
						["West Virginia"] = true
					},
					Northeast = {
						Connecticut = true,
						Delaware = true,
						Maine = true,
						Maryland = true,
						Massachusetts = true,
						["New Hampshire"] = true,
						["New Jersey"] = true,
						["New York"] = true,
						Pennsylvania = true,
						["Rhode Island"] = true,
						Vermont = true
					},
					Midwest = {
						Illinois = true,
						Indiana = true,
						Iowa = true,
						Kansas = true,
						Michigan = true,
						Minnesota = true,
						Missouri = true,
						Nebraska = true,
						["North Dakota"] = true,
						Ohio = true,
						["South Dakota"] = true,
						Wisconsin = true
					}
				},
				Canada = {
					Alberta = true,
					["British Columbia"] = true,
					Manitoba = true,
					["New Brunswick"] = true,
					Newfoundland = true,
					["Northwest Territories"] = true,
					["Nova Scotia"] = true,
					Nunavut = true,
					Ontario = true,
					["Prince Edward Island"] = true,
					Quebec = true,
					Saskatchewan = true,
					Yukon = true
				},
				Mexico = true,
				["Central America"] = true,
				Europe = {
					France = true,
					Germany = true,
					Spain = true,
					Italy = true,
					Poland = true,
					Switzerland = true,
					Greece = true,
					Romania = true,
					Netherlands = true,
					["Great Britain"] = {
						England = true,
						Scotland = true,
						Wales = true,
						["Northern Ireland"] = true
					}
				},
				Asia = {
					China = true,
					India = true,
					Japan = true,
					Korea = true,
					Russia = true,
					Vietnam = true
				},
				["South America"] = {
					Argentina = true,
					Brazil = true
				},
				Africa = {
					Eygpt = true,
					Swaziland = true
				},
				Australia = true,
				["Middle East"] = true,
				Antarctica = true,
				["New Zealand"] = true
			},
			Age = {
				"/sc6_10",
				true,
				Rugrat = true,
				Kid = true,
				Tween = true,
				Teen = true,
				Twenties = true,
				Old = true,
				Ancient = true,
				Mesozoic = true,
				["I don't want to say my age. Don't ask."] = true
			},
			Mood = {
				"/sc6_11",
				true,
				Good = true,
				["Great!"] = true,
				["Not bad"] = true,
				Sad = true,
				Hyper = true,
				Chill = true,
				Happy = true,
				["Kind of mad"] = true
			},
			Boy = {
				"/sc6_12",
				true
			},
			Girl = {
				"/sc6_13",
				true
			},
			["I don't want to say boy or girl. Don't ask."] = {
				"/sc6_14",
				true
			},
			"/sc6"
		},
		Game = {
			["Let's build"] = {
				"/sc7_0",
				true
			},
			["Let's battle"] = {
				"/sc7_1",
				true
			},
			["Nice one!"] = {
				"/sc7_2",
				true
			},
			["So far so good"] = {
				"/sc7_3",
				true
			},
			["Lucky shot!"] = {
				"/sc7_4",
				true
			},
			["Oh man!"] = {
				"/sc7_5",
				true
			},
			["I challenge you to a fight!"] = {
				"/sc7_6",
				true
			},
			["Help me with this"] = {
				"/sc7_7",
				true
			},
			["Let's go to your game"] = {
				"/sc7_8",
				true
			},
			["Can you show me how do to that?"] = {
				"/sc7_9",
				true
			},
			["Backflip!"] = {
				"/sc7_10",
				true
			},
			["Frontflip!"] = {
				"/sc7_11",
				true
			},
			["Dance!"] = {
				"/sc7_12",
				true
			},
			["I'm on your side!"] = {
				"/sc7_13",
				true
			},
			["Game Commands"] = {
				"/sc7_14",
				true,
				regen = true,
				reset = true,
				go = true,
				fix = true,
				respawn = true
			},
			"/sc7"
		},
		Silly = {
			["Muahahahaha!"] = true,
			["all your base are belong to me!"] = true,
			["GET OFF MAH LAWN"] = true,
			["TEH EPIK DUCK IS COMING!!!"] = true,
			ROFL = true,
			["1337"] = {
				true,
				["i r teh pwnz0r!"] = true,
				["w00t!"] = true,
				["z0mg h4x!"] = true,
				["ub3rR0xXorzage!"] = true
			}
		},
		Yes = {
			["Absolutely!"] = true,
			["Rock on!"] = true,
			["Totally!"] = true,
			["Juice!"] = true,
			["Yay!"] = true,
			Yesh = true
		},
		No = {
			["Ummm. No."] = true,
			["..."] = true,
			["Stop!"] = true,
			["Go away!"] = true,
			["Don't do that"] = true,
			["Stop breaking the rules"] = true,
			["I don't want to"] = true
		},
		Ok = {
			["Well... ok"] = true,
			Sure = true
		},
		Uncertain = {
			Maybe = true,
			["I don't know"] = true,
			idk = true,
			["I can't decide"] = true,
			["Hmm..."] = true
		},
		[":-)"] = {
			[":-("] = true,
			[":D"] = true,
			[":-O"] = true,
			lol = true,
			["=D"] = true,
			["D="] = true,
			XD = true,
			[";D"] = true,
			[";)"] = true,
			O_O = true,
			["=)"] = true,
			["@_@"] = true,
			["&gt;_&lt;"] = true,
			T_T = true,
			["^_^"] = true,
			["<(0_0<) <(0_0)> (>0_0)> KIRBY DANCE"] = true,
			[")';"] = true,
			[":3"] = true
		},
		Ratings = {
			["Rate it!"] = true,
			["I give it a 1 out of 10"] = true,
			["I give it a 2 out of 10"] = true,
			["I give it a 3 out of 10"] = true,
			["I give it a 4 out of 10"] = true,
			["I give it a 5 out of 10"] = true,
			["I give it a 6 out of 10"] = true,
			["I give it a 7 out of 10"] = true,
			["I give it a 8 out of 10"] = true,
			["I give it a 9 out of 10"] = true,
			["I give it a 10 out of 10!"] = true
		}
	},
	CreateEnum("SafeChat")({
		"Level1",
		"Level2",
		"Level3"
	}),
	SafeChatTree = { },
	TempSpaceLabel = nil
}
local GetNameValue
GetNameValue = function(pName)
	local value = 0
	for index = 1, #pName do
		local cValue = string.byte(string.sub(pName, index, index))
		local reverseIndex = #pName - index + 1
		if #pName % 2 == 1 then
			reverseIndex = reverseIndex - 1
		end
		if reverseIndex % 4 >= 2 then
			cValue = -cValue
		end
		value = value + cValue
	end
	return value % 8
end
Chat.ComputeChatColor = function(self, pName)
	return self.ChatColors[GetNameValue(pName) + 1].Color
end
Chat.EnableScrolling = function(self, toggle)
	self.MouseOnFrame = false
	if self.RenderFrame then
		self.RenderFrame.MouseEnter:connect(function()
			local character = Player.Character
			local torso = WaitForChild(character, "Torso")
			local head = WaitForChild(character, "Head")
			if toggle then
				self.MouseOnFrame = true
				Camera.CameraType = "Scriptable"
				return Spawn(function()
					local currentRelativePos = Camera.CoordinateFrame.p - torso.Position
					while Chat.MouseOnFrame do
						Camera.CoordinateFrame = CFrame.new(torso.Position + currentRelativePos, head.Position)
						wait(0.015)
					end
				end)
			end
		end)
		return self.RenderFrame.MouseLeave:connect(function()
			Camera.CameraType = "Custom"
			self.MouseOnFrame = false
		end)
	end
end
Chat.IsTouchDevice = function(self)
	local touchEnabled = false
pcall(function()
		touchEnabled = Game:GetService("UserInputService").TouchEnabled
	end)
	return touchEnabled
end
Chat.UpdateQueue = function(self, field, diff)
	for i = #self.MessageQueue, 1, -1 do
		if self.MessageQueue[i] then
			for _, label in pairs(self.MessageQueue[i]) do
				if label and type(label) ~= "table" and type(label) ~= "number" then
					if label:IsA("TextLabel" or label:IsA("TextButton")) then
						if diff then
							label.Position = label.Position - UDim2.new(0, 0, diff, 0)
						else
							if field == self.MessageQueue[i] then
								label.Position = UDim2.new(self.Configuration.XScale, 0, label.Position.Y.Scale - field["Message"].Size.Y.Scale, 0)
								Spawn(function()
									wait(0.05)
									while label.TextTransparency >= 0 do
										label.TextTransparency = label.TextTransparency - 0.2
										wait(0.03)
									end
									if label == field["Message"] then
										label.TextStrokeTransparency = 0.8
									else
										label.TextStrokeTransparency = 1
									end
								end)
							else
								label.Position = UDim2.new(self.Configuration.XScale, 0, label.Position.Y.Scale - field["Message"].Size.Y.Scale, 0)
							end
							if label.Position.Y.Scale < -0.01 then
								label.Visible = false
								label:Destroy()
							end
						end
					end
				end
			end
		end
	end
end
Chat.CreateScrollBar = function(self) end
Chat.CheckIfInBounds = function(self, value)
	if #Chat.MessageQueue < 3 then
		return true
	end
	if value > 0 and Chat.MessageQueue[1] and Chat.MessageQueue[1]["Player"] and Chat.MessageQueue[1]["Player"].Position.Y.Scale == 0 then
		return true
	elseif value < 0 and Chat.MessageQueue[1] and Chat.MessageQueue[1]["Player"] and Chat.MessageQueue[1]["Player"].Position.Y.Scale < 0 then
		return true
	else
		return false
	end
end
Chat.ComputeSpaceString = function(self, pLabel)
	local nString = " "
	if not self.TempSpaceLabel then
		self.TempSpaceLabel = New("TextButton", "SpaceButton", {
			Size = UDim2.new(0, pLabel.AbsoluteSize.X, 0, pLabel.AbsoluteSize.Y),
			FontSize = self.Configuration.FontSize,
			Parent = self.RenderFrame,
			BackgroundTransparency = 1,
			Text = nString
		})
	else
		self.TempSpaceLabel.Text = nString
	end
	while self.TempSpaceLabel.TextBounds.X < pLabel.TextBounds.X do
		nString = nString .. " "
		self.TempSpaceLabel.Text = nString
	end
	nString = nString .. " "
	self.CachedSpaceStrings_List[pLabel.Text] = nString
	self.TempSpaceLabel.Text = ""
	return nString
end
Chat.UpdateChat = function(self, cPlayer, message)
	local messageField = {
		Player = cPlayer,
		Message = message
	}
	if coroutine.status(Chat.MessageThread) == "dead" then
		table.insert(Chat.Messages_List, messageField)
		Chat.MessageThread = coroutine.create(function()
			for i = 1, #Chat.Messages_List do
				local field = Chat.Messages_List[i]
				Chat:CreateMessage(field["Player"], field["Message"])
			end
			Chat.Messages_List = { }
		end)
		return coroutine.resume(Chat.MessageThread)
	else
		return table.insert(Chat.Messages_List, messageField)
	end
end
Chat.CreateMessage = function(self, cPlayer, message)
	local pName
	if not cPlayer then
		pName = ""
	else
		pName = cPlayer.Name
	end
	message = StringTrim(message)
	local pLabel
	local mLabel
	if #self.MessageQueue > self.Configuration.HistoryLength then
		self.MessageQueue[#self.MessageQueue] = nil
	end
	pLabel = New("TextLabel", pName, {
		Text = pName .. ":",
		FontSize = Chat.Configuration.FontSize,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		Parent = self.RenderFrame,
		TextWrapped = false,
		Size = UDim2.new(1, 0, 0.1, 0),
		BackgroundTransparency = 1,
		TextTransparency = 1,
		Position = UDim2.new(0, 0, 1, 0),
		BorderSizePixel = 0,
		TextStrokeColor3 = Color3.new(0.5, 0.5, 0.5),
		TextStrokeTransparency = 0.75
	})
	if cPlayer.Neutral then
		pLabel.TextColor3 = Chat:ComputeChatColor(pName)
	else
		pLabel.TextColor3 = cPlayer.TeamColor.Color
	end
	local nString
	if not self.CachedSpaceStrings_List[pName] then
		nString = Chat:ComputeSpaceString(pLabel)
	else
		nString = self.CachedSpaceStrings_List[pName]
	end
	mLabel = New("TextLabel", tostring(pName) .. " - message", {
		Size = UDim2.new(1, 0, 0.5, 0),
		TextColor3 = Chat.Configuration.MessageColor,
		FontSize = Chat.Configuration.FontSize,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		Text = "",
		Parent = self.RenderFrame,
		TextWrapped = true,
		BackgroundTransparency = 1,
		TextTransparency = 1,
		Position = UDim2.new(0, 0, 1, 0),
		BorderSizePixel = 0,
		TextStrokeColor3 = Color3.new(0, 0, 0)
	})
	mLabel.Text = nString .. message
	if not pName then
		pLabel.Text = ""
		mLabel.TextColor3 = Color3.new(0, 0.4, 1.0)
	end
	for _, adminName in pairs(self.Admins_List) do
		if string.lower(adminName) == string.lower(pName) then
			mLabel.TextColor3 = self.Configuration.AdminMessageColor
		end
	end
	pLabel.Visible = true
	mLabel.Visible = true
	local heightField = mLabel.TextBounds.Y
	mLabel.Size = UDim2.new(1, 0, heightField / self.RenderFrame.AbsoluteSize.Y, 0)
	pLabel.Size = mLabel.Size
	local queueField = { }
	queueField["Player"] = pLabel
	queueField["Message"] = mLabel
	queueField["SpawnTime"] = tick()
	table.insert(self.MessageQueue, 1, queueField)
	return Chat:UpdateQueue(queueField)
end
Chat.ScreenSizeChanged = function(self)
	wait()
	while self.Frame.AbsoluteSize.Y > 120 do
		self.Frame.Size = self.Frame.Size - UDim2.new(0, 0, 0.005, 0)
	end
end
Chat.FindButtonTree = function(self, scButton, rootList)
	local list = { }
	rootList = rootList or self.SafeChatTree
	for button, _ in pairs(rootList) do
		if button == scButton then
			list = rootList[button]
		elseif type(rootList[button]) == "table" then
			list = Chat:FindButtonTree(scButton, rootList[button])
		end
	end
	return list
end
Chat.ToggleSafeChatMenu = function(self, scButton)
	local list = Chat:FindButtonTree(scButton, self.SafeChatTree)
	if list then
		for button, _ in pairs(list) do
			if button:IsA("TextButton" or button:IsA("ImageButton")) then
				button.Visible = not button.Visible
			end
		end
		return true
	end
	return false
end
Chat.CreateSafeChatOptions = function(self, list, rootButton)
	local text_List = { }
	local count = 0
	text_List[rootButton] = { }
	text_List[rootButton][1] = list[1]
	rootButton = rootButton or self.SafeChatButton
	for msg, _ in pairs(list) do
		if type(msg) == "string" then
			local chatText = New("TextButton", msg, {
				Text = msg,
				Size = UDim2.new(0, 100, 0, 20),
				TextXAlignment = Enum.TextXAlignment.Center,
				TextColor3 = Color3.new(0.2, 0.1, 0.1),
				BackgroundTransparency = 0.5,
				BackgroundColor3 = Color3.new(1, 1, 1),
				Parent = self.SafeChatFrame,
				Visible = false,
				Position = UDim2.new(0, rootButton.Position.X.Scale + 105, 0, rootButton.Position.Y.Scale - (count - 3) * 100)
			})
			count = count + 1
			if type(list[msg]) == "table" then
				text_List[rootButton][chatText] = Chat:CreateSafeChatOptions(list[msg], chatText)
			end
			chatText.MouseEnter:connect(function()
				return Chat:ToggleSafeChatMenu(chatText)
			end)
			chatText.MouseLeave:connect(function()
				return Chat:ToggleSafeChatMenu(chatText)
			end)
			chatText.MouseButton1Click:connect(function()
				local lList = Chat:FindButtonTree(chatText)
				return pcall(function()
					return PlayersService:Chat(lList[1])
				end)
			end)
		end
	end
	return text_List
end
Chat.CreateSafeChatGui = function(self)
	self.SafeChatFrame = New("Frame", "SafeChatFrame", {
		Size = UDim2.new(1, 0, 1, 0),
		Parent = self.Gui,
		BackgroundTransparency = 1,
		New("ImageButton", "SafeChatButton", {
			Size = UDim2.new(0, 44, 0, 31),
			Position = UDim2.new(0, 1, 0.35, 0),
			BackgroundTransparency = 1,
			Image = "http://www.roblox.com/asset/?id=97080365"
		})
	})
	self.SafeChatButton = self.SafeChatFrame.SafeChatButton
	self.SafeChatTree[self.SafeChatButton] = Chat:CreateSafeChatOptions(self.SafeChat_List, self.SafeChatButton)
	return self.SafeChatButton.MouseButton1Click:connect(function()
		return Chat:ToggleSafeChatMenu(self.SafeChatButton)
	end)
end
Chat.FocusOnChatBar = function(self)
	if self.ClickToChatButton then
		self.ClickToChatButton.Visible = false
	end
	self.GotFocus = true
	if self.Frame["Background"] then
		self.Frame.Background.Visible = false
	end
	return self.ChatBar:CaptureFocus()
end
Chat.CreateTouchButton = function(self)
	self.ChatTouchFrame = New("Frame", "ChatTouchFrame", {
		Size = UDim2.new(0, 128, 0, 32),
		Position = UDim2.new(0, 88, 0, 0),
		BackgroundTransparency = 1,
		Parent = self.Gui,
		New("ImageButton", "ChatLabel", {
			Size = UDim2.new(0, 74, 0, 28),
			Position = UDim2.new(0, 0, 0, 0),
			BackgroundTransparency = 1,
			ZIndex = 2.0
		}),
		New("ImageLabel", "Background", {
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.new(0, 0, 0, 0),
			BackgroundTransparency = 1,
			Image = "http://www.roblox.com/asset/?id=97078724"
		})
	})
	self.TapToChatLabel = self.ChatTouchFrame.ChatLabel
	self.TouchLabelBackground = self.ChatTouchFrame.Background
	self.ChatBar = New("TextBox", "ChatBar", {
		Size = UDim2.new(1, 0, 0.2, 0),
		Position = UDim2.new(0, 0, 0.8, 800),
		Text = "",
		ZIndex = 1,
		BackgroundTransparency = 1,
		Parent = self.Frame,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextColor3 = Color3.new(1, 1, 1),
		ClearTextOnFocus = false
	})
	return self.TapToChatLabel.MouseButton1Click:connect(function()
		self.TapToChatLabel.Visible = false
		self.ChatBar:CaptureFocus()
		self.GotFocus = true
		if self.TouchLabelBackground then
			self.TouchLabelBackground.Visible = false
		end
	end)
end
Chat.CreateChatBar = function(self)
	local status, result
	status, result = pcall(function()
		return GuiService.UseLuaChat
	end)
	if forceChatGUI or (status and result) then
		self.ClickToChatButton = New("TextButton", "ClickToChat", {
			Size = UDim2.new(1, 0, 0, 20),
			BackgroundTransparency = 1,
			ZIndex = 2.0,
			Parent = self.Gui,
			Text = 'To chat click here or press "/" key',
			TextColor3 = Color3.new(1, 1, 0.9),
			Position = UDim2.new(0, 0, 1, 0),
			TextXAlignment = Enum.TextXAlignment.Left,
			FontSize = Enum.FontSize.Size12
		})
		self.ChatBar = New("TextBox", "ChatBar", {
			Size = UDim2.new(1, 0, 0, 20),
			Position = UDim2.new(0, 0, 1, 0),
			Text = "",
			ZIndex = 1,
			BackgroundColor3 = Color3.new(0, 0, 0),
			BackgroundTransparency = 0.25,
			Parent = self.Gui,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextColor3 = Color3.new(1, 1, 1),
			FontSize = Enum.FontSize.Size12,
			ClearTextOnFocus = false
		})
		local success, error
		success, error = pcall(function()
			return GuiService:SetGlobalGuiInset(0, 0, 0, 20)
		end)
		if not success then
			GuiService:SetGlobalSizeOffsetPixel(0, -20)
		end
		GuiService:AddSpecialKey(Enum.SpecialKey.ChatHotkey)
		GuiService.SpecialKeyPressed:connect(function(key)
			if key == Enum.SpecialKey.ChatHotkey then
				return Chat:FocusOnChatBar()
			end
		end)
		return self.ClickToChatButton.MouseButton1Click:connect(function()
			return Chat:FocusOnChatBar()
		end)
	end
end
Chat.CreateGui = function(self)
	self.Gui = WaitForChild(CoreGuiService, "RobloxGui")
	self.Frame = New("Frame", "ChatFrame", {
		Size = UDim2.new(0, 500, 0, 120),
		Position = UDim2.new(0, 0, 0, 5),
		BackgroundTransparency = 1,
		ZIndex = 0,
		Parent = self.Gui,
		Active = false,
		New("ImageLabel", "Background", {
			Image = "http://www.roblox.com/asset/?id=97120937",
			Size = UDim2.new(1.3, 0, 1.64, 0),
			Position = UDim2.new(0, 0, 0, 0),
			BackgroundTransparency = 1,
			ZIndex = 0,
			Visible = false
		}),
		New("Frame", "Border", {
			Size = UDim2.new(1, 0, 0, 1),
			Position = UDim2.new(0, 0, 0.8, 0),
			BackgroundTransparency = 0,
			BackgroundColor3 = Color3.new(236 / 255, 236 / 255, 236 / 255),
			BorderSizePixel = 0,
			Visible = false
		}),
		New("Frame", "ChatRenderFrame", {
			Size = UDim2.new(1.02, 0, 1.01, 0),
			Position = UDim2.new(0, 0, 0, 0),
			BackgroundTransparency = 1,
			ZIndex = 0,
			Active = false
		})
	})
	Spawn(function()
		wait(0.5)
		if IsPhone() then
			self.Frame.Size = UDim2.new(0, 280, 0, 120)
		end
	end)
	self.RenderFrame = self.Frame.ChatRenderFrame
	if Chat:IsTouchDevice() then
		self.Frame.Position = self.Configuration.Position
		self.RenderFrame.Size = UDim2.new(1, 0, 1, 0)
	elseif self.Frame.AbsoluteSize.Y > 120 then
		Chat:ScreenSizeChanged()
		self.Gui.Changed:connect(function(property)
			if property == "AbsoluteSize" then
				return Chat:ScreenSizeChanged()
			end
		end)
	end
	if forceChatGUI or Player.ChatMode == Enum.ChatMode.TextAndMenu then
		if Chat:IsTouchDevice() then
			Chat:CreateTouchButton()
		else
			Chat:CreateChatBar()
		end
		if self.ChatBar then
			return self.ChatBar.FocusLost:connect(function(enterPressed)
				Chat.GotFocus = false
				if Chat:IsTouchDevice() then
					self.ChatBar.Visible = false
					self.TapToChatLabel.Visible = true
					if self.TouchLabelBackground then
						self.TouchLabelBackground.Visible = true
					end
				end
				if enterPressed and self.ChatBar.Text ~= "" then
					local cText = self.ChatBar.Text
					if string.sub(self.ChatBar.Text, 1, 1) == "%" then
						cText = "(TEAM) " .. tostring(string.sub(cText, 2, #cText))
pcall(function()
							return PlayersService:TeamChat(cText)
						end)
					else
pcall(function()
							return PlayersService:Chat(cText)
						end)
					end
					if self.ClickToChatButton then
						self.ClickToChatButton.Visible = true
					end
					self.ChatBar.Text = ""
				end
				return Spawn(function()
					wait(5.0)
					if not Chat.GotFocus then
						Chat.Frame.Background.Visible = false
					end
				end)
			end)
		end
	end
end
Input.OnMouseScroll = function(self)
	Spawn(function()
		while Input.Speed ~= 0 do
			if Input.Speed > 1 then
				while Input.Speed > 0 do
					Input.Speed = Input.Speed - 1
					wait(0.25)
				end
			elseif Input.Speed < 0 then
				while Input.Speed < 0 do
					Input.Speed = Input.Speed + 1
					wait(0.25)
				end
			end
			wait(0.03)
		end
	end)
	if Chat:CheckIfInBounds(Input.Speed) then
		return
	end
	return Chat:ScrollQueue()
end
Input.ApplySpeed = function(self, value)
	Input.Speed = Input.Speed + value
	if not self.Simulating then
		return Input:OnMouseScroll()
	end
end
Input.Initialize = function(self)
	self.Mouse.WheelBackward:connect(function()
		return Input:ApplySpeed(self.Configuration.DefaultSpeed)
	end)
	return self.Mouse.WheelForward:connect(function()
		return Input:ApplySpeed(self.Configuration.DefaultSpeed)
	end)
end
Chat.FindMessageInSafeChat = function(self, message, list)
	local foundMessage = false
	for msg, _ in pairs(list) do
		if msg == message then
			return true
		end
		if type(list[msg]) == "table" then
			foundMessage = Chat:FindMessageInSafeChat(message, list[msg])
			if foundMessage then
				return true
			end
		end
	end
	return foundMessage
end
Chat.PlayerChatted = function(self, ...)
	local args = {
		...
	}
	local player, message
	if args[2] then
		player = args[2]
	end
	if args[3] then
		message = args[3]
		if string.sub(message, 1, 1) == "%" then
			message = "(TEAM) " .. tostring(string.sub(message, 2, #message))
		end
	end
	if PlayersService.ClassicChat then
		if not (string.sub(message, 1, 3) == "/e " or string.sub(message, 1, 7) == "/emote ") and (forceChatGUI or Player.ChatMode == Enum.ChatMode.TextAndMenu) or (Player.ChatMode == Enum.ChatMode.Menu and string.sub(message, 1, 3) == "/sc") or Chat:FindMessageInSafeChat(message, self.SafeChat_List) then
			return Chat:UpdateChat(player, message)
		end
	end
end
Chat.CullThread = function(self)
	while true do
		if #self.MessageQueue > 0 then
			for _, field in pairs(self.MessageQueue) do
				if field["SpawnTime"] and field["Player"] and field["Message"] and tick() - field["SpawnTime"] > self.Configuration.LifeTime then
					field["Player"].Visible = false
					field["Message"].Visible = false
				end
			end
		end
		wait(5.0)
	end
end
Chat.LockAllFields = function(self, gui)
	local children = gui:GetChildren()
	for i = 1, #children do
		children[i].RobloxLocked = true
		if #children[i]:GetChildren() > 0 then
			Chat:LockAllFields(children[i])
		end
	end
end
Chat.CoreGuiChanged = function(self, coreGuiType, enabled)
	if coreGuiType == Enum.CoreGuiType.Chat or coreGuiType == Enum.CoreGuiType.All then
		if self.Frame then
			self.Frame.Visible = enabled
		end
		if not Chat:IsTouchDevice() and self.ChatBar then
			self.ChatBar.Visible = enabled
			return GuiService:SetGlobalGuiInset(0, 0, 0, (function()
				if enabled then
					return 20
				else
					return 0
				end
			end)())
		end
	end
end
Chat.Initialize = function(self)
	Chat:CreateGui()
pcall(function()
		Chat:CoreGuiChanged(Enum.CoreGuiType.Chat, Game.StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Chat))
		return Game.StarterGui.CoreGuiChangedSignal:connect(function(coreGuiType, enabled)
			return Chat:CoreGuiChanged(coreGuiType, enabled)
		end)
	end)
	self.EventListener = PlayersService.PlayerChatted:connect(function(...)
		return Chat:PlayerChatted(...)
	end)
	self.MessageThread = coroutine.create(function() end)
	coroutine.resume(self.MessageThread)
	Input:Initialize()
	PlayersService.ChildAdded:connect(function()
		Chat.EventListener:disconnect()
		self.EventListener = PlayersService.PlayerChatted:connect(function(...)
			return Chat:PlayerChatted(...)
		end)
	end)
	Spawn(function()
		return Chat:CullThread()
	end)
	self.Frame.RobloxLocked = true
	Chat:LockAllFields(self.Frame)
	return self.Frame.DescendantAdded:connect(function(descendant)
		return Chat:LockAllFields(descendant)
	end)
end
return Chat:Initialize()
