local Collections = {}

function Collections.Set(list)
    local set = {}
    for _, value in ipairs(list) do
        set[value] = true
    end
    return set
end

-- TODO: Optimize
function Collections.cycle_through(list, index, direction, return_type)
    list_len = table.getn(list)

    if direction == "forward" then
        index = index + 1
        if index >= list_len + 1 then
            index = 1
        end
        if return_type == "value" then
            return list[index]
        elseif return_type == "index" then
            return index
        end 
    elseif direction == "backward" then
        index = index - 1
        if index <= 0 then
            index = list_len
        end
        if return_type == "value" then
            return list[index]
        elseif return_type == "index" then
            return index
        end
    end
end

return Collections
