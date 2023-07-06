require("vector")
require("mover")
require("attractor")

function love.load()
    width = love.graphics.getWidth()
    height = love.graphics.getHeight()

    -- local location = Vector:create(width / 2 + 100, height / 2)
    -- attractor = Attractor:create(location, 20)

    movers = {}
    for i=1, 11 do
        local location = Vector:create(math.random(width), math.random(height))
        local velocity = Vector:create(math.random(), math.random())
        local weight = math.random(6)
        movers[i] = Mover:create(location, velocity, weight/2)
    end
end

function love.update(dt)
    for i=1, 11 do
        movers[i]:checkBoundaries()
        movers[i]:update()
        for j=1, 11 do
            if j ~= i then
                movers[i]:attract(movers[j])
            end
        end
    end
    -- attractor:attract(mover)
end

function love.draw()
    for i=1, 11 do
        movers[i]:draw()
    end
    -- attractor:draw()
end

function love.keypressed(key)
end
