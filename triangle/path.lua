Path = {}
Path.__index = Path

function Path:create(points)
    local path = {}
    setmetatable(path, Path)
    path.points = points
    path.d = 20
    return path
end

function Path:draw()
    local r,g,b,a = love.graphics.getColor()
    love.graphics.setLineWidth(self.d)
    love.graphics.setColor(0.31, 0.31, 0.31, 0.7)
    for i=1, #self.points-1 do
        love.graphics.line(self.points[i].x, self.points[i].y, self.points[i+1].x, self.points[i+1].y)
    end
    love.graphics.setBlendMode("replace")
    for i=1, #self.points do
        love.graphics.circle("fill", self.points[i].x, self.points[i].y, self.d / 2)
    end
    love.graphics.setColor(0,0,0,0.7)
    love.graphics.setLineWidth(self.d / 10)
    for i=1, #self.points-1 do
        love.graphics.line(self.points[i].x, self.points[i].y, self.points[i+1].x, self.points[i+1].y)
    end
    love.graphics.setColor(r, g, b, a)
end