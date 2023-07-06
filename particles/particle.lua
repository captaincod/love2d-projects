Particle = {}
Particle.__index = Particle

function Particle:create(position)
    local particle = {}
    setmetatable(particle, Particle)
    particle.position = position
    particle.acceleration = Vector:create(0, 0.5)
    particle.velocity = Vector:create(math.random(-10, 10) / 10, math.random(-10, 0 / 10))
    particle.lifespan = math.random(30, 80)
    particle.texture = love.graphics.newImage("assets/texture.png")
    return particle
end

function Particle:update()
    self.velocity:add(self.acceleration)
    self.position:add(self.velocity)
    self.lifespan = self.lifespan - 1
end

function Particle:isDead()
    if self.lifespan < 0 then
        return true
    end
    return false
end

function Particle:draw()
    r, g, b, a = love.graphics.getColor()
    love.graphics.setColor(0, 0, 255, self.lifespan / 100)
    love.graphics.draw(self.texture, self.position.x - self.texture:getWidth() / 2, self.position.y - self.texture:getHeight() / 2)
    love.graphics.setColor(r, g, b, a)
end

function Particle:applyForce(force)
    self.acceleration:add(force)
end