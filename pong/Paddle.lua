require "Toolbox"

Paddle = Class{}

function Paddle:init(x, y, width, height, side, ai)
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

    if ai then
        self.ai = ai
    else
        self.ai = 1
    end

    self.last_mv = 0
end

function Paddle:reset(score)
    self.x = self.init_x
    self.y = self.init_y

    if score then
        self.score = score
    else
        self.score = 0
    end
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

function Paddle:react(ball, spd, now)
    --[[
    There are 3 levels of AI
    Pong Jr.  : Easy
    Mr. Pong  : Medium
    El Pongo! : Hard
    ]]

    -- Middle of paddle aligned with the ball
    local target = math.max(math.min(ball.y - 9, VIRTUAL_HEIGHT), 0)
    
    -- Distance to target position
    local target_distance = math.abs((target) - self.y)

    -- Ball moving towards this paddle
    local ball_incoming = ((ball.dx < 0) and (self.side == "left")) or ((ball.dx > 0) and (self.side == "right"))

    local ai_values = {
        -- Pong Jr.
        [2] = {
            ["reaction"] = 0.5,
            ["margin"] = math.random(6, 10)
        },
        -- Mr. Pong
        [3] = {
            ["reaction"] = 0.25,
            ["margin"] = math.random(4, 7)
        },
        -- El Pongo!
        [4] = {
            ["reaction"] = 0.125,
            ["margin"] = math.random(2, 4)
        },
    }

    -- Delay before the AI reacts again
    local reaction_time = ai_values[self.ai]["reaction"]
    -- Margin of error to make it easier
    local margin = ai_values[self.ai]["margin"]

    if target_distance <= margin then
        self.dy = 0
    elseif ball_incoming and wait(self.last_mv, reaction_time) then
        self.last_mv = now
        -- If below, go up
        if self.y > target then
            self.dy = -spd
        -- If above, go down
        elseif self.y < target then
            self.dy = spd
        end
    end
end
