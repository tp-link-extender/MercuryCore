local Load = {}

function Load.Help()
	print "Call Load.Start with a ticket to start a game server!"
end

function Load.Start(ticket: string)
	dofile("http://banland.xyz/game/host?ticket=" .. ticket)
end

return Load
