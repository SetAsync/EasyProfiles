local ProfileInterface = {}
local Setup = require(script.Parent.Setup)

function ProfileInterface.new(Data : {any : any}, Leaderstats : Folder) : {any : any}
	local self = {}

	setmetatable(self, ProfileInterface)

	rawset(self, "__Data", Data)
	rawset(self, "__Leaderstats", Leaderstats)

	return self
end

function ProfileInterface:__index(Key)
	if ProfileInterface[Key] then
		return ProfileInterface[Key]
	end

	local Data = rawget(self, "__Data")
	local Value = Data[Key]

	if Value == nil then
		error("Attempted to find a value that does not exist: "..tostring(Key))
	end

	return Value
end

function ProfileInterface:__newindex(Key, Value)
	local Data = rawget(self, "__Data")
	Data[Key] = Value

	local Leaderstats = rawget(self, "__Leaderstats")
	local StatName = Setup.Leaderstats[Key]
	if StatName then
		local Stat = Leaderstats:FindFirstChild(StatName)
		if Stat then
			Stat.Value = Value
		end
	end
end

return ProfileInterface
