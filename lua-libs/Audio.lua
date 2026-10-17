local Audio = {}

--[[ TODO:
If an idle voice exists
Reuse it

If every voice is busy, but the pool is below its limit
Add another clone to the table and use it

If every voice is busy and the pool has reached its limit
Interrupt the oldest voice and use it
]]

function Audio.newPitchableSound(path, voiceCount)
    local LIB_ROOT = os.getenv("HOME") .. "/Projects/cs50 2d/lua-libs/assets/audio"
    local fullPath = LIB_ROOT .. "/" .. path

    local file, err = io.open(fullPath, "rb")
    assert(file, "Could not open " .. fullPath .. ": " .. tostring(err))
    local contents = file:read("*a")
    file:close()

    local fileData = love.filesystem.newFileData(contents, path)
    local template = love.audio.newSource(fileData, "static")

    local voices = {}

    if not (type(voiceCount) == "number" and voiceCount > 0) then
        voiceCount = 1
    end
        
    for i = 1, voiceCount do
        voices[i] = template:clone()
    end

    local nextVoice = 1


    -- Positive semitones raise the pitch; negative values lower it.
    -- Zero plays at the original pitch.
    return function(semitones)
        -- Allow the caller to omit the argument for random pitch.
        semitones = semitones or math.random(0, 5)
        if type(semitones) == "table" then
            semitones = math.random(semitones[1], semitones[2])
        end

        -- Select the next playback instance in the rotation.
        local source = voices[nextVoice]

        -- Advance to the next instance, wrapping back to 1 at the end.
        nextVoice = nextVoice % #voices + 1

        -- Stop the selected instance in case its previous sound
        -- is still playing. This can cut off an overlapping sound
        -- if the entire pool is already busy.
        source:stop()

        -- Convert semitones into LÖVE's pitch multiplier.
        -- Every 12 semitones doubles the playback frequency.
        source:setPitch(2 ^ (semitones / 12))

        -- Play this instance without restarting the other voices.
        source:play()
    end
end

return Audio