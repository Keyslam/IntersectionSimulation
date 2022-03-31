local ShapeRenderer = ECS.system({
    pool = {"transform", "shape", "color"}
})

function ShapeRenderer:draw()
    for _, e in ipairs(self.pool) do
        love.graphics.setColor(e.color.value)

        love.graphics.translate(e.transform.position.x, e.transform.position.y)
        love.graphics.rotate(e.transform.rotation)
        love.graphics.translate(-e.shape.value.size.w / 2, -e.shape.value.size.h / 2)

        love.graphics.polygon("line", e.shape.value.outline)

        love.graphics.translate(e.shape.value.size.w / 2, e.shape.value.size.h / 2)
        love.graphics.rotate(-e.transform.rotation)
        love.graphics.translate(-e.transform.position.x, -e.transform.position.y)
    end
end

return ShapeRenderer