local RoadRenderer = ECS.system({
    pool = {"curve", "color"}
})

function RoadRenderer:draw()
    for _, e in ipairs(self.pool) do
        love.graphics.setColor(e.color.value)
        love.graphics.line(e.curve.value:render())
    end
end

return RoadRenderer