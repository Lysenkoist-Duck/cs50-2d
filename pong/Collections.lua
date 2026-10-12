function Set(list)
    local set = {}
    for _, value in ipairs(list) do
        set[value] = true
    end
    return set
end
