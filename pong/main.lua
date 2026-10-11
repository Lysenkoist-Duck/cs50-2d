WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

-- How many pixels the paddles move per second
PADDLE_SPEED = 200

push = require "push"

Class = require "class"

require "Paddle"
require "Ball"  

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")

    math.randomseed(os.time())

    largeFont = love.graphics.newFont("font.ttf", 32)
    smallFont = love.graphics.newFont("font.ttf", 8)

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

    p1Score = 0
    p2Score = 0
    
    player1 = Paddle(10, 30, 5, 20)
    player2 = Paddle(VIRTUAL_WIDTH - 15, VIRTUAL_HEIGHT - 30, 5, 20)

    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

    gameState = "start"
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'enter' or key == 'return' then
        if gameState == "start" then
            gameState = "play"
        else
            gameState = "start"

            ball:reset()
            -- TODO: Reset paddles as well
        end
    end
end

function love.update(dt)
    -- Player 1 controls (w/s)
    if love.keyboard.isDown('w') then
        player1.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('s') then
        player1.dy = PADDLE_SPEED
    else
        player1.dy = 0
    end

    -- Player 2 controls (up/down)
    if love.keyboard.isDown('up') then
        player2.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('down') then
        player2.dy = PADDLE_SPEED
    else
        player2.dy = 0
    end

    if gameState == "play" then
        ball:update(dt)

        player1:update(dt)
        player2:update(dt)
    end
end

function love.draw()
    push.start()

    -- Set a colour to every pixel
    -- 40, 45, 52
    love.graphics.clear(45/255, 50/255, 20/255, 1)

    love.graphics.setFont(largeFont)
    love.graphics.print(
        tostring(p1Score),
        VIRTUAL_WIDTH / 2 - 80,
        VIRTUAL_HEIGHT / 2 - 120
    )
    love.graphics.print(
        tostring(p2Score),
        VIRTUAL_WIDTH / 2 + 60,
        VIRTUAL_HEIGHT / 2 - 120
    )

    if gameState == "start" then
        love.graphics.printf(
            "PRESS ENTER TO START",
            0,
            VIRTUAL_HEIGHT / 2 + 10,
            VIRTUAL_WIDTH,
            "center"
        )
    end

    player1:render()
    player2:render()

    ball:render()

    push.finish()
end