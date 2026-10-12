require "Sound"
require "Collections"

Ball = Class{} -- Class({}) in reality

function Ball:init()
    self.colour = {1, 1, 1, 1}
    self:reset()
end

function Ball:collides(paddles)
    -- Checks for collisions with the paddles and the top & bottom walls

    for _, paddle in ipairs(paddles) do
        -- Checks for gaps on the x-axis
        local x_gap = self.x >= paddle.x + paddle.width or paddle.x >= self.x + self.width
        -- Checks for gaps on the y-axis
        local y_gap = self.y >= paddle.y + paddle.height or paddle.y >= self.y + self.height
    
        -- if neither is true, they're colliding
        if not x_gap and not y_gap then
            self:bounce(paddle.side)
            break
        end
    end
end

function Ball:bounce(side)
    local vertical = Set{"up", "down"}
    local horizontal = Set{"left", "right"}

    if vertical[side] then
        -- Bounce off top & bottom walls
        play_sound("tum")

        if side == "up" then
            self.y = 0
            self.dy = -self.dy
        elseif side == "down" then
            self.y = VIRTUAL_HEIGHT - 4
            self.dy = -self.dy
        end
    elseif horizontal[side] then
        -- Bounce off left & right paddles
        play_sound("pum")

        -- Reverts the speed of the ball and increases it by 3%
        self.dx = -self.dx * 1.03

        if side == "left" then
            self.x = player1.x + 5
        elseif side == "right" then
            self.x = player2.x - 4
        end

        if self.dy < 0 then
            self.dy = -math.random(10, 150)
        else
            self.dy = math.random(10, 150)
        end
    end
end

function Ball:reset()
    self.x = VIRTUAL_WIDTH / 2 - 2
    self.y = VIRTUAL_HEIGHT / 2 - 2

    self.width = 4
    self.height = 4

    -- Ball's Speed
    self.dx = math.random(2) == 1 and 100 or -100
    self.dy = math.random(-50, 50) * 1.5

    -- TODO: Reset colour as well
end

function Ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

function Ball:render()
    love.graphics.setColor(
        self.colour[1],
        self.colour[2],
        self.colour[3],
        self.colour[4]
    )

    love.graphics.rectangle(
        "fill",
        self.x,
        self.y,
        self.width,
        self.height
    )

    love.graphics.setColor(1, 1, 1, 1)
end
