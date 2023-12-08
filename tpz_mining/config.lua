Config = {}

Config.DevMode   = false

Config.ActionKey = 0x760A9C6F --[G]
-----------------------------------------------------------
--[[ Discord Webhooking  ]]--
-----------------------------------------------------------

Config.Webhooking = { 
    Enable = true, 
    Url = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx", -- The discord webhook url.
    Color = 10038562,
}

-----------------------------------------------------------
--[[ TPZ-LEVELING  ]]--
-----------------------------------------------------------

Config.tpz_leveling = true

-----------------------------------------------------------
--[[ General ]]--
-----------------------------------------------------------

Config.Job                  = "miner"
Config.OnlyJob              = true -- If set to true, only the players with the Config.Job will be able to work on the mining areas.

Config.PickaxeItem          = "pickaxe"
Config.DurabilityRemove     = {0, 1} -- Set to false if you don't want to remove any durability. (100% is maximum)

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
            Label = "Anessburg Mining Zone",
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
            Label = "Big Valley Mining Zone",
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
            Label = "Tumbleweed Mining Zone",
            Sprite = -1289383059,
        },

        ActionCoords = {
            {x = -5962.63, y = -3176.46, z = -22.98},
            {x = -5970.78, y = -3167.12, z = -25.30},
            {x = -5986.17, y = -3164.50, z = -26.45},
        },

    },

    -- sulfur mining
    Glacier = {

        City = "Glacier",

        LevelRequired = 1,

        Blips = {
            Enabled = true,

            Coords = {x = -1547.08, y = 2967.903, z = 469.44, h = 108.18222808838},
            Label = "Glacier Ice Mining Zone",
            Sprite = -1289383059,
        },

        ActionCoords = {
            {x = -1627.02, y = 2934.817, z = 487.85, h = 217.15000915527},
            {x = -1641.78, y = 2948.442, z = 488.84, h = 37.171859741211},
            {x = -1663.50, y = 2942.584, z = 490.97, h = 90.71996307373},
            {x = -1656.34, y = 2938.947, z = 490.10, h = 210.72106933594},
            {x = -1616.09, y = 2946.229, z = 484.41, h = 306.92065429688},
            {x = -1599.95, y = 2947.887, z = 481.37, h = 268.41159057617},
            {x = -1577.95, y = 2961.702, z = 475.36, h = 19.513904571533},
            {x = -1600.31, y = 2933.471, z = 482.05, h = 173.36756896973},

        },

    },
}


-----------------------------------------------------------
--[[ Location Rewards ]]--
-----------------------------------------------------------

-- @param exp : is the experience which will it give for tpz_leveling (mining type).

Config.Items = {
    ['Annesburg'] = {

        {name = "rock",       label = "Rocks",        chance = 100,  quantity = {1,2},  exp = 2},
        {name = "copper",     label = "Copper",       chance = 70,   quantity = {1,2},  exp = 4},
        {name = "iron",       label = "Iron",         chance = 50,   quantity = {1,2},  exp = 5},
        {name = "silver",     label = "Silver",       chance = 30,   quantity = {1,2},  exp = 6},
        {name = "goldnugget", label = "Gold Nuggets", chance = 20,   quantity = {1,2},  exp = 10},
    },

    ['BigValley'] = {
        {name = "rock",       label = "Rocks",        chance = 100,  quantity = {1,2},  exp = 2},
        {name = "coal",       label = "Coal",         chance = 90,   quantity = {1,2},  exp = 3},
        {name = "copper",     label = "Copper",       chance = 80,   quantity = {1,2},  exp = 4},
        {name = "salt",       label = "Salt",         chance = 70,   quantity = {1,2},  exp = 4},
        {name = "clay",       label = "Clay",         chance = 60,   quantity = {1,2},  exp = 5},

        {name = "iron",       label = "Iron",         chance = 50,   quantity = {1,2},  exp = 5},
        {name = "silver",     label = "Silver",       chance = 30,   quantity = {1,2},  exp = 6},
        {name = "goldnugget", label = "Gold Nuggets", chance = 20,   quantity = {1,2},  exp = 10},
        {name = "platinum",   label = "Platinum",     chance = 10,   quantity = {1,1},  exp = 20},
    },

    ['Tumbleweed'] = {

        {name = "rock",       label = "Rocks",        chance = 100,  quantity = {1,2},  exp = 2},
        {name = "copper",     label = "Copper",       chance = 80,   quantity = {1,1},  exp = 4},

        {name = "coal",       label = "Coal",         chance = 70,   quantity = {1,2},  exp = 3},
        {name = "salt",       label = "Salt",         chance = 60,   quantity = {1,2},  exp = 4},
        
        {name = "iron",       label = "Iron",         chance = 50,   quantity = {1,2},  exp = 5},
        {name = "silver",     label = "Silver",       chance = 30,   quantity = {1,2},  exp = 6},
        {name = "goldnugget", label = "Gold Nuggets", chance = 20,   quantity = {1,2},  exp = 10},
        {name = "diamond",    label = "Diamond",      chance = 5,    quantity = {1,1},  exp = 25},
    },

    ['CotorraSprings'] = {
        {name = "sulfur",     label = "Sulfur",       chance = 50,   quantity = {1,1},  exp = 5},
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
