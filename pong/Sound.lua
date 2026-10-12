-- TODO: Make sure it's never the same that just played
function play_sound(sound)
    if sound == "pum" then
        sounds["pum"][math.random(1, 4)]:play()
    elseif sound == "tum" then
        sounds["tum"][math.random(1, 4)]:play()
    elseif sound == "plim" then
        sounds["plim"][math.random(1, 4)]:play()
    end
end
