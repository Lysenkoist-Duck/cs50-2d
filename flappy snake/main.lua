WINDOW_WIDTH = 1920
WINDOW_HEIGHT = 1080

VIRTUAL_WIDTH = 456
VIRTUAL_HEIGHT = 240

push = require "push"

Class = require "class"

function love.load()
    love.window.setTitle("Flappy Snake")

    love.graphics.setDefaultFilter("nearest", "nearest")

    love.math.setRandomSeed(os.time())