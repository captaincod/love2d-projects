ParticleSystem = {}
ParticleSystem.__index = ParticleSystem

function ParticleSystem:create(origin, n, cls)
    local system = {}
    setmetatable(system, ParticleSystem)
    system.origin = origin
    system.n = n or 10
    system.particles = {}
    system.cls = cls or Particle
    self.index = 1
    return system
end

function ParticleSystem:createParticles()
    for i=1, self.n, 1 do
        self.particles[i] = self.cls:create(self.origin:copy())
    end
end

function ParticleSystem:draw()
    for k, v in pairs(self.particles) do
        v:draw()
    end
end

-- для глобальных сил - ветер, гравитация
function ParticleSystem:applyForce(force)
    for k, v in pairs(self.particles) do
        v:applyForce(force)
    end
end

-- для локальных сил
function ParticleSystem:applyRepeller(repeller)
    for k, v in pairs(self.particles) do
        v:applyForce(repeller:repel(v))
    end
end

function ParticleSystem:createParticle()
    return self.cls:create(self.origin:copy())
end

function ParticleSystem:update()
    if #self.particles < self.n then
        self.particles[self.index] = self:createParticle()
        self.index = self.index + 1
    end
    for k,v in pairs(self.particles) do
        if v:isDead() then
            v = self:createParticle()
            self.particles[k] = v
        end
        v:update()
    end
end