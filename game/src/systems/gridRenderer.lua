local GridRenderer = ECS.system()

function GridRenderer:draw(camera)
    local grid = self:getWorld():getResource("grid")

    if (not grid.visible) then
        goto skip
    end

    love.graphics.push("all")
    love.graphics.setLineWidth(1)
    love.graphics.setColor(1, 1, 1, 0.05)
    for x = -10000, 10000, grid.size do
        love.graphics.line(x, -10000, x, 10000)
    end
    for y = -10000, 10000, grid.size do
        love.graphics.line(-10000, y, 10000, y)
    end
    love.graphics.pop()

    ::skip::
end

return GridRenderer