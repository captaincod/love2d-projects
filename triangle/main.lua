require("vector")
require("boid")
require("path")

function love.load()
    width = love.graphics.getWidth()
    height = love.graphics.getHeight()

    points1 = {Vector:create(20, height/2+200), Vector:create(width/3, height/2-100), Vector:create(2*width/3, height/2+100), Vector:create(width-20, 300)}

    count = 100

    boids = {}
    for i=0, count do
        boids[i] = Boid:create(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, math.random(), math.random(), math.random(), points1)
    end

    isSep = false
    isAlign = false
    isCoh = false

    path = Path:create(points1)

    -- boid = Boid:create(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
    -- boid:applyForce(Vector:create(3, -2))
end

function love.update(dt)
    for i=0, count do
        boids[i].isSep = isSep
        boids[i].isAlign = isAlign
        boids[i].isCoh = isCoh
        boids[i]:flock(boids)
        boids[i]:follow(path)
        boids[i]:checkBoundaries()
        boids[i]:update()
    end

    -- local x, y = love.mouse.getPosition()
    -- local mouse = Vector:create(x, y)

    -- boid:flee(mouse)

    -- boid:checkBoundaries()
    -- -- boid:boundaries()
    -- boid:update()
end

function love.draw()
    path:draw()
    for i=0, count do
        boids[i]:draw()
        
    end
    -- boid:draw()
end

function love.keypressed(key)
    if key == 's' then
        isSep = not isSep
    end
    if key == 'a' then
        isAlign = not isAlign
    end
    if key == 'c' then
        isCoh = not isCoh
    end
end

