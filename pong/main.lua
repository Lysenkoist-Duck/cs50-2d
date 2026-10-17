WINDOW_WIDTH = 1920
WINDOW_HEIGHT = 1080

VIRTUAL_WIDTH = 456
VIRTUAL_HEIGHT = 240

package.path = package.path .. ";" .. os.getenv("HOME") .. "/Projects/cs50 2d/lua-libs/?.lua"

push = require "push"
Class = require "class"

Collections = require "Collections"
Audio = require "Audio"
Debug = require "Debug"

require "Paddle"
require "Ball"

function love.load()
    love.window.setTitle("Pong")

    love.graphics.setDefaultFilter("nearest", "nearest")

    -- Adding an epoch-based seed
    math.randomseed(os.time())

    -- Getting a time reference
    now = love.timer.getTime()

    -- Loading Fonts
    small_font = love.graphics.newFont("font.ttf", 8)
    large_font = love.graphics.newFont("font.ttf", 16)
    score_font = love.graphics.newFont("font.ttf", 32)

    -- Loading Sounds
    audios = {
        ["tum"] = Audio.newPitchableSound("tum.wav"),
        ["pum"] = Audio.newPitchableSound("pum.wav"),
        ["plim"] = Audio.newPitchableSound("plim.wav")
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
    show_fps = false
    winning_score = 5

    player_options = {
        "Human",
        "Pong Jr.",
        "Mr. Pong",
        "El Pongo!"
    }
    
    -- Initial Server (the one who serves the ball)
    server = math.random(1, 2)

    -- Players' Paddles
    -- TODO: Refactor to call them players not paddles
    player1 = Paddle(10, 30, 5, 20, "left")
    player2 = Paddle(VIRTUAL_WIDTH - 15, VIRTUAL_HEIGHT - 30, 5, 20, "right")

    -- Ball
    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

    game_state = "start"
end

function love.resize(w, h)
    push.resize(w, h)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'enter' or key == 'return' then
        if game_state == "start" then
            game_state = "serve"
        elseif game_state == "serve" then
            game_state = "play"
        elseif game_state == "end" then
            -- Reset Scores
            player1:reset()
            player2:reset()

            -- Reset Ball Position
            ball:reset()

            game_state = "start"

            if winner == 1 then
                server = 2
            else
                server = 1
            end
        end
    elseif key == 'k' then
        if show_fps then
            show_fps = false
        else
            show_fps = true
        end
    elseif key == 'w' then
        if game_state == "start" then
            -- Move up the selection for P1
            player1.ai = Collections.cycle_through(player_options, player1.ai, "backward", "index")
        end
    elseif key == 's' then
        if game_state == "start" then
            -- Move down the selection for P1
            player1.ai = Collections.cycle_through(player_options, player1.ai, "forward", "index")
        end
    elseif key == 'up' then
        if game_state == "start" then
            -- Move up the selection for P2
            player2.ai = Collections.cycle_through(player_options, player2.ai, "backward", "index")
        end
    elseif key == 'down' then
        if game_state == "start" then
            -- Move down the selection for P2
            player2.ai = Collections.cycle_through(player_options, player2.ai, "forward", "index")
        end
    elseif key == 'n' then
        audios["tum"]()
    elseif key == 'b' then
        audios["pum"]()
    elseif key == 'm' then
        audios["plim"]()
    end
    
    -- TODO: Restart with R (hold or double press? settings!)
    -- TODO: Make starting over a function that is called after win or [R]

    -- TODO: Make it pause with P

    -- TODO: N for next song, B for previous song, M for muting
    -- TODO: Display what song is being played in some corner of the screen
end

function love.update(dt)
    -- Updating my time reference
    now = love.timer.getTime()

    if game_state == "serve" then
        ball:reset()
        player1:reset(player1.score)
        player2:reset(player2.score)

        if server == 2 then
            ball.dx = -ball.dx -- dx is defined as positive on ball:reset()
        end
    elseif game_state == "play" then
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
        p2_scored = ball.x < 0
        p1_scored = ball.x > VIRTUAL_WIDTH

        if p2_scored or p1_scored then
            audios["plim"]()
        end

        if p2_scored then
            server = 1
            player2.score = player2.score + 1
            if player2.score >= winning_score then
                winner = 2
                game_state = "end"
            else
                game_state = "serve"
            end

        elseif p1_scored then
            server = 2
            player1.score = player1.score + 1
            if player1.score >= winning_score then
                winner = 1
                game_state = "end"
            else
                game_state = "serve"
            end
        end

        -- Player 1 Movement
        local dir = 0
        if player1.ai == 1 then
            if love.keyboard.isDown('w') then
                dir = -1
            end
            if love.keyboard.isDown('s') then
                dir = 1
            end
            player1:move(dir, dt)
        else
            player1:react(ball, dt)
        end

        -- Player 2 Movement
        local dir = 0
        if player2.ai == 1 then
            if love.keyboard.isDown('up') then
                dir = -1
            end
            if love.keyboard.isDown('down') then
                dir = 1
            end
            player2:move(dir, dt)
        else
            player2:react(ball, dt)
        end

        -- Update game elements
        ball:update(dt)
        player1:update(dt)
        player2:update(dt)
    end
end

function love.draw()
    -- TODO: Add a profile pic, just some pixel art to differentiate the player and the different AIs, colour swap in case it's the same AI for when it's CPU vs CPU
    push.start()

    -- Set a colour to every pixel
    love.graphics.clear(40/255, 45/255, 52/255, 1)

    love.graphics.setFont(small_font)
    love.graphics.printf(
        player_options[player1.ai],
        -160,
        10,
        VIRTUAL_WIDTH,
        "center"
    )
    love.graphics.printf(
        player_options[player2.ai],
        160,
        10,
        VIRTUAL_WIDTH,
        "center"
    )

    if game_state == "start" then
        love.graphics.setFont(small_font)
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

    elseif game_state == "serve" then
        love.graphics.setFont(small_font)
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
    elseif game_state == "play" then
        -- TODO: Add some bark msgs for each player
    elseif game_state == "end" then
        love.graphics.setFont(large_font)
        love.graphics.printf(
            "Player " .. tostring(winner) .. " wins!",
            0,
            70,
            VIRTUAL_WIDTH,
            "center"
        )
        love.graphics.setFont(small_font)
        love.graphics.printf(
            "Press ENTER to restart!",
            0,
            30,
            VIRTUAL_WIDTH,
            "center"
        )
    end

    love.graphics.setFont(score_font)
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

    -- Render game elements
    player1:render()
    player2:render()

    ball:render()

    if show_fps then
        Debug.display_fps()
    end

    push.finish()
end
