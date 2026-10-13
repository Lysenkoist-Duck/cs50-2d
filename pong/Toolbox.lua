function wait(reference_time, wait_time)
    now = love.timer.getTime()
    time_diff  = now - reference_time

    if time_diff >= wait_time then
        return true
    end
end
