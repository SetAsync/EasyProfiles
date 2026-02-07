### EasyProfiles

ProfileService provides an interface to DataStoreService, EasyProfiles provides an interface to that interface - as some people find it confusing.

Data handling cannot get any easier than this.

---
Example usage:
```lua
local EasyProfiles = require(script.Parent.EasyProfiles)

EasyProfiles.PlayerAdded:Connect(function(Client, Profile)
	Profile.Coins += 1
end)


local CoinClick = workspace.CoinClick
CoinClick.ClickDetector.MouseClick:Connect(function(Player)
	local Profile = EasyProfiles.Get(Player)

	Player.leaderstats.Cash.Value += 1 -- This is valid.
	
	Profile.Cash += 1 -- So is this.
end)
```

Example Setup:
```lua
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
```


This is an initial release for students at BLX that struggle with ProfileService, a later official release may be posted that supports:

- More ways of fetching data.
- Tables within a profile (this already works to some extent).

