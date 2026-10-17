Toolbox = require "Toolbox"

Paddle = Class{}

local INIT_SPD = 75
local MAX_SPD = 250
local RAMP_TIME = 0.6
local ACCEL = (MAX_SPD - INIT_SPD) / RAMP_TIME -- 400

local ai_values = {
    -- Pong Jr.
    [2] = {
        ["reaction"] = {0.55, 0.8},
        ["margin"] = {3, 10},
        ["recenters"] = false -- Whether or not the AI recenters the paddle
    },
    -- Mr. Pong
    [3] = {
        ["reaction"] = {0.3, 0.75},
        ["margin"] = {2, 7},
        ["recenters"] = true
    },
    -- El Pongo!
    [4] = {
        ["reaction"] = {0.1, 0.3},
        ["margin"] = {1, 4},
        ["recenters"] = true
    },
}

function Paddle:init(x, y, width, height, side, ai)
    self.init_y = y

    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.dy = 0 -- Delta Y

    self.side = side

    -- TODO: Make scoring more interesting
    -- TODO: Count up sets too
    self.score = 0

    if ai then
        self.ai = ai
    else
        self.ai = 1
    end

    -- Moment of the last move
    self.last_mv = 0
    -- Margin of error to make it easier
    self.margin = 0
    -- Delay before the AI reacts again
    self.reaction_time = 0
    -- Intention
    self.ai_dir = 0
    -- Timer
    self.timer = 0
end

function Paddle:reset(score)
    self.y = self.init_y
    self.dy = 0

    self.ai_dir = 0
    self.last_mv = 0
    self.margin = 0
    self.reaction_time = 0
    self.timer = 0

    if score then
        self.score = score
    else
        self.score = 0
    end
end

function Paddle:move(dir, dt)
    local spd
    if dir == 0 then
        spd = 0
    elseif self.dy == 0 or not ((self.dy > 0) == (dir > 0)) then
        spd = INIT_SPD * dir
    elseif (self.dy > 0) == (dir > 0) then
        spd = math.abs(self.dy) -- Magnitude
        spd = spd + ACCEL * dt -- Accelerate
        spd = math.min(spd, MAX_SPD) -- Cap
        spd = spd * dir -- Direction
    end

    self.dy = spd
end

function Paddle:update(dt)
    local pbp = VIRTUAL_HEIGHT - self.height -- Paddle Bottom Position
    local y = math.max(math.min(self.y + self.dy * dt, pbp), 0)

    if y == 0 or y == pbp then
        self.dy = 0
    end

    self.y = y
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

function Paddle:react(ball, dt)
    --[[
    There are 3 levels of AI
    Pong Jr.  : Easy
    Mr. Pong  : Medium
    El Pongo! : Hard
    ]]

    local ai_values = ai_values[self.ai]
    local margin = ai_values["margin"]
    local reaction = ai_values["reaction"]
    local recenters = ai_values["recenters"]

    local hi = reaction[1]
    local lo = reaction[2]

    -- Middle of paddle aligned with the ball
    local target
    
    -- Distance to target's position
    local target_distance

    -- Ball moving towards this paddle
    local ball_incoming = ((ball.dx < 0) and (self.side == "left")) or ((ball.dx > 0) and (self.side == "right"))

    if ball_incoming then
        -- Align with the ball
        target = Toolbox.clamp(ball.y + (ball.height / 2) - (self.height / 2), 0, VIRTUAL_HEIGHT - self.height)
    elseif recenters then
        -- Recenter (duh)
        target = (VIRTUAL_HEIGHT - self.height) / 2
    else
        target = self.y
    end

    target_distance = math.abs((target) - self.y)
    self.timer = self.timer + dt

    if target_distance <= self.margin then
        self.ai_dir = 0
        self.timer = 0
    elseif self.timer >= self.reaction_time then
        self.timer = 0

        -- Randomize margin of error
        self.margin = math.random(margin[1], margin[2])
        -- Randomize reaction speed
        self.reaction_time = lo + math.random() * (hi - lo)

        if target_distance <= self.margin then
            self.ai_dir = 0
        elseif self.y > target then
            self.ai_dir = -1
        elseif self.y < target then
            self.ai_dir = 1
        else
            self.ai_dir = 0
        end
    end
    self:move(self.ai_dir, dt)
end
