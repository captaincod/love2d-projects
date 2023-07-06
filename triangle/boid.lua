Boid = {}
Boid.__index = Boid

function Boid:create(x, y, red, green, blue, points)
    local boid = {}
    setmetatable(boid, Boid)
    boid.acceleration = Vector:create(0, 0)
    boid.location = Vector:create(x, y)
    boid.r = 5
    boid.verticles = {0, -boid.r * 2, -boid.r, boid.r * 2, boid.r, 2 * boid.r}
    boid.maxSpeed = 4
    boid.maxForce = 0.1
    boid.wtheta = 0
    boid.velocity = Vector:create(0.5, 0.5)
    -- boid.texture = love.graphics.newImage("brudah1488.png")
    boid.isSep = false
    boid.isAlign = false
    boid.isCoh = false
    boid.red = red
    boid.green = green
    boid.blue = blue
    boid.trans = 1
    boid.points = points
    -- boid.previous = 1
    return boid
end

function Boid:draw()
    local theta = self.velocity:heading() + math.pi / 2
    love.graphics.push()
    love.graphics.translate(self.location.x, self.location.y)
    love.graphics.rotate(theta)
    love.graphics.polygon("fill", self.verticles)
    love.graphics.setColor(self.red, self.green, self.blue, self.trans)
    -- love.graphics.draw(self.texture, 0.1 * self.texture:getWidth() / 2, 0.1 * self.texture:getHeight() / 2, 0.1, 0.1)
    love.graphics.pop()
end

function Boid:applyForce(force)
    self.acceleration:add(force)
end

function Boid:checkBoundaries()
    if self.location.x > width - self.r then
        self.location.x = width - self.r
        self.velocity.x = -1 * self.velocity.x
    elseif self.location.x < self.r then
        self.location.x = self.r
        self.velocity.x = -1 * self.velocity.x
    end

    if self.location.y > height - self.r then
        self.location.y = height - self.r
        self.velocity.y = -1 * self.velocity.y
    elseif self.location.y < self.r then
        self.location.y = self.r
        self.velocity.y = 0
        self.acceleration.y = 1
    end
end

function Boid:update()
    self.velocity:add(self.acceleration)
    self.velocity:limit(self.maxSpeed)
    self.location:add(self.velocity)
    self.acceleration:mul(0)
end

function Boid:boundaries()
    local desired = nil
    local d = 100
    if (self.location.x < d) then
        desired = Vector:create(self.maxSpeed, self.velocity.y)
    elseif self.location.x > width - d then
        desired = Vector:create(-self.maxSpeed, self.velocity.y)        
    end
    if (self.location.y < d) then
        desired = Vector:create(self.velocity.x, self.maxSpeed)
    elseif self.location.y > height - d then
        desired = Vector:create(self.velocity.x, -self.maxSpeed)        
    end
    if desired then
        desired:norm()
        desired:mul(self.maxSpeed)
        local steer = desired - self.velocity
        steer:limit(self.maxForce)
        self:applyForce(steer)
    end
end

function Boid:seek(target)
    local desired = target - self.location
    local mag = desired:mag()
    desired:norm()
    if mag < 100 then
       local m = math.map(mag, 0, 100, 0, self.maxSpeed)
       desired:mul(m)
    else
        desired:mul(self.maxSpeed)
    end
    local steer = desired - self.velocity
    steer:limit(self.maxForce)
    -- self:applyForce(steer)
    return steer
end

function Boid:flee(target)
    local desired = target - self.location
    local mag = desired:mag()
    if mag < 100 then
        desired:mul(self.maxSpeed)
        desired:mul(-1)
    else
        desired:mul(0.00000001)
        desired:mul(-1)
    end
    local steer = desired - self.velocity
    steer:limit(self.maxForce)
    self:applyForce(steer)
end

function Boid:separate(others)
    local separation = 25.
    local steer = Vector:create(0, 0)
    local count = 0
    for i=0, #others do
        local other = others[i]
        local d = self.location:distTo(other.location)
        if d > 0 and d < separation then
            local diff = self.location - other.location
            diff:norm()
            diff:div(d)
            steer:add(diff)
            count = count + 1
        end
    end
    if count > 0 then
        steer:div(count)
    end
    if steer:mag() > 0 then
        steer:norm()
        steer:mul(self.maxSpeed)
        steer:sub(self.velocity)
        steer:limit(self.maxForce)
    end
    return steer
end

function Boid:flock(others)
    local sep = self:separate(others)
    sep:mul(5.5)
    if self.isSep then
        self:applyForce(sep)
    end

    local align = self:align(others)
    align:mul(5.5)
    if self.isAlign then
        self:applyForce(align)
    end

    local coh = self:cohesion(others)
    coh:mul(5.5)
    if self.isCoh then
        self:applyForce(coh)
    end
end

function Boid:align(others)
    local ndist = 50
    local sum = Vector:create(0, 0)
    local count = 0
    for i=0, #others do
        local other = others[i]
        local d = self.location:distTo(other.location)
        if d > 0 and d < ndist then
            sum:add(other.velocity)
            count = count + 1
        end
    end
    if count > 0 then
        sum:div(count)
        sum:norm()
        sum:mul(self.maxSpeed)
        local steer = sum - self.velocity
        steer:limit(self.maxForce)
        return steer
    end
    return Vector:create(0, 0)
end

function Boid:cohesion(others)
    local ndist = 50
    local sum = Vector:create(0, 0)
    local count = 0
    for i=0, #others do
        local other = others[i]
        local d = self.location:distTo(other.location)
        if d > 0 and d < ndist then
            sum:add(other.location)
            count = count + 1
        end
    end
    if count > 0 then
        sum:div(count)
        return self:seek(sum)
    end
    return Vector:create(0, 0)
end

function Boid:follow(path)
    local predict = self.velocity:copy()
    predict:norm()
    predict:mul(80)
    local pos = self.location + predict
    local minDist = 1000000
    local toFollow = 1
    for i=1, #self.points-1 do
        local dist = pos:distTo(self.points[i])
        if dist < minDist then
            toFollow = i
            minDist = dist
        end
    end
    local a = self.points[toFollow]
    local b = self.points[toFollow+1]
    local normal = math.normal(pos, a, b)
    local dir = b - a
    dir:norm()
    dir:mul(10)
    local target = normal + dir
    local distance = pos:distTo(dir)
    if distance > path.d then
        local f = self:seek(target)
        self:applyForce(f)
    end
    self.previous = i
end