local TPZ    = {}
local TPZInv = exports.tpz_inventory:getInventoryAPI()

TriggerEvent("getTPZCore", function(cb) TPZ = cb end)

-----------------------------------------------------------
--[[ Events ]]--
-----------------------------------------------------------

RegisterServerEvent("tpz_mining:onMiningSuccessReward")
AddEventHandler("tpz_mining:onMiningSuccessReward", function(reward)
	local _source         = source
	local xPlayer         = TPZ.GetPlayer(_source)

    local identifier      = xPlayer.getIdentifier()
    local charidentifier  = xPlayer.getCharacterIdentifier()
    local steamName       = GetPlayerName(_source)

    local webhookData     = Config.Webhooking
    local message         = "**Steam name: **`" .. steamName .. "`**\nIdentifier: **`" .. identifier .. " (Char: " .. charidentifier .. ") `"


	local quantity  = math.random(reward.quantity[1], reward.quantity[2])

	if reward.name == "nothing" then
		SendNotification(_source, Locales['FOUND_NOTHING'], "error")
		return
	end
	
	if Config.tpz_leveling then
		TriggerEvent("tpz_leveling:AddLevelExperience", _source, "mining", tonumber(reward.exp))
	end

	local canCarryItem = TPZInv.canCarryItem(_source, reward.name, quantity)

	Wait(500)

	if canCarryItem then

		TPZInv.addItem(_source, reward.name, quantity, nil)

		SendNotification(_source, string.format(Locales['SUCCESSFULLY_FOUND'], quantity, reward.label), "success")

		if webhookData.Enable then
			local title = "⛏️` The following player found X" .. quantity .. " " .. reward.label .. ".`"
			TriggerEvent("tpz_core:sendToDiscord", webhookData.Url, title, message, webhookData.Color)
		end

	else
		SendNotification(_source, Locales['CANNOT_CARRY'], "error")
	end

end)

-- The following event is triggered to update the current pickaxe durability in client side for updating properly.
RegisterServerEvent("tpz_mining:requestDurability")
AddEventHandler("tpz_mining:requestDurability", function(itemId)
	local _source           = source

    local currentDurability = TPZInv.getItemDurability(_source, Config.PickaxeItem, itemId)
    TriggerClientEvent('tpz_mining:updateDurability', _source, currentDurability)
end)

-- The following event is triggered on every action in order to remove the requested durability.
RegisterServerEvent("tpz_mining:removeDurability")
AddEventHandler("tpz_mining:removeDurability", function(itemId)
	local _source           = source

    local currentDurability = TPZInv.getItemDurability(_source, Config.PickaxeItem, itemId)

    if currentDurability <= 0 then
        return
    end

	local randomDurability = math.random(Config.DurabilityRemove[1], Config.DurabilityRemove[2])

	TPZInv.removeItemDurability(_source, Config.PickaxeItem, randomDurability, itemId, false)

    -- We check if the amount we removed goes to 0, to remove the pickaxe from the player hands after finishing the grave robbery.
    if (currentDurability - randomDurability) <= 0 then
        TriggerClientEvent('tpz_mining:onPickaxeItemUse', _source, 0, 100)
    end

end)

--------------------------------------------------------------------------------------------------------
-- Callbacks
--------------------------------------------------------------------------------------------------------

exports.tpz_core:server().addNewCallBack("tpz_mining:getRandomOreRewardData", function(source, cb, city)

	local rewards  = {}
    local chance   =  math.random(1, 100)
	local finished = false
	local added    = false

	for k,v in pairs(Config.Items[city]) do 
		
		if v.chance >= chance then
			table.insert(rewards, v)
			added = true
		end

		if next(Config.Items[city], k) == nil then
			finished = true
		end
	end

	while not finished do
		Wait(10)
	end

	if added then
		chance   =  math.random(1, 100)
		local index, value = NearestValue(rewards, chance)
		cb(value)
	else

		cb({name = "nothing"})
	end

end)

---------------------------------------------------------------------------------------------------
-- Functions
---------------------------------------------------------------------------------------------------

function NearestValue(table, number)
    local smallestSoFar, smallestIndex
    for i, y in ipairs(table) do
        if not smallestSoFar or (math.abs(number-y.chance) < smallestSoFar) then
            smallestSoFar = math.abs(number-y.chance)
            smallestIndex = i
        end
    end
    return smallestIndex, table[smallestIndex]
end
