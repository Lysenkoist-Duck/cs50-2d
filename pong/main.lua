WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

-- How many pixels the paddles move per second
PADDLE_SPEED = 150 -- TODO: Acceleration, start at ~100 and accelerate up to ~300

push = require "push"

Class = require "class"

require "Paddle"
require "Ball" 
require "Sound"
require "Debug"

function love.load()
    love.window.setTitle("Pong")

    love.graphics.setDefaultFilter("nearest", "nearest")

    -- Adding an epoch-based seed
    math.randomseed(os.time())

    -- Defining fonts
    smallFont = love.graphics.newFont("font.ttf", 8)
    largeFont = love.graphics.newFont("font.ttf", 16)
    scoreFont = love.graphics.newFont("font.ttf", 32)

    -- Defining Sounds
    sounds = {
        ["pum"] = {
            love.audio.newSource("sounds/pum1.wav", "static"),
            love.audio.newSource("sounds/pum2.wav", "static"),
            love.audio.newSource("sounds/pum3.wav", "static"),
            love.audio.newSource("sounds/pum4.wav", "static")
        },
        ["tum"] = {
            love.audio.newSource("sounds/tum1.wav", "static"),
            love.audio.newSource("sounds/tum2.wav", "static"),
            love.audio.newSource("sounds/tum3.wav", "static"),
            love.audio.newSource("sounds/tum4.wav", "static")
        },
        ["plim"] = {
            love.audio.newSource("sounds/plim1.wav", "static"),
            love.audio.newSource("sounds/plim2.wav", "static"),
            love.audio.newSource("sounds/plim3.wav", "static"),
            love.audio.newSource("sounds/plim4.wav", "static")
        }
    }

    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
        resizable = true,
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

    -- Settings
    showFPS = false
    
    -- Server
    server = math.random(1, 2)

    -- Paddles
    player1 = Paddle(10, 30, 5, 20, "left")
    player2 = Paddle(VIRTUAL_WIDTH - 15, VIRTUAL_HEIGHT - 30, 5, 20, "right")

    -- Ball
    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

    gameState = "start"
end

function love.resize(w, h)
    push.resize(w, h)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'enter' or key == 'return' then
        -- TODO: 1 for single player, 2 for dual player
        if gameState == "start" then
            gameState = "serve"
        elseif gameState == "serve" then
            gameState = "play"
        elseif gameState == "end" then -- TODO: Then start instead, so one can change players/mode
            gameState = "start"

            ball:reset()

            if winner == 1 then
                server = 2
            else
                server = 1
            end
        end
    elseif key == 'k' then
        if showFPS then
            showFPS = false
        else
            showFPS = true
        end
    end

    -- TODO: Restart with R (hold or double press? settings!)
    -- TODO: Make starting over a function that is called after win or [R]

    -- TODO: Make it pause with P

    -- TODO: N for next song, B for previous song, M for muting
    -- TODO: Display what song is being played in some corner of the screen
end

function love.update(dt)
    if gameState == "serve" then
        ball:reset()
        player1:reset()
        player2:reset()

        if server == 2 then
            ball.dx = -ball.dx -- dx is defined as positive on ball:reset()
        end
    elseif gameState == "play" then
        -- Checks whether the ball is colliding with either paddle
        ball:collides{player1, player2}

        -- Bounce the ball off top & bottom walls, respectivelly
        if ball.y <= 0 then
            ball:bounce("up")
        elseif ball.y >= VIRTUAL_HEIGHT - 4 then
            ball:bounce("down")
        end

        -- Scoring
        -- TODO: Play party/victory song when someone wins
        if ball.x < 0 then
            server = 1
            player2.score = player2.score + 1
            if player2.score >= 5 then
                winner = 2
                gameState = "end"
            else
                play_sound("plim")
                gameState = "serve"
            end

        elseif ball.x > VIRTUAL_WIDTH then
            server = 2
            player1.score = player1.score + 1
            if player1.score >= 5 then
                winner = 1
                gameState = "end"
            else
                play_sound("plim")
                ball:reset()
                gameState = "serve"
            end
        end

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

        ball:update(dt)

        player1:update(dt)
        player2:update(dt)
    end
end

function love.draw()
    push.start()

    -- Set a colour to every pixel
    love.graphics.clear(40/255, 45/255, 52/255, 1)

    if gameState == "start" then
        love.graphics.setFont(smallFont)
        love.graphics.printf(
            "Welcome to Pong!",
            0,
            10,
            VIRTUAL_WIDTH,
            "center"
        )
        love.graphics.printf(
            "Press ENTER to begin!",
            0,
            20,
            VIRTUAL_WIDTH,
            "center"
        )
    elseif gameState == "serve" then
        love.graphics.setFont(smallFont)
        love.graphics.printf(
            "Player " .. tostring(server) .. "'s serve!",
            0,
            10,
            VIRTUAL_WIDTH,
            "center"
        )
        love.graphics.printf(
            "Press ENTER to serve!",
            0,
            20,
            VIRTUAL_WIDTH,
            "center"
        )
    elseif gameState == "play" then
        -- TODO: Add some bark msgs for each player
    elseif gameState == "end" then
        love.graphics.setFont(largeFont)
        love.graphics.printf(
            "Player " .. tostring(winner) .. " wins!",
            0,
            70,
            VIRTUAL_WIDTH,
            "center"
        )
        love.graphics.setFont(smallFont)
        love.graphics.printf(
            "Press ENTER to restart!",
            0,
            30,
            VIRTUAL_WIDTH,
            "center"
        )
    end

    love.graphics.setFont(scoreFont)
    -- TODO: Change the colours of the score and paddles, but first decide which colours
    -- TODO: Let players pick colours at the start stage
    love.graphics.print(
        tostring(player1.score),
        VIRTUAL_WIDTH / 2 - 80,
        VIRTUAL_HEIGHT / 2 - 120
    )
    love.graphics.print(
        tostring(player2.score),
        VIRTUAL_WIDTH / 2 + 60,
        VIRTUAL_HEIGHT / 2 - 120
    )

    player1:render()
    player2:render()

    ball:render()

    if showFPS then
        displayFPS()
    end

    push.finish()
end
