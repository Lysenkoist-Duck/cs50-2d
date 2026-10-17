local Toolbox = {}

function Toolbox.wait(reference_time, wait_time)
    local time_diff  = now - reference_time
    return time_diff >= wait_time
end

function Toolbox.clamp(inp, min, max)
    return math.max(math.min(inp, max), min)
end

return Toolbox