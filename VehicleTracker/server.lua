local ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(source, xPlayer)
    local hasVehicles = false
    
    for index, item in pairs(Config.WhitelistedVehicles) do
        if xPlayer.getJob().name == item.job then
            hasVehicles = true
            break
        end
    end
    
    if hasVehicles then
        exports.oxmysql:execute('SELECT plate, owner FROM owned_vehicles WHERE owner = ?', {
            xPlayer.getJob().name
        }, function(results)
            local vehicles = {}

            for i=1, #results do
                table.insert(vehicles, {
                    plate = results[i].plate,
                    owner = results[i].owner
                })
            end

            TriggerClientEvent('tut_gps:sendSocietyVehiclesToClient', source, vehicles)
        end)
    end
end)
