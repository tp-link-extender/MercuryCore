return function(IsServer: boolean)
	local Players = game:GetService "Players"

	local RedEvent = require "../RedEvent"(IsServer)
	local Remote = RedEvent.Remote
	local ClientFolder = RedEvent.ClientFolder

	local Serdes = require "./Serdes"(IsServer)
	local Event = require "./Event"(IsServer)

	local Server = {}
	Server.__index = Server

	function Server.Server(Name: string)
		local self = setmetatable({}, Server)

		self.Name = Name
		self.FolderInstance = nil :: Folder?

		return self
	end

	Server.new = Server.Server

	function Server.Fire(self: Server, Player: Player, EventName: string, ...)
		Event.FireClient(Player, self.Name .. "_" .. EventName, ...)
	end

	function Server.FireAll(self: Server, EventName: string, ...)
		for _, Player in ipairs(Players:GetPlayers()) do
			self:Fire(Player, EventName, ...)
		end
	end

	function Server.FireAllExcept(
		self: Server,
		Player: Player,
		EventName: string,
		...
	)
		for _, OtherPlayer in ipairs(Players:GetPlayers()) do
			if OtherPlayer ~= Player then
				self:Fire(OtherPlayer, EventName, ...)
			end
		end
	end

	function Server.FireList(
		self: Server,
		PlayerList: { Player },
		EventName: string,
		...
	)
		for _, Player in ipairs(PlayerList) do
			self:Fire(Player, EventName, ...)
		end
	end

	function Server.FireWithFilter(
		self: Server,
		Filter: (Player) -> boolean,
		EventName: string,
		...
	)
		for _, Player in ipairs(Players:GetPlayers()) do
			if Filter(Player) then
				self:Fire(Player, EventName, ...)
			end
		end
	end

	function Server.On(
		self: Server,
		EventName: string,
		Callback: ((Player, ...any) -> ...any)?
	)
		Event.SetCallback(self.Name .. "_" .. EventName, Callback)
	end

	function Server.Folder(self: Server, Player: Player?)
		if Player then
			ClientFolder = (
				Player:FindFirstChild "PlayerGui" :: any
			).Red :: ScreenGui

			if ClientFolder:FindFirstChild(self.Name) then
				return ClientFolder:FindFirstChild(self.Name) :: Model
			else
				local Folder = Instance.new "Model"
				Folder.Name = self.Name
				Folder.Parent = ClientFolder

				return Folder :: Model
			end
		else
			if not self.FolderInstance then
				local Folder = Instance.new "Model"
				Folder.Name = self.Name
				Folder.Parent = Remote

				self.FolderInstance = Folder
			end

			return self.FolderInstance :: Model
		end
	end

	export type Server = typeof(Server.Server "")

	local Client = {}
	Client.__index = Client

	function Client.Client(Name: string)
		local self = setmetatable({}, Client)

		self.Name = Name
		self.FolderInstance = nil :: Folder?
		self.LocalFolderInstance = nil :: Folder?

		return self
	end

	Client.new = Client.Client

	function Client.Fire(self: Client, EventName: string, ...)
		return Event.FireServer(self.Name .. "_" .. EventName, ...)
	end

	function Client.Call(self: Client, EventName: string, ...)
		return Event.Call(self.Name .. "_" .. EventName, ...)
	end

	function Client.On(
		self: Client,
		EventName: string,
		Callback: ((...any) -> ())?
	)
		return Event.SetCallback(self.Name .. "_" .. EventName, Callback)
	end

	function Client.Folder(self: Client)
		if not self.FolderInstance then
			self.FolderInstance = Remote:WaitForChild(self.Name) :: Model
		end

		return self.FolderInstance :: Model
	end

	function Client.LocalFolder(self: Client)
		if not self.LocalFolderInstance then
			self.LocalFolderInstance =
				ClientFolder:WaitForChild(self.Name) :: Model
		end

		return self.LocalFolderInstance :: Model
	end

	export type Client = typeof(Client.Client "")

	local Net = {}

	Net.ServerNamespaceList = {}
	Net.ClientNamespaceList = {}

	function Net.Server(Name: string, Definitions: { string }?): Server
		assert(IsServer, "Net.Server can only be used on the server")

		if not Net.ServerNamespaceList[Name] then
			Net.ServerNamespaceList[Name] = Server.Server(Name)
		end

		if Definitions then
			for _, Term in ipairs(Definitions) do
				Serdes.Identifier((Name :: string) .. "_" .. Term)
			end
		end

		return Net.ServerNamespaceList[Name]
	end

	function Net.Client(Name: string): Client
		assert(not IsServer, "Net.Client can only be used on the client")

		if Net.ClientNamespaceList[Name] == nil then
			Net.ClientNamespaceList[Name] = Client.Client(Name)
		end

		return Net.ClientNamespaceList[Name]
	end

	function Net.Identifier(Name: string)
		return Serdes.Identifier(Name)
	end

	Event.Listen()

	return Net
end
