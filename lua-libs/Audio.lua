local Audio = {}
local DEFAULT_MAX_VOICES = 4
-- TODO: Delete unused voices over time

function Audio.newPitchableSound(path, max_voices)
    local LIB_ROOT = os.getenv("HOME") .. "/Projects/cs50 2d/lua-libs/assets/audio"
    local full_path = LIB_ROOT .. "/" .. path

    local file, err = io.open(full_path, "rb")
    assert(file, "Could not open " .. full_path .. ": " .. tostring(err))
    local contents = file:read("*a")
    file:close()

    local file_data = love.filesystem.newFileData(contents, path)
    local template = love.audio.newSource(file_data, "static")

    local voices = {template}

    local next_voice = 1

    max_voices = max_voices or DEFAULT_MAX_VOICES
    assert(max_voices >= 1 and max_voices % 1 == 0, "max_voices must be a positive integer")

    -- Positive semitones raise the pitch, negative values lower it, zero is the original
    return function(semitones)
        -- Allow the caller to omit the argument for random pitch
        semitones = semitones or math.random(0, 5) -- TODO: Make sure it never repeats the one it just played
        if type(semitones) == "table" then
            semitones = math.random(semitones[1], semitones[2])
        end

        local source
        local selected_index
        local voice_count = #voices

        -- Check if any voice is idle
        for offset = 0, voice_count - 1 do
            local i = (next_voice + offset - 1) % voice_count + 1

            if not voices[i]:isPlaying() then
                source = voices[i]
                selected_index = i
                break
            end
        end

        if not source then
            if voice_count < max_voices then
                -- All voices are busy, but we can create another.
                source = voices[next_voice]:clone()
                voices[#voices + 1] = source
                selected_index = #voices
            else
                -- All voices are busy and the pool is full.
                selected_index = next_voice
                source = voices[selected_index]
            end
        end

        -- Start the next search after the voice we selected.
        next_voice = selected_index % #voices + 1

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