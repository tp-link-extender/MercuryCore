--!strict

local Players = game:GetService "Players"

return function(
	baseUrl: string,
	renderType: string,
	assetId: number,
	characterAppearance: string
)
	print(`[{game.JobId}] Starting new render for {renderType} Id {assetId}`)
	local player = Players:CreateLocalPlayer(0)
	player.CharacterAppearance = baseUrl .. characterAppearance .. assetId
	player:LoadCharacter(false)

	-- Raise up the character's arm if they have gear.
	local gear = player.Backpack:GetChildren()[1]
	if gear then
		gear.Parent = player.Character
		player.Character.Torso["Right Shoulder"].CurrentAngle = math.rad(90)
	end

	return player
end
