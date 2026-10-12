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

    -- TODO: Make scoring more interesting
    -- TODO: Count up sets too
    self.score = 0
end

function Paddle:reset(score)
    self.x = self.init_x
    self.y = self.init_y

    if score then
        self.score = score
    else
        self.score = 0
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
