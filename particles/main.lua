require "vector"
require "particle"
require "particlesystem"
require "repeller"

function love.load()
    width = love.graphics.getWidth()
    height = love.graphics.getHeight()
    system = ParticleSystem:create(Vector:create(width/2 - 70, 150), 50, Particle)
    system2 = ParticleSystem:create(Vector:create(width/2 + 70, 150), 50, Particle)
    repeller = Repeller:create(Vector:create(width/2, height/2))
    
end

function love.draw()
    system:draw()
    system2:draw()
    repeller:draw()
end

function love.update(dt)
    system:update()
    system2:update()
    system:applyRepeller(repeller)
    system2:applyRepeller(repeller)
end