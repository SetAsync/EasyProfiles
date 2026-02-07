--// Setup.lua

local Setup = {}

-- The name of the profile store.
-- Adjust this to use a different profile store, and thus loose all data.
Setup.ProfileStoreName = "PlrData_v1"

-- The layout of the profile store.
-- Name -> Default Value
Setup.ProfileLayout = {
	Coins = 0;
	Rank = 1;
	Inventory = {"Sword"};
}

-- Follows the layout of the profile store but creates leaderstats.
-- Name -> Leaderstat Name
Setup.Leaderstats = {
	Coins = "Cash";
}

return Setup
