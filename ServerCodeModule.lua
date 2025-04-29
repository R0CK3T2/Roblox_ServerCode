local ServerCode = {}


--// Services and Variables [HIGHLY RECOMMENDED TO NOT CHANGE]
local TeleportService = game:GetService("TeleportService")
local DataStoreService = game:GetService("DataStoreService")

local random = Random.new()

--// Configurations/Changable Variables! Feel Free To Edit
local CodesDatastore = DataStoreService:GetDataStore("UntitledServerCodeDatastore") -- Datastore to Store all of the Codes and the PrivateServerIDS Associated with them
local letters = {'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'} -- List of Characters to be used for the Random Code Generator
local Length = 6 -- Length of the Server Code
local PlaceID = 111111111111 --PlaceID of Place to teleport player to 

if script:FindFirstChild("Client-Server Bridge") == nil then -- Create a RemoteEvent that allows the Translation of Data Between Client and Server
	local CreateBridge = Instance.new("RemoteEvent")
	CreateBridge.Name = "Client-Server Bridge"
	CreateBridge.Parent = script
end



function getRandomCharacter()
	local d = math.random(1,2)
	if d == 1 then
		return letters[random:NextInteger(1,#letters)]
	else
		return tostring(math.random(1,9))
	end
end

function getRandomString(length)
	local length = length or 10
	local str = ''
	for i=1,length do
		local randomLetter = getRandomCharacter()
		str = str .. randomLetter
	end
	return str
end

--//CLIENT SIDED - IF TRYING TO INVOKE FROM SERVER USE [SERVERCODE.AttemptToTeleportPlayer] Below\\--
function ServerCode.TeleportPlayer(Player: Player, ProvidedServerCode: string) 
	script["Client-Server Bridge"]:FireServer(ProvidedServerCode)
end


--//SERVER SIDED - DO NOT INVOKE FROM CLIENT (LOCALSCRIPT)\\--
function ServerCode.AttemptToTeleportPlayer(Code: string, Player: Player) -- Attempt To Teleport Player to Server with Provided Code
	pcall(function()
		if CodesDatastore:GetAsync(ServerCode) ~= nil then
			local PrivateServerID = CodesDatastore:GetAsync(ServerCode)
			TeleportService:TeleportToPrivateServer(PlaceID, PrivateServerID, {Player}, nil, Code)
		else
			warn("ServerCode not found, Attempt to teleport Player to Invalid Server")
		end
	end)
end



--//SERVER SIDED - DO NOT INVOKE FROM CLIENT (LOCALSCRIPT)\\--
function ServerCode.GenerateNewServerForPlayer(player: Player) -- Generates a New Server Code for a Player, Teleports them to it, and Saves the Code to the Datastore. 
	local NewServerCode = getRandomString(Length, false)
	pcall(function()
		repeat
			NewServerCode = getRandomString(Length, false)
		until CodesDatastore:GetAsync(NewServerCode) == nil
	end)
	local NewServer, PlaceID = TeleportService:ReserveServer()
	CodesDatastore:SetAsync(NewServerCode, NewServer)
	TeleportService:TeleportToPrivateServer(17870179076, NewServer, {player},nil, NewServerCode)
end

--//SERVER SIDED - DO NOT INVOKE FROM CLIENT (LOCALSCRIPT)\\--
function ServerCode.ObtainCurrentServerCodeFromPlayer(Player: Player)
	local ServerCode = game.ReplicatedStorage.ObtainServerCode:InvokeClient(Player)
end


script:WaitForChild("Client-Server Bridge").OnServerEvent:Connect(function(Player, ServerCode)
	ServerCode.AttemptToTeleportPlayer(ServerCode, Player)
end)


return ServerCode
