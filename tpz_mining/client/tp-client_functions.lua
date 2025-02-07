local Prompts     = GetRandomIntInRange(0, 0xffffff)
local PromptList = nil

-----------------------------------------------------------
--[[ Blips ]]--
-----------------------------------------------------------

Citizen.CreateThread(function ()

    for k, v in pairs (Config.MiningZones) do

        if v.Blips.Enabled  then
    
            v.BlipHandle = N_0x554d9d53f696d002(1664425300, v.Blips.Coords.x, v.Blips.Coords.y, v.Blips.Coords.z)
    
            SetBlipSprite(v.BlipHandle, v.Blips.Sprite, 1)
            SetBlipScale(v.BlipHandle, 0.2)
            Citizen.InvokeNative(0x662D364ABF16DE2F, v.BlipHandle, 0xA5C4F725)
            Citizen.InvokeNative(0x9CB1A1623062F402, v.BlipHandle, v.Blips.Label)
        end

    end
end)

-----------------------------------------------------------
--[[ Prompts ]]--
-----------------------------------------------------------

RegisterPromptAction = function()
    local str = Locales['MINING']

    local dPrompt = PromptRegisterBegin()

    PromptSetControlAction(dPrompt, Config.ActionKey)
    str = CreateVarString(10, 'LITERAL_STRING', str)
    PromptSetText(dPrompt, str)
    PromptSetEnabled(dPrompt, 1)
    PromptSetVisible(dPrompt, 1)
    PromptSetStandardMode(dPrompt, 1)
    PromptSetHoldMode(dPrompt, 1000)
    PromptSetGroup(dPrompt, Prompts)
    Citizen.InvokeNative(0xC5F428EE08FA7F2C, dPrompt, true)
    PromptRegisterEnd(dPrompt)

    PromptList = dPrompt
end

function GetPromptData()
    return Prompts, PromptList
end

---------------------------------------------------------------
-- Action
---------------------------------------------------------------

Anim = function(actor, dict, body, duration, flags, introtiming, exittiming)
    Citizen.CreateThread(function()
        RequestAnimDict(dict)
        local dur = duration or -1
        local flag = flags or 1
        local intro = tonumber(introtiming) or 1.0
        local exit = tonumber(exittiming) or 1.0
        timeout = 5
        while (not HasAnimDictLoaded(dict) and timeout>0) do
            timeout = timeout-1
            if timeout == 0 then 
                print("Animation Failed to Load")
            end
            Citizen.Wait(300)
        end
        TaskPlayAnim(actor, dict, body, intro, exit, dur, flag --[[1 for repeat--]], 1, false, false, false, 0, true)
    end)
end

LoadModel = function(inputModel)
    local model = joaat(inputModel)
 
    RequestModel(model)
 
    while not HasModelLoaded(model) do RequestModel(model)
        Citizen.Wait(10)
    end
 end

RemoveEntityProperly = function(entity, objectHash)
    DeleteEntity(entity)
    DeletePed(entity)
    SetEntityAsNoLongerNeeded( entity )

    if objectHash then
        SetModelAsNoLongerNeeded(objectHash)
    end
end

OnPickaxeEquip = function(toolhash)
    local PlayerData = GetPlayerData()
    local ped        = PlayerPedId()

    Citizen.InvokeNative(0x6A2F820452017EA2) -- Clear Prompts from Screen
    SetCurrentPedWeapon(ped, joaat("WEAPON_UNARMED"), true, 0, false, false)

    if PlayerData.ObjectEntity then
        RemoveEntityProperly(PlayerData.ObjectEntity, joaat(Config.ObjectModel) )
    end

    LoadModel(Config.ObjectModel)

    PlayerData.ObjectEntity = CreateObject(joaat(Config.ObjectModel), GetOffsetFromEntityInWorldCoords(ped,0.0,0.0,0.0), true, true, true)

    AttachEntityToEntity(PlayerData.ObjectEntity, ped, GetPedBoneIndex(ped, 7966), 0.0,0.0,0.0,  0.0,0.0,0.0, 0, 0, 0, 0, 2, 1, 0, 0);
    
    Citizen.InvokeNative(0x923583741DC87BCE, ped, 'arthur_healthy')
    Citizen.InvokeNative(0x89F5E7ADECCCB49C, ped, "carry_pitchfork")
    Citizen.InvokeNative(0x2208438012482A1A, ped, true, true)
    ForceEntityAiAndAnimationUpdate(PlayerData.ObjectEntity, 1)
    Citizen.InvokeNative(0x3A50753042B6891B, ped, "PITCH_FORKS")
end