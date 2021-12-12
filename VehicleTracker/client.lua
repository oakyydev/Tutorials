ESX = nil
local spawnedVehicles = {}
local blips = {}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
    end
    
    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end
    
    ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    if job ~= ESX.PlayerData.job then
        for i = 1, #blips do
            if DoesBlipExist(blips[i]) then
                RemoveBlip(blips[i])
            end
        end
        blips = {}
    end
    ESX.PlayerData.job = job
end)

RegisterNetEvent('tut_gps:sendSocietyVehiclesToClient')
AddEventHandler('tut_gps:sendSocietyVehiclesToClient', function(veh)
    local vehicles = ESX.Game.GetVehicles()
    
    for i = 1, #vehicles do
        local props = ESX.Game.GetVehicleProperties(vehicles[i])
        for k = 1, #veh do
            if props.plate == veh[k].plate then
                createBlip(vehicles[k])
                table.insert(spawnedVehicles, veh[k].plate)
            end
        end
    end
end)

function createBlip(id)
    local blip = GetBlipFromEntity(id)
    
    if not DoesBlipExist(blip) then -- Add blip and create head display on player
        blip = AddBlipForEntity(id)
        SetBlipSprite(blip, 1)
        ShowHeadingIndicatorOnBlip(blip, true)-- Player Blip indicator
        SetBlipRotation(blip, math.ceil(GetEntityHeading(id)))-- update rotation
        SetBlipScale(blip, 0.85)-- set scale
        SetBlipAsShortRange(blip, true)
        table.insert(blips, blip)-- add blip to array so we can remove it later
    end
end
