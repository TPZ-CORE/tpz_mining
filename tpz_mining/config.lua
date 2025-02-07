Config = {}

Config.DevMode   = false
Config.ActionKey = 0x760A9C6F --[G]

-----------------------------------------------------------
--[[ Webhooking (Only DevTools - Injection Cheat Logs) ]]--
-----------------------------------------------------------

Config.Webhooks = {
    
    ['DEVTOOLS_INJECTION_CHEAT'] = { -- Warnings and Logs about players who used or atleast tried to use devtools injection.
        Enabled = false, 
        Url = "", 
        Color = 10038562,
    },

}

-----------------------------------------------------------
--[[ General ]]--
-----------------------------------------------------------

-- Set to false if you don't use tpz_leveling resource.
Config.tpz_leveling         = true

Config.Jobs                 = { "miner" }  -- set to false if you want to disable jobs based.

Config.PickaxeItem          = "pickaxe"
Config.ObjectModel          = 'p_pickaxe01x'

-- Set to false if you don't want the pickaxe durability to removed.
Config.Durability           = { Enabled = true, RemoveValue = { min = 0, max = 1 } }

Config.MiningTimer          = 10 -- Time in seconds.

Config.ActionDistance       = 1.2

Config.DisplayActionMarkers = true
Config.DisplayActionMarkersDistance = 10.0
Config.DisplayActionMarkersRGBA = {r = 240, g = 230, b = 140, a = 255}

-----------------------------------------------------------
--[[ Locations ]]--
-----------------------------------------------------------

Config.MiningZones = {
    Annesburg = {

        City = "Annesburg",

        LevelRequired = 1,

        Blips = {
            Enabled = true,

            Coords = {x = 2798.65, y = 1341.46, z = 71.30},
            Label = "Mining Zone",
            Sprite = -1289383059,
        },

        ActionCoords = {
            {x = 2771.96, y = 1362.69, z = 70.57},
            {x = 2765.92, y = 1358.58, z = 70.57},
            {x = 2767.84, y = 1343.90, z = 70.65},
            {x = 2761.00, y = 1310.62, z = 70.03},
            {x = 2716.89, y = 1314.07, z = 69.75},
            {x = 2736.88, y = 1322.51, z = 69.74},
            {x = 2753.27, y = 1378.31, z = 67.81},
            {x = 2747.44, y = 1388.13, z = 68.98},
            {x = 2779.97, y = 1389.33, z = 69.96},
        },

    },

    BigValley = {

        City = "BigValley",

        LevelRequired = 5,

        Blips = {
            Enabled = true,

            Coords = {x = -2321.99, y = 94.55, z = 221.59},
            Label = "Mining Zone",
            Sprite = -1289383059,
        },

        ActionCoords = {
            {x = -2371.17, y = 117.4144, z = 216.78},
            {x = -2362.98, y = 120.2430, z = 216.78},
            {x = -2368.07, y = 123.6765, z = 216.84},
        },

    },

    Tumbleweed = {

        City = "Tumbleweed",

        LevelRequired = 10,

        Blips = {
            Enabled = true,

            Coords = {x = -5964.28, y = -3206.43, z = -21.40},
            Label = "Mining Zone",
            Sprite = -1289383059,
        },

        ActionCoords = {
            {x = -5962.63, y = -3176.46, z = -22.98},
            {x = -5970.78, y = -3167.12, z = -25.30},
            {x = -5986.17, y = -3164.50, z = -26.45},
        },

    },

    -- sulfur mining
    CotorraSprings = {

        City = "CotorraSprings",

        LevelRequired = 1,

        Blips = {
            Enabled = true,

            Coords = {x = 230.0616, y = 1913.623, z = 205.00, h = 90.731201171875},
            Label = "Sulfur Mining Zone",
            Sprite = -1289383059,
        },

        ActionCoords = {
            {x = 239.4076, y = 1929.374, z = 204.33, h = 198.34950256348},
            {x = 249.6603, y = 1940.164, z = 204.42, h = 334.02130126953},
            {x = 244.5019, y = 1951.859, z = 204.40, h = 21.501800537109},
            {x = 230.8318, y = 1955.547, z = 204.37, h = 76.410766601563},
            {x = 222.5664, y = 1949.650, z = 204.39, h = 131.23936462402},
            {x = 193.5512, y = 1913.332, z = 204.12, h = 285.44812011719},
        },

    },
}


-----------------------------------------------------------
--[[ Location Rewards ]]--
-----------------------------------------------------------

-- @param exp : is the experience which will it give for tpz_leveling (mining type).

Config.Items = {
    ['Annesburg'] = {

        { item = "rock",       label = "Rocks",        chance = 100,  quantity = {min = 1,2},  experience = 2},
        { item = "copper",     label = "Copper",       chance = 70,   quantity = {min = 1,2},  experience = 4},
        { item = "iron",       label = "Iron",         chance = 50,   quantity = {min = 1,2},  experience = 5},
        { item = "silver",     label = "Silver",       chance = 30,   quantity = {min = 1,2},  experience = 6},
        { item = "goldnugget", label = "Gold Nuggets", chance = 20,   quantity = {min = 1,2},  experience = 10},
    },

    ['BigValley'] = {
        { item = "rock",       label = "Rocks",        chance = 100,  quantity = {min = 1, max = 2},  experience = 2},
        { item = "coal",       label = "Coal",         chance = 90,   quantity = {min = 1, max = 2},  experience = 3},
        { item = "copper",     label = "Copper",       chance = 80,   quantity = {min = 1, max = 2},  experience = 4},
        { item = "salt",       label = "Salt",         chance = 70,   quantity = {min = 1, max = 2},  experience = 4},
        { item = "clay",       label = "Clay",         chance = 60,   quantity = {min = 1, max = 2},  experience = 5},

        { item = "iron",       label = "Iron",         chance = 50,   quantity = {min = 1, max = 2},  experience = 5},
        { item = "silver",     label = "Silver",       chance = 30,   quantity = {min = 1, max = 2},  experience = 6},
        { item = "goldnugget", label = "Gold Nuggets", chance = 20,   quantity = {min = 1, max = 2},  experience = 10},
        { item = "platinum",   label = "Platinum",     chance = 10,   quantity = {min = 1, max = 1},  experience = 20},
    },

    ['Tumbleweed'] = {

        { item = "rock",       label = "Rocks",        chance = 100,  quantity = {min = 1, max = 2},  experience = 2},
        { item = "copper",     label = "Copper",       chance = 80,   quantity = {min = 1, max = 1},  experience = 4},

        { item = "coal",       label = "Coal",         chance = 70,   quantity = {min = 1, max = 2},  experience = 3},
        { item = "salt",       label = "Salt",         chance = 60,   quantity = {min = 1, max = 2},  experience = 4},
        
        { item = "iron",       label = "Iron",         chance = 50,   quantity = {min = 1, max = 2},  experience = 5},
        { item = "silver",     label = "Silver",       chance = 30,   quantity = {min = 1, max = 2},  experience = 6},
        { item = "goldnugget", label = "Gold Nuggets", chance = 20,   quantity = {min = 1, max = 2},  experience = 10},
        { item = "diamond",    label = "Diamond",      chance = 5,    quantity = {min = 1, max = 1},  experience = 25},
    },

    ['CotorraSprings'] = {
        { item = "sulfur",     label = "Sulfur",       chance = 50,   quantity = {min = 1, max = 1},  experience = 5},
    },

}

-----------------------------------------------------------
--[[ Notification Functions  ]]--
-----------------------------------------------------------

-- @param source is always null when called from client.
-- @param messageType returns "success" or "error" depends when and where the message is sent.
function SendNotification(source, message, messageType)

    local colorType = "COLOR_YELLOW"
  
    if messageType == "error" then
      colorType = "COLOR_RED"
    end
  
    if not source then
        TriggerEvent('tpz_core:sendLeftNotification', "MINING", message, "generic_textures", "medal_gold", 3000, colorType)
    else
        TriggerClientEvent('tpz_core:sendLeftNotification', source, "MINING", message, "generic_textures", "medal_gold", 3000, colorType)
    end
  
end
