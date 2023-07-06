Man = {}
Man.__index = Man

function Man:create(x, y)
    local man = {}
    setmetatable(man, Man)
    self.x = x
    self.y = y
    return man
end

function Man:draw()
    r, g, b, a = love.graphics.getColor()
    love.graphics.setColor(0.8, 0.7, 0.7)
    love.graphics.circle("fill", self.x, self.y, 30)
    love.graphics.setColor(0, 0.5, 1)
    love.graphics.circle("fill", self.x + 10, self.y - 10, 5)
    love.graphics.circle("fill", self.x - 10, self.y - 10, 5)
    love.graphics.setColor(0, 0, 0)
    love.graphics.line(self.x - 15, self.y - 4, self.x - 6, self.y - 3)
    love.graphics.line(self.x + 15, self.y - 4, self.x + 6, self.y - 3)
    love.graphics.setColor(1, 0, 0.2)
    love.graphics.line(self.x - 7, self.y - 23, self.x + 7, self.y - 23)
    love.graphics.setColor(r, g, b, a)
end