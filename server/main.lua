local QBCore = exports['qb-core']:GetCoreObject()
local plowLevel = 0

-- Applies snow removal config to plow level and notifies players
local function UpdatePlowLevel(jobType, groupCount)
    local plowClear = 0

    if jobType == 'small' then
        plowClear = Config.SmallPlowClear * groupCount
        TriggerClientEvent('QBCore:Notify', -1, 'Roads are slightly improved', 'success')
    elseif jobType == 'medium' then
        plowClear = Config.MediumPlowClear * groupCount
        TriggerClientEvent('QBCore:Notify', -1, 'Roads are improved', 'success')
    elseif jobType == 'large' then
        plowClear = Config.LargePlowClear * groupCount
        TriggerClientEvent('QBCore:Notify', -1, 'Roads are drastically improved', 'success')
    end

    plowLevel = plowLevel + plowClear
end

if Config.IsSnowSeason and Config.CommunityImpact then
    exports['qb-weathersync']:setDynamicWeather(false)

    -- Snow accumulation thread
    CreateThread(function()
        while true do
            plowLevel = plowLevel - 1

            if plowLevel < 0 then
                plowLevel = 0
                TriggerClientEvent('QBCore:Notify', -1, 'Snowfall is overwhelming')
            elseif plowLevel < Config.StablePowerPlowLevel then
                TriggerClientEvent('QBCore:Notify', -1, 'Snow is disrupting regulated power')
            elseif plowLevel < Config.StablePowerPlowLevel + ( ( Config.ClearRoadPlowLevel - Config.StablePowerPlowLevel ) / 2 ) then
                TriggerClientEvent('QBCore:Notify', -1, 'Snow is starting to clear')
            elseif plowLevel < Config.ClearRoadPlowLevel then
                TriggerClientEvent('QBCore:Notify', -1, 'Snow is almost cleared')
            else
                TriggerClientEvent('QBCore:Notify', -1, 'Snow is accumulating slowly')
            end

            EnforceWeatherPattern(plowLevel)
            print('Plow level at: '..tostring(plowLevel))
            Wait(900000) -- 15 minutes
        end
    end)

    -- Power loss thread
    CreateThread(function()
        while true do
            EnforcePowerLossPattern(plowLevel)
            Wait(Config.PowerLossRandomFrequency(plowLevel))
        end
    end)
elseif Config.IsSnowSeason then
    EnforceWeatherPattern(plowLevel)
end

-- Helper for getting peds in a vehicle
local function GetPlayersInVehicle(veh)
    local peds = {}
    local ped

    for i=-1,4 do
        ped = GetPedInVehicleSeat(veh, i)

        if ped ~= 0 then
            peds[ped] = 0
        end
    end

    local players = {}

    for _,v in pairs(QBCore.Functions.GetQBPlayers()) do
        if peds[GetPlayerPed(v.PlayerData.source)] then
            table.insert(players, v)
        end
    end

    return players
end

-- Finish a plow job for a player
RegisterNetEvent('pc-snowplow:server:FinishJob', function(jobType, groupCount)
    local src = source
    local ped = GetPlayerPed(src)
    local veh = GetVehiclePedIsIn(ped, false)
    local earners = GetPlayersInVehicle(veh)

    for _,v in ipairs(earners) do
        if v.PlayerData.job.name == 'snowplow' then
            PayoutJobRates(v, jobType, groupCount)
            UpdatePlowLevel(jobType, groupCount)
        elseif v.PlayerData.source == src then
            DropPlayer(src, 'pc-snowplow:server:FinishJob exploit attempt')
        end
    end
end)
