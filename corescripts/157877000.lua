--Include
local Create = assert(LoadLibrary("RbxUtility")).Create

-- A Few Script Globals
local gui
if script.Parent:FindFirstChild("ControlFrame") then
	gui = script.Parent:FindFirstChild("ControlFrame")
else
	gui = script.Parent
end

-- Dev-Console Root

local Dev_Container = Create'Frame'{
	Name = 'DevConsoleContainer';
	Parent = gui;
	BackgroundColor3 = Color3.new(0,0,0);
	BackgroundTransparency = 0.9;
	Position = UDim2.new(0, 100, 0, 10);
	Size = UDim2.new(0.5, 20, 0.5, 20);
	Visible = false;
	BackgroundTransparency = 0.9;
}

local ToggleConsole = Create'BindableFunction'{
	Name = 'ToggleDevConsole';
	Parent = gui
}


local devConsoleInitialized = false
function initializeDeveloperConsole()
	if devConsoleInitialized then
		return
	end
	devConsoleInitialized = true

	---Dev-Console Variables
	local LOCAL_CONSOLE = 1
	local SERVER_CONSOLE = 2

	local MAX_LIST_SIZE = 1000

	local minimumSize = Vector2.new(245, 180)
	local currentConsole = LOCAL_CONSOLE

	local localMessageList = {}
	local serverMessageList = {}

	local localOffset = 0
	local serverOffset = 0
	
	local errorToggleOn = true
	local warningToggleOn = true
	local infoToggleOn = true
	local outputToggleOn = true
	local wordWrapToggleOn = false
	
	local textHolderSize = 0
	
	local frameNumber = 0

	--Create Dev-Console

	local Dev_Body = Create'Frame'{
		Name = 'Body';
		Parent = Dev_Container;
		BackgroundColor3 = Color3.new(0,0,0);
		BackgroundTransparency = 0.5;
		Position = UDim2.new(0, 0, 0, 21);
		Size = UDim2.new(1, 0, 1, -25);
	}
	
	local Dev_OptionsHolder = Create'Frame'{
		Name = 'OptionsHolder';
		Parent = Dev_Body;
		BackgroundColor3 = Color3.new(0,0,0);
		BackgroundTransparency = 1.0;
		Position = UDim2.new(0, 220, 0, 0);
		Size = UDim2.new(1, -255, 0, 24);
		ClipsDescendants = true
	}
	
	local Dev_OptionsBar = Create'Frame'{
		Name = 'OptionsBar';
		Parent = Dev_OptionsHolder;
		BackgroundColor3 = Color3.new(0,0,0);
		BackgroundTransparency = 1.0;
		Position = UDim2.new(0.0, -250, 0, 4);
		Size = UDim2.new(0, 234, 0, 18);
	}
	
	local Dev_ErrorToggleFilter = Create'TextButton'{
		Name = 'ErrorToggleButton';
		Parent = Dev_OptionsBar;
		BackgroundColor3 = Color3.new(0,0,0);
		BorderColor3 = Color3.new(1.0, 0, 0);
		Position = UDim2.new(0, 115, 0, 0);
		Size = UDim2.new(0, 18, 0, 18);
		Font = "SourceSansBold";
		FontSize = Enum.FontSize.Size14;
		Text = "";
		TextColor3 = Color3.new(1.0, 0, 0);
	}	
	
	Create'Frame'{
		Name = 'CheckFrame';
		Parent = Dev_ErrorToggleFilter;
		BackgroundColor3 = Color3.new(1.0,0,0);
		BorderColor3 = Color3.new(1.0, 0, 0);
		Position = UDim2.new(0, 4, 0, 4);
		Size = UDim2.new(0, 10, 0, 10);
	}
	
	local Dev_InfoToggleFilter = Create'TextButton'{
		Name = 'InfoToggleButton';
		Parent = Dev_OptionsBar;
		BackgroundColor3 = Color3.new(0,0,0);
		BorderColor3 = Color3.new(0.4, 0.5, 1.0);
		Position = UDim2.new(0, 65, 0, 0);
		Size = UDim2.new(0, 18, 0, 18);
		Font = "SourceSansBold";
		FontSize = Enum.FontSize.Size14;
		Text = "";
		TextColor3 = Color3.new(0.4, 0.5, 1.0);
	}
	
	Create'Frame'{
		Name = 'CheckFrame';
		Parent = Dev_InfoToggleFilter;
		BackgroundColor3 = Color3.new(0.4, 0.5, 1.0);
		BorderColor3 = Color3.new(0.4, 0.5, 1.0);
		Position = UDim2.new(0, 4, 0, 4);
		Size = UDim2.new(0, 10, 0, 10);
	}
	
	local Dev_OutputToggleFilter = Create'TextButton'{
		Name = 'OutputToggleButton';
		Parent = Dev_OptionsBar;
		BackgroundColor3 = Color3.new(0,0,0);
		BorderColor3 = Color3.new(1.0, 1.0, 1.0);
		Position = UDim2.new(0, 40, 0, 0);
		Size = UDim2.new(0, 18, 0, 18);
		Font = "SourceSansBold";
		FontSize = Enum.FontSize.Size14;
		Text = "";
		TextColor3 = Color3.new(1.0, 1.0, 1.0);
	}
	
	Create'Frame'{
		Name = 'CheckFrame';
		Parent = Dev_OutputToggleFilter;
		BackgroundColor3 = Color3.new(1.0, 1.0, 1.0);
		BorderColor3 = Color3.new(1.0, 1.0, 1.0);
		Position = UDim2.new(0, 4, 0, 4);
		Size = UDim2.new(0, 10, 0, 10);
	}
	
	local Dev_WarningToggleFilter = Create'TextButton'{
		Name = 'WarningToggleButton';
		Parent = Dev_OptionsBar;
		BackgroundColor3 = Color3.new(0,0,0);
		BorderColor3 = Color3.new(1.0, 0.6, 0.4);
		Position = UDim2.new(0, 90, 0, 0);
		Size = UDim2.new(0, 18, 0, 18);
		Font = "SourceSansBold";
		FontSize = Enum.FontSize.Size14;
		Text = "";
		TextColor3 = Color3.new(1.0, 0.6, 0.4);
	}
	
	Create'Frame'{
		Name = 'CheckFrame';
		Parent = Dev_WarningToggleFilter;
		BackgroundColor3 = Color3.new(1.0, 0.6, 0.4);
		BorderColor3 = Color3.new(1.0, 0.6, 0.4);
		Position = UDim2.new(0, 4, 0, 4);
		Size = UDim2.new(0, 10, 0, 10);
	}
	
	local Dev_WordWrapToggle = Create'TextButton'{
		Name = 'WordWrapToggleButton';
		Parent = Dev_OptionsBar;
		BackgroundColor3 = Color3.new(0,0,0);
		BorderColor3 = Color3.new(0.8, 0.8, 0.8);
		Position = UDim2.new(0, 215, 0, 0);
		Size = UDim2.new(0, 18, 0, 18);
		Font = "SourceSansBold";
		FontSize = Enum.FontSize.Size14;
		Text = "";
		TextColor3 = Color3.new(0.8, 0.8, 0.8);
	}
	
	Create'Frame'{
		Name = 'CheckFrame';
		Parent = Dev_WordWrapToggle;
		BackgroundColor3 = Color3.new(0.8, 0.8, 0.8);
		BorderColor3 = Color3.new(0.8, 0.8, 0.8);
		Position = UDim2.new(0, 4, 0, 4);
		Size = UDim2.new(0, 10, 0, 10);
		Visible = false
	}
	
	Create'TextLabel'{
		Name = 'Filter';
		Parent = Dev_OptionsBar;
		BackgroundTransparency = 1.0;
		Position = UDim2.new(0, 0, 0, 0);
		Size = UDim2.new(0, 40, 0, 18);
		Font = "SourceSansBold";
		FontSize = Enum.FontSize.Size14;
		Text = "Filter";
		TextColor3 = Color3.new(1, 1, 1);
	}
	
	Create'TextLabel'{
		Name = 'WordWrap';
		Parent = Dev_OptionsBar;
		BackgroundTransparency = 1;
		Position = UDim2.new(0, 150, 0, 0);
		Size = UDim2.new(0, 50, 0, 18);
		Font = "SourceSansBold";
		FontSize = Enum.FontSize.Size14;
		Text = "Word Wrap";
		TextColor3 = Color3.new(1, 1, 1);
	}

	local Dev_ScrollBar = Create'Frame'{
		Name = 'ScrollBar';
		Parent = Dev_Body;
		BackgroundColor3 = Color3.new(0,0,0);
		BackgroundTransparency = 0.9;
		Position = UDim2.new(1, -20, 0, 26);
		Size = UDim2.new(0, 20, 1, -50);
		Visible = false;
		BackgroundTransparency = 0.9;
	}

	local Dev_ScrollArea = Create'Frame'{
		Name = 'ScrollArea';
		Parent = Dev_ScrollBar;
		BackgroundTransparency = 1;
		Position = UDim2.new(0, 0, 0, 23);
		Size = UDim2.new(1, 0, 1, -46);
		BackgroundTransparency = 1;
	}

	local Dev_Handle = Create'ImageButton'{
		Name = 'Handle';
		Parent = Dev_ScrollArea;
		BackgroundColor3 = Color3.new(0,0,0);
		BackgroundTransparency = 0.5;
		Position = UDim2.new(0, 0, .2, 0);
		Size = UDim2.new(0, 20, 0, 40);
		BackgroundTransparency = 0.5;
	}
	
	Create'ImageLabel'{
		Name = 'ImageLabel';
		Parent = Dev_Handle;
		BackgroundTransparency = 1;
		Position = UDim2.new(0, 0, 0.5, -8);
		Rotation = 180;
		Size = UDim2.new(1, 0, 0, 16);
		Image = "http://www.roblox.com/Asset?id=151205881";
	}

	local Dev_DownButton = Create'ImageButton'{
		Name = 'Down';
		Parent = Dev_ScrollBar;
		BackgroundColor3 = Color3.new(0,0,0);
		BackgroundTransparency = 0.5;
		Position = UDim2.new(0, 0, 1, -20);
		Size = UDim2.new(0, 20, 0, 20);
		BackgroundTransparency = 0.5;
	}

	Create'ImageLabel'{
		Name = 'ImageLabel';
		Parent = Dev_DownButton;
		BackgroundTransparency = 1;
		Position = UDim2.new(0, 3, 0, 3);
		Size = UDim2.new(0, 14, 0, 14);
		Rotation = 180;
		Image = "http://www.roblox.com/Asset?id=151205813";
	}

	local Dev_UpButton = Create'ImageButton'{
		Name = 'Up';
		Parent = Dev_ScrollBar;
		BackgroundColor3 = Color3.new(0,0,0);
		BackgroundTransparency = 0.5;
		Position = UDim2.new(0, 0, 0, 0);
		Size = UDim2.new(0, 20, 0, 20);
	}

	Create'ImageLabel'{
		Name = 'ImageLabel';
		Parent = Dev_UpButton;
		BackgroundTransparency = 1;
		Position = UDim2.new(0, 3, 0, 3);
		Size = UDim2.new(0, 14, 0, 14);
		Image = "http://www.roblox.com/Asset?id=151205813";
	}

	local Dev_TextBox = Create'Frame'{
		Name = 'TextBox';
		Parent = Dev_Body;
		BackgroundColor3 = Color3.new(0,0,0);
		BackgroundTransparency = 0.6;
		Position = UDim2.new(0, 2, 0, 26);
		Size = UDim2.new(1, -4, 1, -28);
		ClipsDescendants = true;
	}

	local Dev_TextHolder = Create'Frame'{
		Name = 'TextHolder';
		Parent = Dev_TextBox;
		BackgroundTransparency = 1;
		Position = UDim2.new(0, 0, 0, 0);
		Size = UDim2.new(1, 0, 1, 0);
	}
	
	local Dev_OptionsButton = Create'ImageButton'{
		Name = 'OptionsButton';
		Parent = Dev_Body;
		BackgroundColor3 = Color3.new(0,0,0);
		BackgroundTransparency = 1.0;
		Position = UDim2.new(0, 200, 0, 2);
		Size = UDim2.new(0, 20, 0, 20);
	}
	
	Create'ImageLabel'{
		Name = 'ImageLabel';
		Parent = Dev_OptionsButton;
		BackgroundTransparency = 1.0;
		Position = UDim2.new(0, 0, 0, 0);
		Size = UDim2.new(1, 0, 1, 0);
		Rotation = 0;
		Image = "http://www.roblox.com/Asset?id=152093917";
	}

	local Dev_ResizeButton = Create'ImageButton'{
		Name = 'ResizeButton';
		Parent = Dev_Body;
		BackgroundColor3 = Color3.new(0,0,0);
		BackgroundTransparency = 0.5;
		Position = UDim2.new(1, -20, 1, -20);
		Size = UDim2.new(0, 20, 0, 20);
	}
	
	Create'ImageLabel'{
		Name = 'ImageLabel';
		Parent = Dev_ResizeButton;
		BackgroundTransparency = 1;
		Position = UDim2.new(0, 6, 0, 6);
		Size = UDim2.new(0.8, 0, 0.8, 0);
		Rotation = 135;
		Image = "http://www.roblox.com/Asset?id=151205813";
	}

	Create'TextButton'{
		Name = 'LocalConsole';
		Parent = Dev_Body;
		BackgroundColor3 = Color3.new(0,0,0);
		BackgroundTransparency = 0.6;
		Position = UDim2.new(0, 7, 0, 5);
		Size = UDim2.new(0, 90, 0, 20);
		Font = "SourceSansBold";
		FontSize = Enum.FontSize.Size14;
		Text = "Local Console";
		TextColor3 = Color3.new(1, 1, 1);
		TextYAlignment = Enum.TextYAlignment.Center;
	}

	Create'TextButton'{
		Name = 'ServerConsole';
		Parent = Dev_Body;
		BackgroundColor3 = Color3.new(0,0,0);
		BackgroundTransparency = 0.8;
		Position = UDim2.new(0, 102, 0, 5);
		Size = UDim2.new(0, 90, 0, 17);
		Font = "SourceSansBold";
		FontSize = Enum.FontSize.Size14;
		Text = "Server Console";
		TextColor3 = Color3.new(1, 1, 1);
		TextYAlignment = Enum.TextYAlignment.Center;
	}

	local Dev_TitleBar = Create'Frame'{
		Name = 'TitleBar';
		Parent = Dev_Container;
		BackgroundColor3 = Color3.new(0,0,0);
		BackgroundTransparency = 0.5;
		Position = UDim2.new(0, 0, 0, 0);
		Size = UDim2.new(1, 0, 0, 20);
	}

	local Dev_CloseButton = Create'ImageButton'{
		Name = 'CloseButton';
		Parent = Dev_TitleBar;
		BackgroundColor3 = Color3.new(0,0,0);
		BackgroundTransparency = 0.5;
		Position = UDim2.new(1, -20, 0, 0);
		Size = UDim2.new(0, 20, 0, 20);
	}
	
	Create'ImageLabel'{
		Parent = Dev_CloseButton;
		BackgroundColor3 = Color3.new(0,0,0);
		BackgroundTransparency = 1;
		Position = UDim2.new(0, 3, 0, 3);
		Size = UDim2.new(0, 14, 0, 14);
		Image = "http://www.roblox.com/Asset?id=151205852";
	}

	Create'TextButton'{
		Name = 'TextButton';
		Parent = Dev_TitleBar;
		BackgroundColor3 = Color3.new(0,0,0);
		BackgroundTransparency = 0.5;
		Position = UDim2.new(0, 0, 0, 0);
		Size = UDim2.new(1, -23, 1, 0);
		Text = "";
	}

	Create'TextLabel'{
		Name = 'TitleText';
		Parent = Dev_TitleBar;
		BackgroundTransparency = 1;
		Position = UDim2.new(0, 0, 0, 0);
		Size = UDim2.new(0, 185, 0, 20);
		Font = "SourceSansBold";
		FontSize = Enum.FontSize.Size18;
		Text = "Server Console";
		TextColor3 = Color3.new(1, 1, 1);
		Text = "Roblox Developer Console";
		TextYAlignment = Enum.TextYAlignment.Top;
	}

	---Saved Mouse Information
	local previousMousePos = nil
	local pPos = nil

	local previousMousePosResize = nil
	local pSize = nil

	local previousMousePosScroll = nil
	local pScrollHandle = nil
	local pOffset = nil

	local scrollUpIsDown = false
	local scrollDownIsDown = false

	function clean()
		previousMousePos = nil
		pPos = nil
		previousMousePosResize = nil
		pSize = nil
		previousMousePosScroll = nil
		pScrollHandle = nil
		pOffset = nil
		scrollUpIsDown = false
		scrollDownIsDown = false
	end


	---Handle Dev-Console Position
	function refreshConsolePosition(x, y)
		if not previousMousePos then
			return
		end
		
		local delta = Vector2.new(x, y) - previousMousePos
		Dev_Container.Position = UDim2.new(0, pPos.X + delta.X, 0, pPos.Y + delta.Y)
	end

	Dev_TitleBar.TextButton.MouseButton1Down:connect(function(x, y)
		previousMousePos = Vector2.new(x, y)
		pPos = Dev_Container.AbsolutePosition
	end)

	Dev_TitleBar.TextButton.MouseButton1Up:connect(function(x, y)
		clean()
	end)

	---Handle Dev-Console Size
	function refreshConsoleSize(x, y)
		if not previousMousePosResize then
			return
		end
		
		local delta = Vector2.new(x, y) - previousMousePosResize
		Dev_Container.Size = UDim2.new(0, math.max(pSize.X + delta.X, minimumSize.X), 0, math.max(pSize.Y + delta.Y, minimumSize.Y))
	end
	Dev_Container.Body.ResizeButton.MouseButton1Down:connect(function(x, y)
		previousMousePosResize = Vector2.new(x, y)
		pSize = Dev_Container.AbsoluteSize
	end)

	Dev_Container.Body.ResizeButton.MouseButton1Up:connect(function(x, y)
		clean()
	end)


	---Handle Dev-Console Close Button
	Dev_TitleBar.CloseButton.MouseButton1Down:connect(function(x, y)
		Dev_Container.Visible = false
	end)

	Dev_Container.TitleBar.CloseButton.MouseButton1Up:connect(function()
		clean()
	end)
	
	local optionsHidden = true
	local animating = false
	--Options
	function startAnimation()
		if animating then return end
		animating = true
		
		repeat
			if optionsHidden then
				frameNumber = frameNumber - 1
			else
				frameNumber = frameNumber + 1
			end
			
			local x = frameNumber / 5
			local smoothStep = x * x * (3 - (2 * x))
			Dev_OptionsButton.ImageLabel.Rotation = smoothStep * 5 * 9
			Dev_OptionsBar.Position = UDim2.new(0, (smoothStep * 5 * 50) - 250, 0, 4)
			
			wait()
			if (frameNumber <= 0 and optionsHidden) or (frameNumber >= 5 and not optionsHidden) then
				animating = false
			end
		until not animating
	end
	
	Dev_OptionsButton.MouseButton1Down:connect(function(x, y)
		optionsHidden = not optionsHidden
		startAnimation()
	end)
	
	--Scroll Position
	
	function changeOffset(value)
		if (currentConsole == LOCAL_CONSOLE) then
			localOffset = localOffset + value
		elseif (currentConsole == SERVER_CONSOLE) then
			serverOffset = serverOffset + value
		end
		
		repositionList()
	end

	--Refresh Dev-Console Text
	function refreshTextHolderForReal()
		local childMessages = Dev_TextHolder:GetChildren()
		
		local messageList
		
		if (currentConsole == LOCAL_CONSOLE) then
			messageList = localMessageList
		elseif (currentConsole == SERVER_CONSOLE) then
			messageList = serverMessageList
		end
		
		local posOffset = 0

		for i = 1, #childMessages do
			childMessages[i].Visible = false
		end
		
		for i = 1, #messageList do
			local message
			
			local movePosition = false
			
			if i > #childMessages then
				message = Create'TextLabel'{
					Name = 'Message';
					Parent = Dev_TextHolder;
					BackgroundTransparency = 1;
					TextXAlignment = 'Left';
					Size = UDim2.new(1, 0, 0, 14);
					FontSize = 'Size10';
					ZIndex = 1;
				}
				movePosition = true
			else
				message = childMessages[i]
			end
			
			if (outputToggleOn or messageList[i].Type ~= Enum.MessageType.MessageOutput) and
			   (infoToggleOn or messageList[i].Type ~= Enum.MessageType.MessageInfo) and
			   (warningToggleOn or messageList[i].Type ~= Enum.MessageType.MessageWarning) and
			   (errorToggleOn or messageList[i].Type ~= Enum.MessageType.MessageError) then
				message.TextWrapped = wordWrapToggleOn
				message.Size = UDim2.new(0.98, 0, 0, 2000)
				message.Parent = Dev_Container
				message.Text = messageList[i].Time.." -- "..messageList[i].Message
							
				message.Size = UDim2.new(0.98, 0, 0, message.TextBounds.Y)
				message.Position = UDim2.new(0, 5, 0, posOffset)
				message.Parent = Dev_TextHolder
				posOffset = posOffset + message.TextBounds.Y
								
				if movePosition then
					if (currentConsole == LOCAL_CONSOLE and localOffset > 0) or (currentConsole == SERVER_CONSOLE and serverOffset > 0) then
						changeOffset(message.TextBounds.Y)
					end
				end
				
				message.Visible = true
			
				if messageList[i].Type == Enum.MessageType.MessageError then
					message.TextColor3 = Color3.new(1, 0, 0)
				elseif messageList[i].Type == Enum.MessageType.MessageInfo then
					message.TextColor3 = Color3.new(0.4, 0.5, 1)
				elseif messageList[i].Type == Enum.MessageType.MessageWarning then
					message.TextColor3 = Color3.new(1, 0.6, 0.4)
				else
					message.TextColor3 = Color3.new(1, 1, 1)
				end
			end
			
			
		end
		
		textHolderSize = posOffset
		
	end

	-- Refreshing the textholder every 0.1 (if needed) is good enough, surely fast enough
	-- We don't want it to update 50x in a tick because there are 50 messages in that tick
	-- (Whenever for one reason or another a lot of output comes in, it can lag
	--	This will make it behave better in a situation of a lot of output comming in)
	local refreshQueued = false
	function refreshTextHolder()
		if refreshQueued then return end
		Delay(0.1,function()
			refreshQueued = false
			refreshTextHolderForReal()
		end) refreshQueued = true
	end

	--Handle Dev-Console Scrollbar

	local inside = 0
	function holdingUpButton()
		if scrollUpIsDown then
			return
		end
		scrollUpIsDown = true
		wait(.6)
		inside = inside + 1
		while scrollUpIsDown and inside < 2 do
			wait()
			changeOffset(12)
		end
		inside = inside - 1
	end

	function holdingDownButton()
		if scrollDownIsDown then
			return
		end
		scrollDownIsDown = true
		wait(.6)
		inside = inside + 1
		while scrollDownIsDown and inside < 2 do
			wait()
			changeOffset(-12)
		end
		inside = inside - 1
	end

	Dev_Container.Body.ScrollBar.Up.MouseButton1Click:connect(function()
		changeOffset(10)
	end)

	Dev_Container.Body.ScrollBar.Up.MouseButton1Down:connect(function()
		changeOffset(10)
		holdingUpButton()
	end)

	Dev_Container.Body.ScrollBar.Up.MouseButton1Up:connect(function()
		clean()
	end)

	Dev_Container.Body.ScrollBar.Down.MouseButton1Down:connect(function()
		changeOffset(-10)
		holdingDownButton()
	end)

	Dev_Container.Body.ScrollBar.Down.MouseButton1Up:connect(function()
		clean()
	end)

	function handleScroll(x, y)
		if not previousMousePosScroll then
			return
		end
		
		local delta = (Vector2.new(x, y) - previousMousePosScroll).Y
		
		local backRatio = 1 - (Dev_Container.Body.TextBox.AbsoluteSize.Y / Dev_TextHolder.AbsoluteSize.Y)
		
		local movementSize = Dev_ScrollArea.AbsoluteSize.Y - Dev_ScrollArea.Handle.AbsoluteSize.Y
		local normalDelta = math.max(math.min(delta, movementSize), 0 - movementSize)
		local normalRatio = normalDelta / movementSize
		
		local textMovementSize = (backRatio * Dev_TextHolder.AbsoluteSize.Y)
		local offsetChange = textMovementSize * normalRatio
		
		if (currentConsole == LOCAL_CONSOLE) then
			localOffset = pOffset - offsetChange
		elseif (currentConsole == SERVER_CONSOLE) then
			serverOffset = pOffset - offsetChange
		end
	end

	Dev_ScrollArea.Handle.MouseButton1Down:connect(function(x, y)
		previousMousePosScroll = Vector2.new(x, y)
		pScrollHandle = Dev_ScrollArea.Handle.AbsolutePosition
		if (currentConsole == LOCAL_CONSOLE) then
			pOffset = localOffset
		elseif (currentConsole == SERVER_CONSOLE) then
			pOffset = serverOffset
		end
		
	end)

	Dev_ScrollArea.Handle.MouseButton1Up:connect(function(x, y)
		clean()
	end)
	
	local function existsInsideContainer(container, x, y)
		local pos = container.AbsolutePosition
		local size = container.AbsoluteSize
		if x < pos.X or x > pos.X + size.X or y < pos.y or y > pos.y + size.y then
			return false
		end
		return true
	end



	--Refresh Dev-Console Message Positions
	function repositionList()
		
		if (currentConsole == LOCAL_CONSOLE) then
			localOffset = math.min(math.max(localOffset, 0), textHolderSize - Dev_Container.Body.TextBox.AbsoluteSize.Y)
			Dev_TextHolder.Size = UDim2.new(1, 0, 0, textHolderSize)
			
		elseif (currentConsole == SERVER_CONSOLE) then
			serverOffset = math.min(math.max(serverOffset, 0), textHolderSize - Dev_Container.Body.TextBox.AbsoluteSize.Y)
			Dev_TextHolder.Size = UDim2.new(1, 0, 0, textHolderSize)
		end
			
		local ratio = Dev_Container.Body.TextBox.AbsoluteSize.Y / Dev_TextHolder.AbsoluteSize.Y

		if ratio >= 1 then
			Dev_Container.Body.ScrollBar.Visible = false
			Dev_Container.Body.TextBox.Size = UDim2.new(1, -4, 1, -28)
			
			if (currentConsole == LOCAL_CONSOLE) then
				Dev_TextHolder.Position = UDim2.new(0, 0, 1, 0 - textHolderSize)
			elseif (currentConsole == SERVER_CONSOLE) then
				Dev_TextHolder.Position = UDim2.new(0, 0, 1, 0 - textHolderSize)
			end
			
			
		else
			Dev_Container.Body.ScrollBar.Visible = true
			Dev_Container.Body.TextBox.Size = UDim2.new(1, -25, 1, -28)
			
			local backRatio = 1 - ratio
			local offsetRatio
			
			if (currentConsole == LOCAL_CONSOLE) then
				offsetRatio = localOffset / Dev_TextHolder.AbsoluteSize.Y
			elseif (currentConsole == SERVER_CONSOLE) then
				offsetRatio = serverOffset / Dev_TextHolder.AbsoluteSize.Y
			end
			
			local topRatio = math.max(0, backRatio - offsetRatio)
			
			local scrollHandleSize = math.max((Dev_ScrollArea.AbsoluteSize.Y) * ratio, 21)
			
			local scrollRatio = scrollHandleSize / Dev_ScrollArea.AbsoluteSize.Y
			local ratioConversion = (1 - scrollRatio) / (1 - ratio)
			
			local topScrollRatio = topRatio * ratioConversion
					
			local sPos = math.min((Dev_ScrollArea.AbsoluteSize.Y) * topScrollRatio, Dev_ScrollArea.AbsoluteSize.Y - scrollHandleSize)
						
			Dev_ScrollArea.Handle.Size = UDim2.new(1, 0, 0, scrollHandleSize)
			Dev_ScrollArea.Handle.Position = UDim2.new(0, 0, 0, sPos)
			
			if (currentConsole == LOCAL_CONSOLE) then
				Dev_TextHolder.Position = UDim2.new(0, 0, 1, 0 - textHolderSize + localOffset)
			elseif (currentConsole == SERVER_CONSOLE) then
				Dev_TextHolder.Position = UDim2.new(0, 0, 1, 0 - textHolderSize + serverOffset)
			end
			
		end
	end
	
	-- Easy, fast, and working nicely
	local function numberWithZero(num)
		return (num < 10 and "0" or "")..num
	end
	
	local str = "%s:%s:%s"

	function ConvertTimeStamp(timeStamp)
		local localTime = timeStamp - os.time() + math.floor(tick())
		local dayTime = localTime % 86400
				
		local hour = math.floor(dayTime/3600)
		
		dayTime = dayTime - (hour * 3600)
		local minute = math.floor(dayTime/60)
		
		dayTime = dayTime - (minute * 60)
		local second = dayTime
		
		local h = numberWithZero(hour)
		local m = numberWithZero(minute)
		local s = numberWithZero(dayTime)

		return str:format(h,m,s)
	end
	
	--Filter
	
	Dev_OptionsBar.ErrorToggleButton.MouseButton1Down:connect(function(x, y)
		errorToggleOn = not errorToggleOn
		Dev_OptionsBar.ErrorToggleButton.CheckFrame.Visible = errorToggleOn
		refreshTextHolder()
		repositionList()
	end)
	
	Dev_OptionsBar.WarningToggleButton.MouseButton1Down:connect(function(x, y)
		warningToggleOn = not warningToggleOn
		Dev_OptionsBar.WarningToggleButton.CheckFrame.Visible = warningToggleOn
		refreshTextHolder()
		repositionList()
	end)
	
	Dev_OptionsBar.InfoToggleButton.MouseButton1Down:connect(function(x, y)
		infoToggleOn = not infoToggleOn
		Dev_OptionsBar.InfoToggleButton.CheckFrame.Visible = infoToggleOn
		refreshTextHolder()
		repositionList()
	end)
	
	Dev_OptionsBar.OutputToggleButton.MouseButton1Down:connect(function(x, y)
		outputToggleOn = not outputToggleOn
		Dev_OptionsBar.OutputToggleButton.CheckFrame.Visible = outputToggleOn
		refreshTextHolder()
		repositionList()
	end)
	
	Dev_OptionsBar.WordWrapToggleButton.MouseButton1Down:connect(function(x, y)
		wordWrapToggleOn = not wordWrapToggleOn
		Dev_OptionsBar.WordWrapToggleButton.CheckFrame.Visible = wordWrapToggleOn
		refreshTextHolder()
		repositionList()
	end)

	---Dev-Console Message Functionality
	function AddLocalMessage(str, messageType, timeStamp)
		localMessageList[#localMessageList+1] = {Message = str, Time = ConvertTimeStamp(timeStamp), Type = messageType}
		while #localMessageList > MAX_LIST_SIZE do
			table.remove(localMessageList, 1)
		end
		
		refreshTextHolder()
		
		repositionList()
	end

	function AddServerMessage(str, messageType, timeStamp)
		serverMessageList[#serverMessageList+1] = {Message = str, Time = ConvertTimeStamp(timeStamp), Type = messageType}
		while #serverMessageList > MAX_LIST_SIZE do
			table.remove(serverMessageList, 1)
		end
		
		refreshTextHolder()
		
		repositionList()
	end



	--Handle Dev-Console Local/Server Buttons
	Dev_Container.Body.LocalConsole.MouseButton1Click:connect(function(x, y)
		if (currentConsole == SERVER_CONSOLE) then
			currentConsole = LOCAL_CONSOLE
			local localConsole = Dev_Container.Body.LocalConsole
			local serverConsole = Dev_Container.Body.ServerConsole
			
			localConsole.Size = UDim2.new(0, 90, 0, 20)
			serverConsole.Size = UDim2.new(0, 90, 0, 17)
			localConsole.BackgroundTransparency = 0.6
			serverConsole.BackgroundTransparency = 0.8
			
			if game:FindFirstChild("Players") and game.Players["LocalPlayer"] then
				local mouse = game.Players.LocalPlayer:GetMouse()
				local mousePos = Vector2.new(mouse.X, mouse.Y)
				refreshConsolePosition(mouse.X, mouse.Y)
				refreshConsoleSize(mouse.X, mouse.Y)
				handleScroll(mouse.X, mouse.Y)
			end
			
			refreshTextHolder()
			repositionList()
			
		end
	end)

	Dev_Container.Body.LocalConsole.MouseButton1Up:connect(function()
		clean()
	end)
	
	local serverHistoryRequested = false;

	Dev_Container.Body.ServerConsole.MouseButton1Click:connect(function(x, y)
		
		if not serverHistoryRequested then
			serverHistoryRequested = true
			game:GetService("LogService"):RequestServerOutput()
		end
		
		if (currentConsole == LOCAL_CONSOLE) then
			currentConsole = SERVER_CONSOLE
			local localConsole = Dev_Container.Body.LocalConsole
			local serverConsole = Dev_Container.Body.ServerConsole
			
			serverConsole.Size = UDim2.new(0, 90, 0, 20)
			localConsole.Size = UDim2.new(0, 90, 0, 17)
			serverConsole.BackgroundTransparency = 0.6
			localConsole.BackgroundTransparency = 0.8
			
			if game:FindFirstChild("Players") and game.Players["LocalPlayer"] then
				local mouse = game.Players.LocalPlayer:GetMouse()
				local mousePos = Vector2.new(mouse.X, mouse.Y)
				refreshConsolePosition(mouse.X, mouse.Y)
				refreshConsoleSize(mouse.X, mouse.Y)
				handleScroll(mouse.X, mouse.Y)
			end
			
			refreshTextHolder()
			repositionList()
		end
	end)

	---Extra Mouse Handlers for Dev-Console
	Dev_Container.Body.ServerConsole.MouseButton1Up:connect(function()
		clean()
	end)
	
	if game:FindFirstChild("Players") and game.Players["LocalPlayer"] then
		local LocalMouse = game.Players.LocalPlayer:GetMouse()
		LocalMouse.Move:connect(function()
			if not Dev_Container.Visible then
				return
			end
			local mouse = game.Players.LocalPlayer:GetMouse()
			local mousePos = Vector2.new(mouse.X, mouse.Y)
			refreshConsolePosition(mouse.X, mouse.Y)
			refreshConsoleSize(mouse.X, mouse.Y)
			handleScroll(mouse.X, mouse.Y)
			
			refreshTextHolder()
			repositionList()
		end)

		LocalMouse.Button1Up:connect(function()
			clean()
		end)
		
		LocalMouse.WheelForward:connect(function()
			if not Dev_Container.Visible then
				return
			end
			if existsInsideContainer(Dev_Container, LocalMouse.X, LocalMouse.Y) then
				changeOffset(10)
			end
		end)
		
		LocalMouse.WheelBackward:connect(function()
			if not Dev_Container.Visible then
				return
			end
			if existsInsideContainer(Dev_Container, LocalMouse.X, LocalMouse.Y) then
				changeOffset(-10)
			end
		end)
		
	end
	
	Dev_ScrollArea.Handle.MouseButton1Down:connect(function()
		repositionList()
	end)
	
	
	---Populate Dev-Console with dummy messages
	
	local history = game:GetService("LogService"):GetLogHistory()
	
	for i = 1, #history do
		AddLocalMessage(history[i].message, history[i].messageType, history[i].timestamp)
	end
	
	game:GetService("LogService").MessageOut:connect(function(message, messageType)
		AddLocalMessage(message, messageType, os.time())
	end)
	
	game:GetService("LogService").ServerMessageOut:connect(AddServerMessage)
	
end

local currentlyToggling = false
function ToggleConsole.OnInvoke()
	if currentlyToggling then
		return
	end

	currentlyToggling = true
	initializeDeveloperConsole()
	Dev_Container.Visible = not Dev_Container.Visible
	currentlyToggling = false
end
