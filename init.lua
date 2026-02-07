--// EasyProfiles.lua (07/02/2026)

--[[
	@alex.setasync for Bloxademy.

	https://bloxademy.com
--]]

--[[
Credits:

ProfileService - https://madstudioroblox.github.io/ProfileService/

A_RawSignal - https://gist.github.com/cxmeel/fce01f8abb73a6a73c9228ba969e835e
--]]

--// Services
local EasyProfiles = {}
local Players = game:GetService("Players")
local ProfileService = require(script:WaitForChild("ProfileService"))
local Signal = require(script:WaitForChild("Signal"))
local Setup = require(script:WaitForChild("Setup"))
local ProfileInterface = require(script:WaitForChild("ProfileInterface"))

--// Data
EasyProfiles.__LoadedProfiles = {}
EasyProfiles.__ProfileStore = ProfileService.GetProfileStore(Setup.ProfileStoreName, Setup.ProfileLayout)
EasyProfiles.PlayerAdded = Signal.new()

--// API
function EasyProfiles.Get(Client : Player)
	local Profile
	
	repeat
		Profile = EasyProfiles.__LoadedProfiles[Client]
	until (Profile and Client:FindFirstChild("leaderstats")) or (not Client:IsDescendantOf(Players)) or (not task.wait())
	
	if not Profile then
		error("The client left before their profile could be fetched.")
	end
	
	return ProfileInterface.new(Profile.Data, Client.leaderstats)
end

--// Core
function EasyProfiles.SetupLeaderstats(Client : Player, Profile : {string : any}) : boolean
	local LeaderstatsFolder : Folder = Instance.new("Folder")
	LeaderstatsFolder.Name = "leaderstats"
	
	for Key, Value in Setup.Leaderstats do
		local StatInstanceClass
		
		if type(Value) == "table" then
			-- TODO
		elseif type(Value) == "number" then
			StatInstanceClass = "NumberValue"
		elseif type(Value) == "string" then
			StatInstanceClass = "StringValue"
		else
			warn("Invalid type for "..Key..".")
			continue
		end
		
		local StatInstance = Instance.new(StatInstanceClass)
		StatInstance.Name = Value
		StatInstance.Value = Profile.Data[Key]
		StatInstance.Parent = LeaderstatsFolder
		
		local Event = StatInstance:GetPropertyChangedSignal("Value")
		Event:Connect(function()
			Profile.Data[Key] = StatInstance.Value
		end)
	end
	
	LeaderstatsFolder.Parent = Client
	return LeaderstatsFolder
end

function EasyProfiles.HandleClient(Client : Player) : nil
	local Profile = EasyProfiles.__ProfileStore:LoadProfileAsync(tostring(Client.UserId))
	if Profile == nil then
		Client:Kick("EasyProfiles - Fatal Error")
		return
	end
	
	Profile:AddUserId(Client.UserId)
	Profile:Reconcile()
	
	Profile:ListenToRelease(function()
		EasyProfiles.__LoadedProfiles[Client] = nil
		Client:Kick("EasyProfiles - Fatal Error")
	end)
	
	if Client:IsDescendantOf(Players) then
		local LeaderstatsFolder : Folder = EasyProfiles.SetupLeaderstats(Client, Profile)
		EasyProfiles.__LoadedProfiles[Client] = Profile
		
		EasyProfiles.PlayerAdded:Fire(
			Client,
			ProfileInterface.new(Profile.Data, LeaderstatsFolder)
		)
	else
		Profile:Release()
	end
	
end

function EasyProfiles.HandleRemovingClient(Client : Player) : nil
	local Profile = EasyProfiles.__LoadedProfiles[Client]
	if Profile then
		Profile:Release()
	end
end

function EasyProfiles.Init() : nil
	Players.PlayerAdded:Connect(EasyProfiles.HandleClient)
	Players.PlayerRemoving:Connect(EasyProfiles.HandleRemovingClient)
	
	for _, EarlyClient : Player in Players:GetPlayers() do
		EasyProfiles.HandleClient(EarlyClient)
	end
end

EasyProfiles.Init()
return EasyProfiles
