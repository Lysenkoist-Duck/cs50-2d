local last_rng = {}

function play_sound(sound)
    local rng = math.random(1, 4)
    if sound == "pum" then
        repeat
            rng = math.random(1, 4)
        until rng ~= last_rng["pum"]

        last_rng["pum"] = rng

        sounds["pum"][rng]:play()

    elseif sound == "tum" then
        repeat
            rng = math.random(1, 4)
        until rng ~= last_rng["tum"]

        last_rng["tum"] = rng

        sounds["tum"][rng]:play()

    elseif sound == "plim" then
        repeat
            rng = math.random(1, 4)
        until rng ~= last_rng["plim"]

        last_rng["plim"] = rng

        sounds["plim"][rng]:play()
    end
end
