local QBCore = exports['qb-core']:GetCoreObject()
local npcPed
local npcSpawned = false
local dutyCoords = vector3(Config.DutyLocation.x, Config.DutyLocation.y, Config.DutyLocation.z - 1)
local dutyHeading = Config.DutyLocation.w
local spawnCoords = vector3(Config.VehicleSpawnLocation.x, Config.VehicleSpawnLocation.y, Config.VehicleSpawnLocation.z)
local spawnHeading = Config.VehicleSpawnLocation.w
local doingJob = false
local jobSpot
local jobSize
local jobProgress = 0
local groupProgress = 1
local plowEntity
local blip

-- Create menu entries based on car list
local function CreateCarList(carList)
    local menuEntries = {}

    table.insert(menuEntries, {
        header = 'Plow options',
        icon = 'fas fa-snowplow',
        isMenuHeader = true,
    })

    table.insert(menuEntries, {
        header = 'Back',
        icon = 'fas fa-arrow-left',
        params = {
            event = 'pc-snowplow:client:OpenPlowMenu',
            args = {}
        }
    })

    for _,v in ipairs(carList) do
        local veh = QBCore.Shared.Vehicles[v]
        local vehicleName = veh.brand..' '..veh.name

        table.insert(menuEntries, {
            header = vehicleName,
            icon = 'fas fa-snowflake',
            params = {
                event = 'pc-snowplow:client:TakeJob',
                args = { vehicle = v }
            }
        })
    end

    return menuEntries
end

-- Reset local progress trackers and handles
local function ClearInternals()
    doingJob = false
    jobSpot = nil
    jobSize = nil
    jobProgress = 0
    groupProgress = 1
    plowEntity = nil
end

-- Start/stop handling
AddEventHandler('onClientResourceStart', function(name)
    if name == 'pc-snowplow' then
        -- Prepare config for use with draw functionality
        for k,v in ipairs({ Config.PlowLocationsSmall, Config.PlowLocationsMedium, Config.PlowLocationsLarge }) do -- Plow sizes
            for l,q in ipairs(v) do -- Job spots
                for m,r in ipairs(q) do -- Groups
                    r.Rads = r.Location.w / 180.00 * 3.14 -- Convert headings to radians, the preferred unit by trigonometry functions
                end
            end
        end

        -- Blip registration
        if Config.UseBlip then
            blip = AddBlipForCoord(Config.DutyLocation)
            SetBlipDisplay(blip, 2)
            SetBlipSprite(blip, Config.BlipSprite)
            SetBlipColour(blip, Config.BlipColor)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentSubstringPlayerName(Config.BlipTitle)
            EndTextCommandSetBlipName(blip)
        end
    end
end)

AddEventHandler('onClientResourceStop', function(name)
    if name == 'pc-snowplow' then
        -- Blip deregistration
        if Config.UseBlip then
            RemoveBlip(blip)
        end
    end
end)

-- Job menus
RegisterNetEvent('pc-snowplow:client:OpenPlowMenu', function()
    local playerData = QBCore.Functions.GetPlayerData()

    if playerData.job and playerData.job.name == Config.JobName then
        exports[Config.MenuResource]:openMenu({
            {
                header = 'Snowplow Jobs',
                icon = 'fas fa-snowflake',
                isMenuHeader = true,
            },
            {
                header = 'Small',
                txt = 'A small plowing job',
                icon = 'fas fa-hammer',
                params = {
                    event = 'pc-snowplow:client:OpenJobsMenu',
                    args = { size = 'small' }
                }
            },
            {
                header = 'Medium',
                txt = 'A medium plowing job',
                icon = 'fas fa-truck-pickup',
                params = {
                    event = 'pc-snowplow:client:OpenJobsMenu',
                    args = { size = 'medium' }
                }
            },
            {
                header = 'Large',
                txt = 'A large plowing job',
                icon = 'fas fa-snowplow',
                params = {
                    event = 'pc-snowplow:client:OpenJobsMenu',
                    args = { size = 'large' }
                }
            },
        })
    end
end)

RegisterNetEvent('pc-snowplow:client:OpenJobsMenu', function(data)
    local playerData = QBCore.Functions.GetPlayerData()

    if playerData.job.name == Config.JobName then
        local menuEntries
        jobSize = data.size

        if jobSize == 'small' then
            menuEntries = CreateCarList(Config.SmallPlows, 'small')
        elseif jobSize == 'medium' then
            menuEntries = CreateCarList(Config.MediumPlows, 'medium')
        elseif jobSize == 'large' then
            menuEntries = CreateCarList(Config.LargePlows, 'large')
        end

        if menuEntries then
            exports[Config.MenuResource]:openMenu(menuEntries)
        end
    else
        exports[Config.MenuResource]:closeMenu()
        TriggerEvent('QBCore:Notify', 'You are not on duty', 'error')
        ClearInternals()
    end
end)

RegisterNetEvent('pc-snowplow:client:TakeJob', function(data)
    local playerData = QBCore.Functions.GetPlayerData()

    if playerData.job.name == Config.JobName then
        local vehicle = data.vehicle

        if doingJob then
            TriggerEvent('QBCore:Notify', 'Previous job was cancelled')
        end

        SetEntityCoords(PlayerPedId(), spawnCoords, false, false, false, true)
        SetEntityHeading(PlayerPedId(), spawnHeading)
        TriggerEvent('QBCore:Command:SpawnVehicle', vehicle)
        Wait(1000)

        local plate = "PLWG"..tostring(math.random(1000, 9999))
        plowEntity = GetVehiclePedIsIn(PlayerPedId(), false)
        TriggerServerEvent('qb-vehiclekeys:server:AcquireVehicleKeys', plate)

        SetVehicleNumberPlateText(plowEntity, plate)
        SetVehicleEngineOn(plowEntity, true, true)
        exports[Config.FuelResource]:SetFuel(plowEntity, 100)
        TriggerEvent('pc-snowplow:client:SetNextJobSpot')
    else
        TriggerEvent('QBCore:Notify', 'You are not on duty', 'error')
        ClearInternals()
    end

    exports[Config.MenuResource]:closeMenu()
end)

-- Fetch a new group spot
RegisterNetEvent('pc-snowplow:client:SetNextGroupSpot', function()
    local playerData = QBCore.Functions.GetPlayerData()

    if playerData.job.name == Config.JobName then
        jobProgress = 0
        groupProgress = groupProgress + 1

        if jobSpot[groupProgress] then
            SetNewWaypoint(jobSpot[groupProgress].Location.x, jobSpot[groupProgress].Location.y)
        end
    else
        TriggerEvent('QBCore:Notify', 'You are not on duty', 'error')
        ClearInternals()
    end
end)

-- Fetch a new job spot
RegisterNetEvent('pc-snowplow:client:SetNextJobSpot', function()
    local playerData = QBCore.Functions.GetPlayerData()

    if playerData.job.name == Config.JobName then
        jobSpot = PickRandomJob(jobSize)
        jobProgress = 0
        groupProgress = 1
        doingJob = true

        if jobSpot then
            SetNewWaypoint(jobSpot[groupProgress].Location.x, jobSpot[groupProgress].Location.y)
        else
            TriggerEvent('QBCore:Notify', 'No jobs are available', 'error')
        end
    else
        TriggerEvent('QBCore:Notify', 'You are not on duty', 'error')
        ClearInternals()
    end
end)

-- Return plow
RegisterNetEvent('pc-snowplow:client:ReturnPlow', function()
    local playerData = QBCore.Functions.GetPlayerData()

    if playerData.job.name == Config.JobName then
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        local plate = GetVehicleNumberPlateText(veh, plate)

        if string.sub(plate, 1, 4) == 'PLWG' then
            TriggerEvent('QBCore:Command:DeleteVehicle')
            TriggerEvent('QBCore:Notify', 'Plow has been returned')
            ClearInternals()
        end
    end
end)

-- NPC spawn thread
CreateThread(function()
    local coords

    while true do
        coords = GetEntityCoords(PlayerPedId())

        if #(dutyCoords - coords) < 100.00 and not npcSpawned then
            local hash = GetHashKey(Config.DutyPedModel)

            QBCore.Functions.LoadModel(hash)
            npcPed = CreatePed(0, hash, dutyCoords, dutyHeading, false, false)

            if npcPed ~= 0 then
                npcSpawned = true

                SetModelAsNoLongerNeeded(hash)
                SetEntityInvincible(npcPed, true)
                SetBlockingOfNonTemporaryEvents(npcPed, true)
                FreezeEntityPosition(npcPed, true)
                TaskStartScenarioInPlace(npcPed, 'WORLD_HUMAN_CLIPBOARD', 0, true)

                -- NPC
                exports[Config.TargetResource]:AddEntityZone('plowperson', npcPed, {
                    name = 'plowperson',
                    heading = dutyHeading,
                    debugPoly = false,
                    useZ = true
                }, {
                    options = {{
                        event = 'pc-snowplow:client:OpenPlowMenu',
                        icon = 'fas fa-snowplow',
                        label = 'Accept a job',
                        job = "snowplow"
                    }},
                    distance = 3.0
                })
            end
        elseif #(dutyCoords - coords) >= 100.00 and npcSpawned then
            DeleteEntity(npcPed)
            npcSpawned = false
            npcPed = nil
        end

        Wait(1000)
    end
end)

-- Plow return thread
CreateThread(function()
    local coords

    while true do
        local playerData = QBCore.Functions.GetPlayerData()

        if playerData.job.name == Config.JobName then
            coords = GetEntityCoords(PlayerPedId())

            if #(Config.ReturnLocation - coords) <= Config.ReturnRange then
                TriggerEvent('pc-snowplow:client:ReturnPlow')
            end

            Wait(1000)
        else
            Wait(5000)
        end
    end
end)

-- Plowing markers thread
CreateThread(function()
    local coords

    while true do
        local playerData = QBCore.Functions.GetPlayerData()

        if doingJob and jobSize and jobSpot and playerData.job.name == Config.JobName then
            coords = GetEntityCoords(PlayerPedId())

            local groupSpot = jobSpot[groupProgress]
            local groupLoc = groupSpot.Location
            local jobCoords = vector3(groupLoc.x, groupLoc.y, groupLoc.z)
            local markerPos = jobCoords

            if #(coords - markerPos) < (1.2 * math.sqrt(( groupSpot.Width ^ 2 ) + ( groupSpot.Height ^ 2 ))) then
                -- Draw marker
                local rads = groupSpot.Rads
                local coordShift = GetMarkerProportions(jobSize, jobProgress)

                coordShift.x = coordShift.x * groupSpot.Width
                coordShift.y = coordShift.y * groupSpot.Height
                coordShift.x, coordShift.y = ( coordShift.x * math.cos(rads) ) - ( coordShift.y * math.sin(rads) ), ( coordShift.x * math.sin(rads) ) + ( coordShift.y * math.cos(rads) )
                coordShift.z = jobCoords.z - 1
                markerPos = vector3(jobCoords.x + coordShift.x, jobCoords.y + coordShift.y, jobCoords.z)
                DrawMarker(
                    0,
                    markerPos.x,
                    markerPos.y,
                    markerPos.z,
                    0.0,
                    0.0,
                    0.0,
                    0.0,
                    0.0,
                    0.0,
                    3.0,
                    3.0,
                    3.0,
                    235,
                    134,
                    52,
                    255,
                    false,
                    true,
                    2,
                    nil,
                    nil,
                    false
                )

                -- Increment progress if checkpoint is hit
                if #(coords - markerPos) < 2 then
                    jobProgress = jobProgress + 1
                end

                -- Complete group
                if coordShift.resetProgress == jobProgress then
                    TriggerEvent('pc-snowplow:client:SetNextGroupSpot')

                    -- Complete job
                    if #jobSpot < groupProgress then
                        TriggerServerEvent('pc-snowplow:server:FinishJob', jobSize, #jobSpot)
                        TriggerEvent('pc-snowplow:client:SetNextJobSpot')
                    end
                end

                Wait(0)
            else
                Wait(1000)
            end
        else
            Wait(1000)
        end
    end
end)
