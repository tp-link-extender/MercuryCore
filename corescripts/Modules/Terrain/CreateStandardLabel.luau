local New = require("../New").New

-- Create a standard text label.  Use this for all lables in the popup so it is easy to standardize.
-- labelName - What to set the text label name as.
-- pos    	 - Where to position the label.  Should be of type UDim2.
-- size   	 - How large to make the label.	 Should be of type UDim2.
-- text   	 - Text to display.
-- parent 	 - What to set the text parent as.
-- Return:
-- Value is the created label.
return function(
	labelName: string,
	pos: UDim2,
	size: UDim2,
	text: string,
	parent: Instance?
)
	return New "TextLabel" {
		Name = labelName,
		Position = pos,
		Size = size,
		Text = text,
		TextColor3 = Color3.new(0.95, 0.95, 0.95),
		Font = Enum.Font.ArialBold,
		FontSize = Enum.FontSize.Size14,
		TextXAlignment = Enum.TextXAlignment.Left,
		BackgroundTransparency = 1,
		Parent = parent,
	}
end
