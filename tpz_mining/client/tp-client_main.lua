local PlayerData = {
    IsHoldingPickaxe = false,
    ObjectEntity     = nil,

    IsBusy           = false,
    
    ItemId           = 0,
    Durability       = 100,

    Job              = "unemployed",
}

-----------------------------------------------------------
--[[ Functions ]]--
-----------------------------------------------------------

function GetPlayerData()
    return PlayerData
end

-----------------------------------------------------------
--[[ Local Functions ]]--
-----------------------------------------------------------

-- @GetTableLength returns the length of a table.
local function GetTableLength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end

local function HasRequiredJob(currentJob)

	if not Config.Jobs or Config.Jobs and GetTableLength(Config.Jobs) <= 0 then
		return true
	end

	for _, job in pairs (Config.Jobs) do

		if job == currentJob then
			return true
		end
		
	end

	return false

end

-----------------------------------------------------------
--[[ Base Events ]]--
-----------------------------------------------------------

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end

    if PlayerData.IsHoldingPickaxe then

        ClearPedTasks(PlayerPedId())

        Citizen.InvokeNative(0xED00D72F81CF7278, PlayerData.ObjectEntity, 1, 1) -- DetachCarriableEntity

        RemoveEntityProperly(PlayerData.ObjectEntity, joaat(Config.ObjectModel) )
        Citizen.InvokeNative(0x58F7DB5BD8FA2288, PlayerPedId()) -- Cancel Walk Style

        PlayerData.IsHoldingPickaxe = false
    end

    
    for i, v in pairs(Config.MiningZones) do

        if v.BlipHandle then
            RemoveBlip(v.BlipHandle)
        end

    end

end)

-----------------------------------------------------------
--[[ Base Events ]]--
-----------------------------------------------------------

-- Gets the player job when devmode set to false and character is selected.
AddEventHandler("tpz_core:isPlayerReady", function()
    Wait(2000)
    
    local data = exports.tpz_core:getCoreAPI().GetPlayerClientData()

    if data == nil then
        return
    end

    PlayerData.Job = data.job
end)

-- Updates the player job.
RegisterNetEvent("tpz_core:getPlayerJob")
AddEventHandler("tpz_core:getPlayerJob", function(data)
    PlayerData.Job = data.job
end)

-----------------------------------------------------------
--[[ Events ]]--
-----------------------------------------------------------

-- When following event is triggered, if the player is not holding any pickaxe, we attach it, otherwise we detach the pickaxe.
RegisterNetEvent("tpz_mining:client:onPickaxeItemUse")
AddEventHandler("tpz_mining:client:onPickaxeItemUse", function(itemId)
    local playerPed = PlayerPedId()

    if not PlayerData.IsHoldingPickaxe then

        PlayerData.IsHoldingPickaxe = true

        OnPickaxeEquip()

        PlayerData.ItemId = itemId

    else

        ClearPedTasks(playerPed)
        Citizen.InvokeNative(0xED00D72F81CF7278, PlayerData.ObjectEntity, 1, 1)
        DeleteObject(PlayerData.ObjectEntity)
        Citizen.InvokeNative(0x58F7DB5BD8FA2288, playerPed) -- Cancel Walk Style

        PlayerData.IsHoldingPickaxe = false
    end
end)


---------------------------------------------------------------
-- Threads
---------------------------------------------------------------

-- Gets the player job when devmode set to true.
if Config.DevMode then

    Citizen.CreateThread(function ()

        Wait(2000)

        local data = exports.tpz_core:getCoreAPI().GetPlayerClientData()

        if data == nil then
            return
        end

        PlayerData.Job = data.job
    end)

end

Citizen.CreateThread(function()
    RegisterPromptAction()

    while true do
        Citizen.Wait(0)
        local sleep    = true
        local player   = PlayerPedId()
        local coords   = GetEntityCoords(PlayerPedId())

        local isDead = IsEntityDead(player)

        if not isDead and PlayerData.IsHoldingPickaxe and not PlayerData.IsBusy then

            for index, miningConfig in pairs(Config.MiningZones) do

                local coordsDist = vector3(coords.x, coords.y, coords.z)

                for k, v in pairs(miningConfig.ActionCoords) do

                    local actionCoords = vector3(v.x, v.y, v.z)
                    local distance = #(coordsDist - actionCoords)

                    if Config.DisplayActionMarkers then
                        if distance <= Config.DisplayActionMarkersDistance then
                            sleep = false
            
                            local rgba = Config.DisplayActionMarkersRGBA
                            Citizen.InvokeNative(0x2A32FAA57B937173, 0x94FDAE17, v.x, v.y, v.z - 1.2, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 0.7, rgba.r, rgba.g, rgba.b, rgba.a, false, true, 2, false, false, false, false)
                        end
                    end

                    if distance <= 1.0 then

                        sleep = false

                        local promptGroup, promptList = GetPromptData()

                        local label = CreateVarString(10, 'LITERAL_STRING', Locales['MINING'] )
                        PromptSetActiveGroupThisFrame(promptGroup, label)

                        if PromptHasHoldModeCompleted(promptList) then

                            local hasRequiredJob = HasRequiredJob(PlayerData.Job)

                            if (hasRequiredJob) then

                                PlayerData.IsBusy = true

                                SetCurrentPedWeapon(player, GetHashKey("WEAPON_UNARMED"), true, 0, false, false)
    
                                Citizen.Wait(500)

                                local isMining = true
                            
                                Citizen.CreateThread(function() 
                                    while isMining do 
                                        Wait(0) 
                                        Anim(player,'amb_work@world_human_pickaxe@wall@male_d@base', 'base', -1,0)
                                        Wait(2000)
                                    end
                                end)
                        
                                Citizen.Wait(1000 * Config.MiningTimer)

                                TriggerServerEvent("tpz_mining:server:success", miningConfig.City, PlayerData.ItemId)
                        
                                ClearPedTasks(player)
                                RemoveAnimDict("amb_work@world_human_pickaxe@wall@male_d@base") -- must remove the dict of animation

                                isMining = false
                                PlayerData.IsBusy = false
                            
                            else
                                SendNotification(nil, Locales['NOT_REQUIRED_JOB'], "error")
                            end

                        end

                    end
                end

            end

        end
            
        -- In case the player dies, we detach the pickaxe and all current data.
        if PlayerData.IsHoldingPickaxe and isDead then

            ClearPedTasks(player)
            Citizen.InvokeNative(0xED00D72F81CF7278, PlayerData.ObjectEntity, 1, 1)
            DeleteObject(PlayerData.ObjectEntity)
            Citizen.InvokeNative(0x58F7DB5BD8FA2288, player) -- Cancel Walk Style
    
            PlayerData.IsHoldingPickaxe = false

        end

        if sleep then
            Citizen.Wait(1250)
        end
    end
end)

---------------------------------------------------------------
-- Threads
---------------------------------------------------------------

Citizen.CreateThread(function()
    while true do
        Wait(0)

        if PlayerData.IsBusy then
            TriggerEvent('tpz_inventory:closePlayerInventory')
        end

        if PlayerData.IsHoldingPickaxe then
        
            DisableControlAction(0, 0xCC1075A7, true) -- MWUP
            DisableControlAction(0, 0xDB096B85, true) -- MWDOWN

            DisableControlAction(0, 0x07CE1E61) -- MOUSE1
            DisableControlAction(0, 0xF84FA74F) -- MOUSE2
            DisableControlAction(0, 0xAC4BD4F1) -- TAB
            DisableControlAction(0, 0xCEFD9220) -- MOUNT
            DisableControlAction(0, 0x4CC0E2FE) -- B
            DisableControlAction(0, 0x8CC9CD42) -- X
            DisableControlAction(0, 0x26E9DC00) -- Z
            DisableControlAction(0, 0xDB096B85) -- CTRL       

        else
            Wait(1000)
        end

    end

end)
