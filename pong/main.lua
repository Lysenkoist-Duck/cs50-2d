WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

-- How many pixels the paddles move per second
PADDLE_SPEED = 200

push = require "push"

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")

    largeFont = love.graphics.newFont("font.ttf", 32)
    smallFont = love.graphics.newFont("font.ttf", 8)

    player1Score = 0
    player2Score = 0
    
    player1Y = 10
    player2Y = VIRTUAL_HEIGHT - 30

    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
        resizable = false,
        vsync = true, -- Avoids screen tearing
        fullscreen = false
    })
    push.setupScreen(
        VIRTUAL_WIDTH,
        VIRTUAL_HEIGHT,
        {
            upscale = "normal"
        }
    )
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end

function love.update(dt)
    if love.keyboard.isDown('w') then
        player1Y = player1Y + -PADDLE_SPEED * dt
    elseif love.keyboard.isDown('s') then
        player1Y = player1Y + PADDLE_SPEED * dt
    end

    if love.keyboard.isDown('up') then
        player2Y = player2Y + -PADDLE_SPEED * dt
    elseif love.keyboard.isDown('down') then
        player2Y = player2Y + PADDLE_SPEED * dt
    end
end

-- Prints "Hello, Pong!" at the center of the screen
function love.draw()
    push.start()

    -- Set a colour to every pixel
    -- 40, 45, 52
    love.graphics.clear(45/255, 50/255, 20/255, 1)

    -- love.graphics.setFont(smallFont)
    -- love.graphics.printf(
    --    "Hello, Pong!",
    --    0,
    --    VIRTUAL_HEIGHT / 2 - 4,
    --    VIRTUAL_WIDTH,
    --    "center"
    -- )

    -- love.graphics.setFont(largeFont)
    -- love.graphics.printf(
    --     "Hello, Pong!",
    --     0,
    --     VIRTUAL_HEIGHT / 2 - 16,
    --     VIRTUAL_WIDTH,
    --     "center"
    -- )

    love.graphics.setFont(largeFont)
    love.graphics.print(
        tostring(p1Score),
        VIRTUAL_WIDTH / 2 - 50,
        VIRTUAL_HEIGHT / 2 - 120
    )
    love.graphics.print(
        tostring(p2Score),
        VIRTUAL_WIDTH / 2 + 30,
        VIRTUAL_HEIGHT / 2 - 120
    )

    -- left paddle (P1)
    love.graphics.rectangle(
        "fill", -- filled in rectangle
        10, -- 10 (virtual) pixels from the left
        10, -- 10 pixels from the top
        5, -- 5 pixels wide
        20 -- 20 pixels tall
    )

    -- right paddle (P2)
    love.graphics.rectangle(
        "fill",
        VIRTUAL_WIDTH - 15, -- also 10 pixels from the edge
        VIRTUAL_HEIGHT - 30,
        5,
        20
    )

    -- ball
    love.graphics.rectangle(
        "fill",
        VIRTUAL_WIDTH / 2 - 2,
        VIRTUAL_HEIGHT / 2 - 2,
        4,
        4
    )

    push.finish()
end