local logEvent

return function(...: string)
	if game.Players.LocalPlayer.Name ~= "Heliodex" then -- hehuhuhuehuehe
		return
	end

	logEvent = logEvent or game:WaitForChild "Log"
	local message = ""
	for _, v in ipairs { ... } do
		message ..= tostring(v) .. " "
	end
	print(message)
	logEvent:Fire(message)
end
