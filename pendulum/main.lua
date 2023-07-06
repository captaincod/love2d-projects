require "pendulum"
require "vector"
require "mover"
require "spring"

function love.load()
    width = love.graphics.getWidth()
    height = love.graphics.getHeight()
    -- gravity = 0.4
    -- pend = Pendulum:create(Vector:create(width/2, 10), 200)
    -- pend1 = Pendulum:create(pend.position, 100)
    mover = Mover:create(width/2, height - 100, 30)
    mover2 = Mover:create(width - width/3, height/2, 30)
    mover3 = Mover:create(width - width/4, height - 200, 30)
    spring = Spring:create(mover.position, 200)
    spring2 = Spring:create(mover2.position, 200)
    spring3 = Spring:create(mover3.position, 200)
end

function love.draw()
    -- pend:draw()
    -- pend1:draw()
    
    mover:draw()
    mover2:draw()
    mover3:draw()
    spring:draw()
    spring:drawLine(mover2)
    spring2:draw()
    spring2:drawLine(mover3)
    spring3:draw()
    spring3:drawLine(mover)
end

function love.update()
    -- pend:update()
    -- pend1:update()

    mover:update()
    mover2:update()
    mover3:update()
    spring:apply(mover2)
    spring:constrain(mover2, 50, 400)
    spring2:apply(mover3)
    spring2:constrain(mover3, 50, 400)
    spring3:apply(mover)
    spring3:constrain(mover, 50, 400)
end

function love.mousepressed(x, y, button, istouch, presses)
    if button == 1 then
    --     pend:clicked(x, y)
    --     pend1:clicked(x, y)
        mover:clicked(x, y)
        mover2:clicked(x, y)
        mover3:clicked(x, y)
    end
end

function love.mousereleased(x, y, button, istouch, presses)
    if button == 1 then
    --     pend:stopDragging()
    --     pend1:stopDragging()
        mover:stopGrabbing()
        mover2:stopGrabbing()
        mover3:stopGrabbing()
    end
end