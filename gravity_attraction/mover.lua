Mover = {}
Mover.__index = Mover

function Mover:create(location, velocity, weight)
    local mover = {}
    setmetatable(mover, Mover)
    mover.location = location
    mover.velocity = velocity
    mover.acceleration = Vector:create(0, 0)
    mover.weight = weight or 1
    mover.size = 20  * mover.weight
    return mover
end

function Mover:random()
    local location = Vector:create()
    location.x = love.math.random(0, width)
    location.y = love.math.random(0, height)
    local velocity = Vector:create()
    velocity.x = love.math.random(-2, 2)
    velocity.y = love.math.random(-2, 2)
    return Mover:create(location, velocity)
end

function Mover:draw()
    love.graphics.setColor(math.random(255), math.random(255), math.random(255), 1)
    love.graphics.circle("fill", self.location.x, self.location.y, self.size)
end

function Mover:applyForce(force)
    self.acceleration:add(force * self.weight)
end

function Mover:checkBoundaries()
    if self.location.x > width - self.size then
        self.location.x = width - self.size
        self.velocity.x = -1 * self.velocity.x
    elseif self.location.x < self.size then
        self.location.x = self.size
        self.velocity.x = -1 * self.velocity.x
    end

    if self.location.y > height - self.size then
        self.location.y = height - self.size
        self.velocity.y = -1 * self.velocity.y
    elseif self.location.y < self.size then
        self.location.y = self.size
        self.velocity.y = 0
        self.acceleration.y = 1
    end
end

function Mover:attract(mover)
    local diff = self.location - mover.location
    local distance = diff:mag()
    if distance < 5 then
        distance = 5
    end
    if distance > 30 then
        distance = 30
    end
    local force = diff:norm()
    local G = mover.weight / 2
    local strength = (G * self.weight * mover.weight) / (distance * distance)
    force:mul(strength)
    mover:applyForce(force)
end

function Mover:update()
    self.velocity:add(self.acceleration) 
    self.location:add(self.velocity)
    self.acceleration:mul(0)
end