Config = {
    FuelResource = 'cdn-fuel', -- Fuel system
    TargetResource = 'qb-target', -- Targetting system
    MenuResource = 'qb-menu', -- Targetting system
    WeatherResource = 'qb-weathersync', -- Weather system
    JobName = 'snowplow', -- Name in qb-core/shared/jobs.lua
    IsSnowSeason = true, -- Turns on weather / snow handling
    CommunityImpact = true, -- Removes snow from road & lowers freq. and duration of power loss granted a certain plowing level
    ClearWeatherType = 'SNOW', -- The weather type that sets when the ClearRoadPlowLevel is reached - snow seems to have an unenjoyable fog so careful
    ClearRoadPlowLevel = 200, -- How many plow levels need to be cleared by players on server before snow is removed
    StablePowerPlowLevel = 40, -- How many plow levels need to be cleared by players on server before power loss is completely avoided
    PowerLossRandomDuration = function(plowLevel) -- Function for duration a power outage occurs provided a plow level
        return math.random(1, math.floor(60000 * (Config.StablePowerPlowLevel - plowLevel)))
    end,
    PowerLossRandomFrequency = function(plowLevel) -- Function for duration to wait before next power outage if applicable
        return math.random(1, math.floor(20 * 60000 * math.sqrt( plowLevel + 1 )))
    end,
    UseBlip = true, -- Whether or not to use a blip
    BlipSprite = 734, -- The blip sprite to use
    BlipColor = 18, -- The color of the blip
    BlipTitle = 'Plowing Hub', -- The label for the blip
    DutyLocation = vector4(-629.36, -79.17, 40.31, 0.00), -- Plow rental NPC location
    DutyPedModel = 's_m_y_fireman_01', -- Plow rental ped
    VehicleSpawnLocation = vector4(-632.69, -71.23, 40.50, 0.00), -- Where plows spawn when taken out for a job
    ReturnLocation = vector3(-641.66, -79.31, 40.09), -- Where plows are returned
    ReturnRange = 5, -- The radius that a player must be in to return a plow
    SmallPlows = { -- Allowed vehicles for small jobs
        -- There aren't many base game vehicles for this, may require imports
    },
    MediumPlows = { -- Allowed vehicles for medium jobs
        -- There aren't many base game vehicles for this, may require imports
    },
    LargePlows = { -- Allowed vehicles for large jobs
        -- There aren't many base game vehicles for this, may require imports
    },
    SmallPlowClear = 1, -- Amount of clearing done by a small job
    MediumPlowClear = 3, -- Amount of clearing done by a medium job
    LargePlowClear = 5, -- Amount of clearing done by a large job
    SmallPayout = 500, -- Amount of money for a small job's group
    MediumPayout = 1000, -- Amount of money for a medium job's group
    LargePayout = 2500, -- Amount of money for a large job's group
    PayoutSnowballs = true, -- Whether or not to grant snowballs on job completion
    PayoutRange = 100, -- Amount payout differs for each group
    PlowLocationsSmall = { -- Plowing spots for small vehicles
        {
            {
                Location = vector4(-295.47, -987.87, 31.08, 70.00),
                Width = 10,
                Height = 50,
            },
            {
                Location = vector4(-325.19, -962.40, 31.08, 340.00),
                Width = 11,
                Height = 36,
            },
            {
                Location = vector4(-301.07, -921.29, 31.08, 78.00),
                Width = 12,
                Height = 45,
            },
            {
                Location = vector4(-349.78, -886.70, 31.07, 180.00),
                Width = 12,
                Height = 63,
            },
            {
                Location = vector4(-347.17, -948.57, 31.20, 340.00),
                Width = 11,
                Height = 30,
            },
        },
        {
            {
                Location = vector4(162.62, 183.12, 105.65, 160.00),
                Width = 15,
                Height = 37,
            },
            {
                Location = vector4(132.58, 153.66, 104.56, 70.00),
                Width = 7,
                Height = 39,
            },
            {
                Location = vector4(69.67, 144.47, 104.51, 70.00),
                Width = 15,
                Height = 18,
            },
            {
                Location = vector4(65.87, 180.94, 104.74, 70.00),
                Width = 7,
                Height = 41,
            },
        },
        {
            {
                Location = vector4(104.38, 283.26, 109.97, 340.00),
                Width = 13,
                Height = 21,
            },
        },
        {
            {
                Location = vector4(-22.05, 204.26, 106.55, 72.00),
                Width = 8,
                Height = 41,
            },
            {
                Location = vector4(-9.97, 185.41, 101.94, 72.00),
                Width = 11,
                Height = 53,
            },
        },
        {
            {
                Location = vector4(-395.51, 190.01, 80.50, 270.00),
                Width = 8,
                Height = 26,
            },
        },
        {
            {
                Location = vector4(-742.85, 303.14, 86.25, 0.00),
                Width = 8,
                Height = 30,
            },
            {
                Location = vector4(-735.85, 356.43, 87.87, 90.00),
                Width = 8,
                Height = 78,
            },
            {
                Location = vector4(-735.60, 364.60, 87.87, 90.00),
                Width = 11,
                Height = 25,
            },
            {
                Location = vector4(-765.96, 364.98, 87.87, 90.00),
                Width = 11,
                Height = 18,
            },
            {
                Location = vector4(-788.83, 365.44, 87.87, 90.00),
                Width = 11,
                Height = 24,
            },
            {
                Location = vector4(-814.73, 358.61, 87.37, 90.00),
                Width = 7,
                Height = 30,
            },
        },
        {
            {
                Location = vector4(-102.04, 45.54, 71.61, 155.00),
                Width = 8,
                Height = 22,
            },
            {
                Location = vector4(-104.04, 103.96, 71.60, 240.00),
                Width = 15,
                Height = 23,
            },
        },
        {
            {
                Location = vector4(122.94, -112.82, 54.84, 250.00),
                Width = 7,
                Height = 35,
            },
        },
        {
            {
                Location = vector4(269.66, 0.39, 79.27, 340.00),
                Width = 16.5,
                Height = 15,
            },
            {
                Location = vector4(290.95, 15.92, 83.82, 70.00),
                Width = 7,
                Height = 48,
            },
            {
                Location = vector4(245.36, 31.97, 84.04, 160.00),
                Width = 7,
                Height = 21,
            },
            {
                Location = vector4(224.49, 45.52, 83.85, 70.00),
                Width = 7,
                Height = 43,
            },
        },
        {
            {
                Location = vector4(641.24, 198.77, 97.00, 160.00),
                Width = 12,
                Height = 57,
            },
            {
                Location = vector4(626.94, 142.99, 95.00, 340.00),
                Width = 12,
                Height = 57,
            },
        },
        {
            {
                Location = vector4(683.45, 224.02, 93.21, 330.00),
                Width = 11,
                Height = 44,
            },
            {
                Location = vector4(701.31, 265.70, 93.34, 150.00),
                Width = 11,
                Height = 44,
            },
        },
        {
            {
                Location = vector4(1236.10, -331.35, 69.08, 260.00),
                Width = 13,
                Height = 27,
            },
            {
                Location = vector4(1279.14, -365.24, 69.08, 140.00),
                Width = 11,
                Height = 14,
            },
        },
        {
            {
                Location = vector4(1163.39, -468.14, 66.50, 165.00),
                Width = 12,
                Height = 21,
            },
        },
        {
            {
                Location = vector4(1148.58, -1277.14, 34.63, 180.00),
                Width = 19,
                Height = 27,
            },
            {
                Location = vector4(1196.65, -1275.06, 35.22, 0.00),
                Width = 13,
                Height = 18,
            },
        },
        {
            {
                Location = vector4(-2299.41, 457.91, 174.47, 175.00),
                Width = 11,
                Height = 30,
            },
            {
                Location = vector4(-2318.94, 379.60, 174.47, 115.00),
                Width = 11,
                Height = 33,
            },
            {
                Location = vector4(-2318.13, 315.59, 169.47, 115.00),
                Width = 7,
                Height = 52,
            },
        },
        {
            {
                Location = vector4(-1317.02, -1330.03, 4.71, 290.00),
                Width = 8,
                Height = 33,
            },
            {
                Location = vector4(-1286.88, -1316.30, 4.38, 20.00),
                Width = 5.5,
                Height = 20,
            },
            {
                Location = vector4(-1277.23, -1315.98, 3.97, 200.00),
                Width = 7,
                Height = 60,
            },
        },
        {
            {
                Location = vector4(-1253.10, -1405.15, 4.24, 215.00),
                Width = 8,
                Height = 27,
            },
            {
                Location = vector4(-1235.78, -1427.11, 4.32, 35.00),
                Width = 8.5,
                Height = 27.5,
            },
        },
        {
            {
                Location = vector4(-1052.23, -1346.22, 4.71, 340.00),
                Width = 12,
                Height = 25.5,
            },
            {
                Location = vector4(-1053.14, -1402.72, 5.43, 165.00),
                Width = 8.5,
                Height = 31,
            },
            {
                Location = vector4(-1052.57, -1435.84, 5.43, 345.00),
                Width = 8.5,
                Height = 22,
            },
        },
        {
            {
                Location = vector4(472.16, -1697.86, 29.10, 45.00),
                Width = 10,
                Height = 21,
            },
            {
                Location = vector4(464.54, -1706.86, 29.21, 45.00),
                Width = 10,
                Height = 21,
            },
        },
        {
            {
                Location = vector4(102.87, -1322.30, 29.29, 300.00),
                Width = 8.5,
                Height = 32,
            },
            {
                Location = vector4(141.35, -1307.84, 29.12, 235.00),
                Width = 5,
                Height = 27,
            },
            {
                Location = vector4(155.15, -1297.66, 29.09, 30.00),
                Width = 8.5,
                Height = 27,
            },
        },
        {
            {
                Location = vector4(453.87, -664.58, 28.01, 355.00),
                Width = 10.5,
                Height = 68,
            },
            {
                Location = vector4(470.25, -594.80, 28.50, 85.00),
                Width = 17.5,
                Height = 35,
            },
            {
                Location = vector4(427.91, -595.65, 28.50, 180.00),
                Width = 10,
                Height = 65,
            },
        },
        {
            {
                Location = vector4(392.67, -737.66, 29.29, 180.00),
                Width = 14.5,
                Height = 34,
            },
        },
        {
            {
                Location = vector4(-382.47, -102.05, 38.70, 250.00),
                Width = 22,
                Height = 32,
            },
        },
        {
            {
                Location = vector4(-1463.94, -500.30, 32.96, 125.00),
                Width = 8,
                Height = 40,
            },
            {
                Location = vector4(-1493.78, -533.64, 31.00, 215.00),
                Width = 9.5,
                Height = 67,
            },
            {
                Location = vector4(-1499.84, -551.59, 32.74, 125.00),
                Width = 13,
                Height = 29,
            },
        },
        {
            {
                Location = vector4(266.37, -1499.51, 29.15, 135.00),
                Width = 9,
                Height = 43,
            },
        },
    },
    PlowLocationsMedium = { -- Plowing spots for medium vehicles
        {
            {
                Location = vector4(1168.21, 255.90, 82.19, 148.00),
                Width = 18,
                Height = 300,
            },
            {
                Location = vector4(1100.26, -57.63, 82.19, 328.00),
                Width = 18,
                Height = 300,
            },
        },
        {
            {
                Location = vector4(-322.22, -2555.27, 6.00, 50.00),
                Width = 19.5,
                Height = 174,
            },
        },
        {
            {
                Location = vector4(188.66, -3091.28, 5.77, 180.00),
                Width = 16,
                Height = 211,
            },
            {
                Location = vector4(291.16, -3091.44, 5.90, 0.00),
                Width = 18,
                Height = 124.5,
            },
        },
        {
            {
                Location = vector4(-422.73, 1182.35, 325.64, 345.00),
                Width = 26,
                Height = 53,
            },
        },
        {
            {
                Location = vector4(228.71, 1163.60, 225.47, 12.50),
                Width = 17,
                Height = 89,
            },
        },
        {
            {
                Location = vector4(-760.36, -1296.00, 5.00, 80.00),
                Width = 17,
                Height = 89,
            },
        },
    },
    PlowLocationsLarge = { -- Plowing spots for large vehicles
        {
            {
                Location = vector4(-1713.51, -2907.49, 13.94, 240.00),
                Width = 30,
                Height = 870,
            },
            {
                Location = vector4(-888.28, -3224.41, 13.94, 60.00),
                Width = 30,
                Height = 870,
            },
        },
        {
            {
                Location = vector4(1721.94, 3238.92, 41.15, 105.00),
                Width = 32,
                Height = 680,
            },
            {
                Location = vector4(1101.18, 3033.19, 40.53, 285.00),
                Width = 28,
                Height = 400,
            },
        },
        {
            {
                Location = vector4(-1972.20, 2809.15, 32.86, 60.00),
                Width = 40,
                Height = 940,
            },
            {
                Location = vector4(-2620.68, 3335.67, 32.81, 240.00),
                Width = 36,
                Height = 411,
            },
        },
    }
}
