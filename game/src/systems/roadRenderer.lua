local RoadRenderer = ECS.system({
    pool = {"curve", "color"}
})

function RoadRenderer:draw()
    for _, e in ipairs(self.pool) do
        love.graphics.setColor(e.color.value)
        love.graphics.line(e.curve.value:render())

        local startX, startY = e.curve.value:getControlPoint(1)
        local endX, endY = e.curve.value:getControlPoint(e.curve.value:getControlPointCount())

        -- love.graphics.circle("fill", startX, startY, 2)
        -- love.graphics.circle("fill", endX, endY, 2)
    end
end

return RoadRenderer