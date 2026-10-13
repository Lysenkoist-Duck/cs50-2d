function display_fps()
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