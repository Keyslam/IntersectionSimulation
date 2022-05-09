local Colors = require("src.colors")

local ShapeRenderer = ECS.system({
    pool = {"transform", "shape", "color"}
})

function ShapeRenderer:draw()
    for _, e in ipairs(self.pool) do
        local isInTunnel = e.roadFollower and e.roadFollower.road.road.isTunnel

        love.graphics.translate(e.transform.position.x, e.transform.position.y)
        love.graphics.rotate(e.transform.rotation)
        love.graphics.translate(-e.shape.value.size.w / 2, -e.shape.value.size.h / 2)

        love.graphics.setLineWidth(1)
        
        love.graphics.setColor(e.color.value[1], e.color.value[2], e.color.value[3], isInTunnel and 0.2 or e.color.value[4])
        love.graphics.polygon("fill", e.shape.value.outline)

        love.graphics.setColor(Colors.outline[1], Colors.outline[2], Colors.outline[3], isInTunnel and 0.2 or Colors.outline[4])
        love.graphics.polygon("line", e.shape.value.outline)

        love.graphics.translate(e.shape.value.size.w / 2, e.shape.value.size.h / 2)
        love.graphics.rotate(-e.transform.rotation)
        love.graphics.translate(-e.transform.position.x, -e.transform.position.y)
    end
end

return ShapeRenderer