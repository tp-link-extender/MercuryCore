local New = require("../New").New

-- Create a standard dropdown.  Use this for all dropdowns in the popup so it is easy to standardize.
-- name - What to use.
-- pos    	 	- Where to position the button.  Should be of type UDim2.
-- text         - Text to show in the button.
-- funcOnPress  - Function to run when the button is pressed.
-- parent 	 	- What to set the parent as.
-- Return:
-- button 	   - The button gui.
return function(
	name: string,
	pos: UDim2,
	text: string,
	funcOnPress: (...any) -> (),
	parent: Instance,
	size: UDim2?
)
	local button = New "TextButton" {
		Name = name,
		Position = pos,
		Size = size or UDim2.new(0, 120, 0, 40),
		Text = text,
		Style = Enum.ButtonStyle.RobloxButton,
		TextColor3 = Color3.new(1, 1, 1),
		Font = Enum.Font.ArialBold,
		FontSize = Enum.FontSize.Size18,
	}

	button.MouseButton1Click:connect(funcOnPress)
	button.Parent = parent

	return button
end
