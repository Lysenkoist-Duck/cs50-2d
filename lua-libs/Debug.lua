local Debug = {}

function Debug.display_fps()
    -- TODO: Add support for changing colour & font and the default colour & font for after the code runs
    love.graphics.setFont(small_font)
    love.graphics.setColor(0, 1, 0) -- Accepts RGB(A)
    
    love.graphics.print(
        -- .. is concatenation operator
        "FPS: " .. tostring(love.timer.getFPS()),
        10,
        10
    )
    
    love.graphics.setColor(1, 1, 1)
end

return Debug
