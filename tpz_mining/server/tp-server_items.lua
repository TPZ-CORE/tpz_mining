local TPZInv = exports.tpz_inventory:getInventoryAPI()

-----------------------------------------------------------
--[[ Items Registration  ]]--
-----------------------------------------------------------

TPZInv.registerUsableItem(Config.PickaxeItem, GetCurrentResourceName(), function(data)
	local _source = data.source

	if Config.Durability.Enabled and data.durability <= 0 then
		SendNotification(_source, Locales['NOT_DURABILITY'])
		return
	end

    TriggerClientEvent('tpz_mining:client:onPickaxeItemUse', _source, data.itemId )

end)