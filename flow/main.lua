require("vector")
require("vehicle")
require("flow")

function love.load()
    width = love.graphics.getWidth()
    height = love.graphics.getHeight()

    vehicle = Vehicle:create(width / 2, height / 2)

    map = FlowMap:create(20)
    map:init()


end

function love.update(dt)
    vehicle:borders()
    vehicle:follow(map)
    vehicle:update()
end

function love.draw()
    map:draw()
    vehicle:draw()
end

