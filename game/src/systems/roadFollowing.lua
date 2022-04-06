local RoadFollowing = ECS.system({
    pool = {"roadFollower"}
})

function RoadFollowing:update(dt)
    for _, e in ipairs(self.pool) do
        local road = e.roadFollower.road

        local mustBrake = road.connection.to[1] and road.connection.to[1].state and road.connection.to[1].state.value == "RED"

        if (not mustBrake) then
            e.roadFollower.velocity = math.min(e.roadFollower.maxVelocity, e.roadFollower.velocity + e.roadFollower.acceleration * dt)
        else
            local deaccDistance = e.roadFollower.velocity ^ 2 / (2 * e.roadFollower.deceleration)
            local distance = (1 - e.roadFollower.progress) * road.curve.length

            if (distance > deaccDistance) then
                e.roadFollower.velocity = math.min(e.roadFollower.maxVelocity, e.roadFollower.velocity + e.roadFollower.acceleration * dt)
            else
                e.roadFollower.velocity = math.max(e.roadFollower.velocity - e.roadFollower.deceleration * dt, 0);
            end
        end

        local speed = e.roadFollower.velocity * dt
        local length = road.curve.length

        local additionalProgress = speed / length

        e.roadFollower.progress = math.min(1, e.roadFollower.progress + additionalProgress)

        if (e.roadFollower.progress == 1 and mustBrake) then
            if (road.connection.to[1]) then
                -- if (road.connection.to[1] == "GREEN") then
                    e.roadFollower.road = road.connection.to[1]
                    e.roadFollower.progress = 0
                -- end
            else
                e:destroy()
            end
        end
    end
end

return RoadFollowing