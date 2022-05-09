local Colors = require("src.colors")

local BarrierRenderer = ECS.system({
    pool = {"barrier", "transform"}
})

function BarrierRenderer:draw(camera)
    for _, e in ipairs(self.pool) do
        local from = e.transform.position
        local to = from + (e.barrier.size * Vector(0, 850))

        love.graphics.setColor(Colors.barrier)
        love.graphics.line(from.x, from.y, to.x, to.y)
    end
end

return BarrierRenderer