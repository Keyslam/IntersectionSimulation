local RoadRenderer = ECS.system({
    pool = {"road", "curve", "color"}
})

function RoadRenderer:draw()
    for _, e in ipairs(self.pool) do
        love.graphics.setColor(e.color.value)
        love.graphics.line(e.curve.value:render())

        local startX, startY = e.curve.value:getControlPoint(1)
        local endX, endY = e.curve.value:getControlPoint(e.curve.value:getControlPointCount())

        love.graphics.circle("fill", startX, startY, 2)
        love.graphics.circle("fill", endX, endY, 2)

        -- local t = 0
        -- while (t <= 1) do
        --     local x, y = e.curve.value:evaluate(t)
        --     love.graphics.circle("fill", x, y, 2)

        --     t = e.curve:step(t, 20)
        -- end

        -- for i = 0, 1, 0.2 do
        --     local x, y = e.curve.value:evaluate(i)
        --     love.graphics.circle("fill", x, y, 2)
        -- end
    end
end



return RoadRenderer