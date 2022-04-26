local GridRenderer = ECS.system()

function GridRenderer:draw(camera)
    local grid = self:getWorld():getResource("grid")

    love.graphics.push("all")
    love.graphics.setLineWidth(1)
    love.graphics.setColor(1, 1, 1, 0.2)
    for x = -5000, 5000, grid.size do
        love.graphics.line(x, -5000, x, 5000)
    end
    for y = -5000, 5000, grid.size do
        love.graphics.line(-5000, y, 5000, y)
    end
    love.graphics.pop()
end

return GridRenderer