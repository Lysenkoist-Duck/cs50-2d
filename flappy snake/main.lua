WINDOW_WIDTH = 1920
WINDOW_HEIGHT = 1080

VIRTUAL_WIDTH = 456
VIRTUAL_HEIGHT = 240

package.path = package.path .. ";" .. os.getenv("HOME") .. "/Projects/cs50 2d/lua-libs/?.lua"

push = require "push"
Class = require "class"

Debug = require "Debug"

function love.load()
    -- Setting the title
    love.window.setTitle("Flappy Snake")

    -- Setting the filter
    love.graphics.setDefaultFilter("nearest", "nearest")

    -- Adding an epoch-based seed
    love.math.setRandomSeed(os.time())

    -- Getting a time reference
    now = love.timer.getTime()

    -- Loading Fonts
    small_font = love.graphics.newFont("font.ttf", 8)
    large_font = love.graphics.newFont("font.ttf", 16)

    -- Loading Sprites
    sprites = {}

    -- Loading Sounds
    sounds = {}

    -- Setting the Window and Screen sizes
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

    game_state = "start"
end

-- Ensures resizing the window is done correctly
function love.resize(w, h)
    push.resize(w, h)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'enter' then
        -- Start Game
    elseif key == 'k' then
        if show_fps then
            show_fps = false
        else
            show_fps = true
        end
    end
end

function love.update(dt)
    -- Updating my time reference
    now = love.timer.getTime()

    -- Update game elements
end

function love.draw()
    push.start()

    -- Set a colour to every pixel
    love.graphics.clear(40/255, 45/255, 52/255, 1)

    -- Render game elements

    if show_fps then
        Debug.display_fps()
    end

    push.finish()
end