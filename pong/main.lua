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
    
    player1Y = 10
    player2Y = VIRTUAL_HEIGHT - 30

    ballX = VIRTUAL_WIDTH / 2 - 2
    ballY = VIRTUAL_HEIGHT / 2 - 2

    ballDX = math.random(2) == 1 and 100 or -100 -- ternary
    ballDY = math.random(-50, 50)

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

            ballX = VIRTUAL_WIDTH / 2 - 2
            ballY = VIRTUAL_HEIGHT / 2 - 2

            ballDX = math.random(2) == 1 and 100 or -100
            ballDY = math.random(-50, 50) * 1.5
        end
    end
end

function love.update(dt)
    if love.keyboard.isDown('w') then
        player1Y = math.max(0, player1Y + -PADDLE_SPEED * dt)
    elseif love.keyboard.isDown('s') then
        player1Y = math.min(VIRTUAL_HEIGHT - 20, player1Y + PADDLE_SPEED * dt)
    end

    if love.keyboard.isDown('up') then
        player2Y = math.max(0, player2Y + -PADDLE_SPEED * dt)
    elseif love.keyboard.isDown('down') then
        player2Y = math.min(VIRTUAL_HEIGHT - 20, player2Y + PADDLE_SPEED * dt)
    end

    if gameState == "play" then
        ballX = ballX + ballDX * dt
        ballY = ballY + ballDY * dt
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
            gameState,
            0,
            VIRTUAL_HEIGHT / 2 - 4,
            VIRTUAL_WIDTH,
            "center"
        )
    end

    -- left paddle (P1)
    love.graphics.rectangle(
        "fill", -- filled in rectangle
        10, -- 10 (virtual) pixels from the left
        player1Y, -- defining the Y of the left paddle as my player1Y variable
        5, -- 5 pixels wide
        20 -- 20 pixels tall
    )

    -- right paddle (P2)
    love.graphics.rectangle(
        "fill",
        VIRTUAL_WIDTH - 15, -- also 10 pixels from the edge
        player2Y, -- defining the Y of the right paddle as my player2Y variable,
        5,
        20
    )

    -- ball
    love.graphics.rectangle(
        "fill",
        ballX,
        ballY,
        4,
        4
    )

    push.finish()
end