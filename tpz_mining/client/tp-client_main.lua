

ClientData = {
    IsHoldingPickaxe = false,
    PickaxeTool      = nil,

    IsBusy           = false,
    
    ItemId           = 0,
    Durability       = 100,

    Job              = "unemployed",
}

-----------------------------------------------------------
--[[ Base Events ]]--
-----------------------------------------------------------

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end

    if ClientData.IsHoldingPickaxe then

        ClearPedTasks(PlayerPedId())
        Citizen.InvokeNative(0xED00D72F81CF7278, ClientData.PickaxeTool, 1, 1)
        DeleteObject(ClientData.PickaxeTool)
        Citizen.InvokeNative(0x58F7DB5BD8FA2288, PlayerPedId()) -- Cancel Walk Style

        ClientData.IsHoldingPickaxe = false

        ClearPedTasks(PlayerPedId())
    end

    
    for i, v in pairs(Config.MiningZones) do
        if v.BlipHandle then
            RemoveBlip(v.BlipHandle)
        end

    end

end)

-- Gets the player job when devmode set to false and character is selected.
AddEventHandler("tpz_core:isPlayerReady", function()

    TriggerEvent("tpz_core:ExecuteServerCallBack", "tpz_core:getPlayerData", function(data)
        ClientData.Job = data.job
    end)

end)

-- Updates the player job.
RegisterNetEvent("tpz_core:getPlayerJob")
AddEventHandler("tpz_core:getPlayerJob", function(data)
    ClientData.Job = data.job
end)

-- Gets the player job when devmode set to true.
if Config.DevMode then
    Citizen.CreateThread(function ()

        Wait(2000)

        TriggerEvent("tpz_core:ExecuteServerCallBack", "tpz_core:getPlayerData", function(data)
            ClientData.Job = data.job
        end)

    end)
end

-----------------------------------------------------------
--[[ Events ]]--
-----------------------------------------------------------

-- When following event is triggered, if the player is not holding any pickaxe, we attach it, otherwise we detach the pickaxe.
RegisterNetEvent("tpz_mining:onPickaxeItemUse")
AddEventHandler("tpz_mining:onPickaxeItemUse", function(itemId, durability)
    local playerPed    = PlayerPedId()

    if not ClientData.IsHoldingPickaxe then

        ClientData.IsHoldingPickaxe = true

        OnPickaxeEquip('p_pickaxe01x', 'Swing')

        ClientData.ItemId     = itemId
        ClientData.Durability = durability

    else

        ClearPedTasks(playerPed)
        Citizen.InvokeNative(0xED00D72F81CF7278, ClientData.PickaxeTool, 1, 1)
        DeleteObject(ClientData.PickaxeTool)
        Citizen.InvokeNative(0x58F7DB5BD8FA2288, playerPed) -- Cancel Walk Style

        ClientData.IsHoldingPickaxe = false
    end
end)


-- The following event is triggered to update the current durability during changes (actions).
RegisterNetEvent('tpz_mining:updateDurability')
AddEventHandler('tpz_mining:updateDurability', function(cb)
    ClientData.Durability = cb
end)

---------------------------------------------------------------
-- Threads
---------------------------------------------------------------

Citizen.CreateThread(function()
    RegisterPrompts()

    while true do
        Citizen.Wait(0)
        local sleep    = true
        local player   = PlayerPedId()
        local coords   = GetEntityCoords(PlayerPedId())

        local isDead = IsEntityDead(player)
        local canPerformAction = CanPlayerDoAction(player)

        if not isDead and ClientData.IsHoldingPickaxe and not ClientData.IsBusy and canPerformAction then

            if (Config.OnlyJob and ClientData.Job == Config.Job) or (not Config.OnlyJob) then

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
    
                            local label = CreateVarString(10, 'LITERAL_STRING', Locales['MINING'] .. " | " .. ClientData.Durability .. "%")
                            PromptSetActiveGroupThisFrame(Prompt, label)
    
                            if Citizen.InvokeNative(0xC92AC953F0A982AE, PromptList) then
                                ClientData.IsBusy = true
    
                                SetCurrentPedWeapon(player, GetHashKey("WEAPON_UNARMED"), true, 0, false, false)
    
                                Citizen.Wait(500)
    
                                TriggerEvent("tpz_core:ExecuteServerCallBack", "tpz_mining:getRandomOreRewardData", function(data)
    
                                    local isMining     = true
                            
                                    Citizen.CreateThread(function() 
                                        while isMining do 
                                            Wait(0) 
                                            Anim(player,'amb_work@world_human_pickaxe@wall@male_d@base', 'base', -1,0)
                                            Wait(2000)
                                        end
                                    end)
                            
                                    Citizen.Wait(1000 * Config.MiningTimer)
    
                                    TriggerServerEvent("tpz_mining:onMiningSuccessReward", data)
                            
                                    ClearPedTasks(player)
                            
                                    if Config.DurabilityRemove then
                                            
                                        TriggerServerEvent("tpz_mining:removeDurability", ClientData.ItemId)
                            
                                        Wait(500)
                                        TriggerServerEvent("tpz_mining:requestDurability", ClientData.ItemId)
                            
                                    end
    
                                    
                                    isMining = false
                                    ClientData.IsBusy = false
                            
                            
                                end, miningConfig.City)
    
                            end
    
                        end
                    end
    
                end

            end
            
        end

        -- In case the player dies, we detach the pickaxe and all current data.
        if ClientData.IsHoldingPickaxe and isDead then
            TriggerEvent("tpz_mining:onPickaxeItemUse")
        end

        if sleep then
            Citizen.Wait(1250)
        end
    end
end)

-- The following thread is disabling control actions while player has a pickaxe attached.
if Config.KeyControls.Disable then

    Citizen.CreateThread(function()
        while true do
            Wait(0)

            if ClientData.IsHoldingPickaxe then

                for index, control in pairs (Config.KeyControls.Controls) do
                    DisableControlAction(0, control)
                end

                if ClientData.IsBusy then
                    DisableControlAction(0, Config.KeyControls.InventoryControl)
                end

            else
                Wait(1000)
            end
        end
    end)

end
