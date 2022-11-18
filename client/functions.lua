local function PickRandomJobInternal(locationList)
    local job

    if locationList and #locationList ~= 1 then
        job = locationList[math.random(1, #locationList)]
    elseif  #locationList == 1 then
        job = locationList[1]
    end

    return job
end

-- Pick job location given the size
function PickRandomJob(jobSize)
    local job

    if jobSize == 'small' then
        job = PickRandomJobInternal(Config.PlowLocationsSmall)
    elseif jobSize == 'medium' then
        job = PickRandomJobInternal(Config.PlowLocationsMedium)
    elseif jobSize == 'large' then
        job = PickRandomJobInternal(Config.PlowLocationsLarge)
    end

    return job
end

-- Get current marker coordinates for job size and state
function GetMarkerProportions(jobSize, jobProgress)
    local x, y, resetProgress
    local widthDivisions
    local y_mod = math.fmod(jobProgress, 4)

    if jobSize == 'small' then
        widthDivisions = 2
        resetProgress = 6
    elseif jobSize == 'medium' then
        widthDivisions = 4
        resetProgress = 10
    elseif jobSize == 'large' then
        widthDivisions = 8
        resetProgress = 18
    end

    if widthDivisions then
        x = 1.00 - ( math.floor( jobProgress / 2 ) / widthDivisions )
    end

    if y_mod == 0 or y_mod == 3 then
        y = 0.00
    else
        y = 1.00
    end

    return { x = x, y = y, resetProgress = resetProgress }
end
