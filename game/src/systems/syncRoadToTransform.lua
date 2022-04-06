local SyncRoadToTransform = ECS.system({
    pool = {"roadFollower", "transform"}
})

function SyncRoadToTransform:update()
    for _, e in ipairs(self.pool) do
        local road = e.roadFollower.road

        local t = e.roadFollower.progress
        local x, y = road.curve.value:evaluate(t)

        local derivative = road.curve.value:getDerivative()
        local dx, dy = derivative:evaluate(t)
        local rotation = math.atan2(dy,dx)

        e.transform.position.x = x
        e.transform.position.y = y

        e.transform.rotation = rotation
    end
end

return SyncRoadToTransform