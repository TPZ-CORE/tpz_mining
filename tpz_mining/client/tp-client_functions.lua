Prompt     = GetRandomIntInRange(0, 0xffffff)
PromptList = nil


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

RegisterPrompts = function()
    local str = Locales['MINING']

    PromptList = PromptRegisterBegin()
    PromptSetControlAction(PromptList, Config.ActionKey)
    str = CreateVarString(10, 'LITERAL_STRING', str)
    PromptSetText(PromptList, str)
    PromptSetEnabled(PromptList, 1)
    PromptSetVisible(PromptList, 1)
    PromptSetStandardMode(PromptList, 1)
    PromptSetGroup(PromptList, Prompt)
    Citizen.InvokeNative(0xC5F428EE08FA7F2C, PromptList, true)
    PromptRegisterEnd(PromptList)
end

-----------------------------------------------------------
--[[ General Functions ]]--
-----------------------------------------------------------

function Anim(actor, dict, body, duration, flags, introtiming, exittiming)
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

function LoadModel(model)
    local model = joaat(model)
    RequestModel(model)

    while not HasModelLoaded(model) do RequestModel(model)
        Citizen.Wait(10)
    end
end

function OnPickaxeEquip(toolhash)

    Citizen.InvokeNative(0x6A2F820452017EA2) -- Clear Prompts from Screen

    if ClientData.PickaxeTool then
        DeleteEntity(ClientData.PickaxeTool)
    end

    LoadModel(toolhash)
    
    Wait(500)

    local ped = PlayerPedId()

    SetCurrentPedWeapon(ped, joaat("WEAPON_UNARMED"), true, 0, false, false)
    
    ClientData.PickaxeTool = CreateObject(toolhash, GetOffsetFromEntityInWorldCoords(ped,0.0,0.0,0.0), true, true, true)
    AttachEntityToEntity(ClientData.PickaxeTool, ped, GetPedBoneIndex(ped, 7966), 0.0,0.0,0.0,  0.0,0.0,0.0, 0, 0, 0, 0, 2, 1, 0, 0);
    Citizen.InvokeNative(0x923583741DC87BCE, ped, 'arthur_healthy')
    Citizen.InvokeNative(0x89F5E7ADECCCB49C, ped, "carry_pitchfork")
    Citizen.InvokeNative(0x2208438012482A1A, ped, true, true)
    ForceEntityAiAndAnimationUpdate(ClientData.PickaxeTool, 1)
    Citizen.InvokeNative(0x3A50753042B6891B, ped, "PITCH_FORKS")
end

function CanPlayerDoAction(player)
    if IsPedOnMount(player) or IsPedInAnyVehicle(player) or IsPedDeadOrDying(player) or IsPedClimbing(player) or not IsPedOnFoot(player) then
        return false
    end

    return true
end
