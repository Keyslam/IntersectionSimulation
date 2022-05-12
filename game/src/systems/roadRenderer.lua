local RoadRenderer = ECS.system({
    pool = {"road", "curve"}
})

function RoadRenderer:draw()
    local editorSettings = self:getWorld():getResource("editorSettings")

    for _, e in ipairs(self.pool) do
        if (e.preview and not e.preview.visible) then
            goto skip
        end

        if (e.selected) then
            love.graphics.setLineWidth(5)
        elseif (e.hovered) then
            love.graphics.setLineWidth(3)
        else
            love.graphics.setLineWidth(1)
        end
        love.graphics.setColor(e.color.value)

        if (e.road.isBridgeRoad) then
            local startX, startY = e.curve.value:getControlPoint(1)
            local endX, endY = e.curve.value:getControlPoint(e.curve.value:getControlPointCount())

            if (startX > endX) then
                startX, startY, endX, endY = endX, endY, startX, startY
            end

            local start = Vector(startX, startY)
            local finish = Vector(endX, endY)
            local delta = (finish - start) * (e.road.bridgeRoadProgress * 0.5 + 0.5)
            delta:rotateInplace(-math.pi / 2 * (1 - e.road.bridgeRoadProgress))

            love.graphics.line(startX, startY, startX + delta.x, startY + delta.y)
        else
            love.graphics.line(e.curve.value:render())
        end

        if (editorSettings.nodesVisible) then
            local startX, startY = e.curve.value:getControlPoint(1)
            local endX, endY = e.curve.value:getControlPoint(e.curve.value:getControlPointCount())

            love.graphics.circle("fill", startX, startY, 4)
            love.graphics.circle("fill", endX, endY, 4)
        end


        love.graphics.setColor(205 / 255, 73 / 255, 73 / 255)
        love.graphics.setLineWidth(4)
        -- local t = 0
        -- while (t <= 1) do
        --     local midpoint = Vector(e.curve.value:evaluate(t))
        --     local derivative = Vector(e.curve.derivative:evaluate(t)):normalizeInplace()

        --     local arrowL = derivative:clone():rotateInplace(-(math.pi / 2  * 1.7))
        --     local arrowR = derivative:clone():rotateInplace(math.pi / 2  * 1.7)
        --     love.graphics.line(
        --         midpoint.x,
        --         midpoint.y,
        --         midpoint.x + arrowL.x * 15,
        --         midpoint.y + arrowL.y * 15
        --     )
        --     love.graphics.line(
        --         midpoint.x, 
        --         midpoint.y,
        --         midpoint.x + arrowR.x * 15,
        --         midpoint.y + arrowR.y * 15
        --     )

        --     t = e.curve:step(t, 100)
        -- end


        if (editorSettings.directionsVisible) then
            local midpoint = Vector(e.curve.value:evaluate(0.5))
            local derivative = Vector(e.curve.derivative:evaluate(0.5)):normalizeInplace()

            local arrowL = derivative:clone():rotateInplace(-(math.pi / 2  * 1.7))
            local arrowR = derivative:clone():rotateInplace(math.pi / 2  * 1.7)
            love.graphics.line(
                midpoint.x,
                midpoint.y,
                midpoint.x + arrowL.x * 15,
                midpoint.y + arrowL.y * 15
            )
            love.graphics.line(
                midpoint.x,
                midpoint.y,
                midpoint.x + arrowR.x * 15,
                midpoint.y + arrowR.y * 15
            )
        end

        -- for i = 0, 1, 0.2 do
        --     local x, y = e.curve.value:evaluate(i)
        --     love.graphics.circle("fill", x, y, 2)
        -- end

        ::skip::
    end
end



return RoadRenderer