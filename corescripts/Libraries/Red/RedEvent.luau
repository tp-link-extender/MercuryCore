return function(IsServer: boolean)
	local ReplicatedStorage = game:GetService "ReplicatedStorage"
	local Players = game:GetService "Players"

	local RedEvent = {}

	local Remote, ClientFolder

	if IsServer then
		Remote = ReplicatedStorage:FindFirstChild "RedEvent" :: RemoteEvent

		if not Remote then -- prevent vile promise bugs
			Remote = Instance.new "RemoteEvent"
			Remote.Name = "RedEvent"
			Remote.Parent = ReplicatedStorage
		end

		local function PlayerAdded(Player: Player)
			ClientFolder = Instance.new "ScreenGui"

			-- ClientFolder.Enabled = false
			-- ClientFolder.ResetOnSpawn = false
			ClientFolder.Name = "Red"
			ClientFolder.Parent = Player:FindFirstChild "PlayerGui"
		end

		Players.PlayerAdded:connect(PlayerAdded)

		for _, Player in ipairs(Players:GetPlayers()) do
			PlayerAdded(Player)
		end
	else
		Remote = ReplicatedStorage:WaitForChild "RedEvent" :: RemoteEvent

		ClientFolder = (
			Players.LocalPlayer:FindFirstChild "PlayerGui" :: PlayerGui
		):WaitForChild "Red" :: ScreenGui
		ClientFolder.Parent = nil
	end

	RedEvent.Remote = Remote
	RedEvent.ClientFolder = ClientFolder

	return RedEvent
end
