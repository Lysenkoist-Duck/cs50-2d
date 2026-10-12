Paddle = Class{}

function Paddle:init(x, y, width, height, side)
    self.init_x = x
    self.init_y = y

    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.dy = 0

    self.side = side
end

function Paddle:reset()
    self.x = self.init_x
    self.y = self.init_y
end

function Paddle:update(dt)
    if self.dy < 0 then
        self.y = math.max(0, self.y + self.dy * dt)
    else
        self. y = math.min(VIRTUAL_HEIGHT - self.height, self.y + self.dy * dt)
    end
end

function Paddle:render()
    love.graphics.rectangle(
        "fill",
        self.x,
        self.y,
        self.width,
        self.height
    )
end
