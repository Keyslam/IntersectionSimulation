local RoadNodeRenderer = ECS.system({
    pool = {"roadNode"}
})

function RoadNodeRenderer:draw(camera)
    love.graphics.setColor(1, 1, 1, 1)
    for _, e in ipairs(self.pool) do
        love.graphics.circle("fill", e.roadNode.position.x, e.roadNode.position.y, 5)
    end
end

return RoadNodeRenderer