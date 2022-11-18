local QBCore = exports['qb-core']:GetCoreObject()

-- Weather enforcement function
function EnforceWeatherPattern(plowLevel)
    if Config.CommunityImpact then
        if plowLevel < Config.ClearRoadPlowLevel then
            exports[Config.WeatherResource]:setWeather('XMAS')
        else
            exports[Config.WeatherResource]:setWeather(Config.ClearWeatherType)
        end
    else
        exports[Config.WeatherResource]:setWeather('XMAS')
    end
end

-- Power loss enforcement function
function EnforcePowerLossPattern(plowLevel)
    if Config.CommunityImpact then
        if plowLevel < Config.StablePowerPlowLevel then
            local startTime = GetGameTimer()
            local duartion = Config.PowerLossRandomDuration(plowLevel)
            exports["qb-weathersync"]:setBlackout(true)
            TriggerClientEvent('QBCore:Notify', -1, "The city's power cuts out")

            while GetGameTimer() - startTime <= duartion do
                Wait(0)
            end

            exports["qb-weathersync"]:setBlackout(false)
            TriggerClientEvent('QBCore:Notify', -1, "The city's power returns")
        end
    end
end

local function PickRandomPay(payout, count)
    return math.random(
        math.floor(count * (payout - (Config.PayoutRange/2))),
        math.ceil(count * (payout + (Config.PayoutRange/2)))
    )
end

-- Pay player for job completion
function PayoutJobRates(player, jobType, groupCount)
    local payout = 0

    if jobType == 'small' then
        payout = PickRandomPay(Config.SmallPayout, groupCount)
    elseif jobType == 'medium' then
        payout = PickRandomPay(Config.MediumPayout, groupCount)
    elseif jobType == 'large' then
        payout = PickRandomPay(Config.LargePayout, groupCount)
    end

    if Config.PayoutSnowballs then
        if not QBCore.Functions.HasItem(player.PlayerData.source, 'weapon_snowball') then
            if player.Functions.AddItem('weapon_snowball') then
                TriggerClientEvent('inventory:client:ItemBox', player.PlayerData.source, QBCore.Shared.Items['weapon_snowball'], 'add')
            end
        end
    end

    player.Functions.AddMoney('cash', payout)
end
