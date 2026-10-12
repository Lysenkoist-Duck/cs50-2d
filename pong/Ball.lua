Ball = Class{} -- Class({}) in reality

function Ball:init()
    self.colour = {1, 1, 1, 1}
    self:reset()
end

function Ball:collides(paddle)
    -- Checks for gaps on the x-axis
    if self.x >= paddle.x + paddle.width or paddle.x >= self.x + self.width then
        return
    end

    -- Checks for gaps on the y-axis
    if self.y >= paddle.y + paddle.height or paddle.y >= self.y + self.height then
        return
    end

    -- if neither is true, they're colliding
    return true
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
