-- A loadscript template covering every place a value can appear.
-- _NAME stays as written in a comment.
local values = {_NAME, '_NAME', "_NAME"}
for _, value in values do
	print((string.gsub(value, ".", function(char)
		return string.format("%02x", string.byte(char))
	end)))
end
-- _NOT_A_VALUE is left alone here, as values can't be escaped inside long strings
local long = [==[_NOT_A_VALUE]==]
print("done " .. tostring(#long > 0))
