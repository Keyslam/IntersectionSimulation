local RoadRenderer = ECS.system({
    pool = {"road", "curve"}
})

function RoadRenderer:draw()
    for _, e in ipairs(self.pool) do
        if (e.preview and not e.preview.visible) then
            goto skip
        end

        if (e.selected) then
            love.graphics.setLineWidth(3)
        elseif (e.hovered) then
            love.graphics.setLineWidth(2)
        else
            love.graphics.setLineWidth(1)
        end
        love.graphics.setColor(e.color.value)
        love.graphics.line(e.curve.value:render())

        local startX, startY = e.curve.value:getControlPoint(1)
        local endX, endY = e.curve.value:getControlPoint(e.curve.value:getControlPointCount())

        love.graphics.circle("fill", startX, startY, 4)
        love.graphics.circle("fill", endX, endY, 4)

        local t = 0
        while (t <= 1) do
            local midpoint = Vector(e.curve.value:evaluate(t))
            local derivative = Vector(e.curve.derivative:evaluate(t)):normalizeInplace()

            local arrowL = derivative:clone():rotateInplace(-(math.pi / 2  * 1.7))
            local arrowR = derivative:clone():rotateInplace(math.pi / 2  * 1.7)
            love.graphics.line(
                midpoint.x,
                midpoint.y,
                midpoint.x + arrowL.x * 10,
                midpoint.y + arrowL.y * 10
            )
            love.graphics.line(
                midpoint.x, 
                midpoint.y,
                midpoint.x + arrowR.x * 10,
                midpoint.y + arrowR.y * 10
            )

            t = e.curve:step(t, 50)
        end

        -- for i = 0, 1, 0.2 do
        --     local x, y = e.curve.value:evaluate(i)
        --     love.graphics.circle("fill", x, y, 2)
        -- end

        ::skip::
    end
end



return RoadRenderer