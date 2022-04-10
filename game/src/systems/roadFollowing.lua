local RoadFollowing = ECS.system({
    pool = {"roadFollower"}
})

function RoadFollowing:update(dt)
    for _, e in ipairs(self.pool) do
        local road = e.roadFollower.road

        local targetVelocity = e.roadFollower.maxVelocity

        if road.state and (road.state.value == "ORANGE" or road.state.value == "RED") then
            targetVelocity = e.roadFollower.maxVelocity
        else
            local distanceToNextNonPassableLight = e.roadFollower:distanceToNextNonPassableLight()

            if (distanceToNextNonPassableLight) then
                local nextFrameProgress = math.min(1, e.roadFollower.progress + e.roadFollower.velocity * dt / road.curve.length)
                local nextFrameDistanceToNextNonPassableLight = e.roadFollower:distanceToNextNonPassableLight(nextFrameProgress)

                local stoppingDistance = (e.roadFollower.velocity ^ 2) / (2 * e.roadFollower.deceleration) + 5

                local canBreakInTime = stoppingDistance < distanceToNextNonPassableLight + 5
                local canBreakInTimeNextFrame = stoppingDistance < nextFrameDistanceToNextNonPassableLight

                if (canBreakInTime and not canBreakInTimeNextFrame) then
                    targetVelocity = 0
                    -- print("Braking")
                end
            end
        end

        local distanceToNextFollower = e.roadFollower:distanceToNextFollower()
        if (distanceToNextFollower) then
            local stoppingDistance = (e.roadFollower.velocity ^ 2) / (2 * e.roadFollower.deceleration) + 20

            if (e.roadFollower.velocity > 0) then
                -- print(distanceToNextFollower)
            end
            if (stoppingDistance > distanceToNextFollower) then
                targetVelocity = 0
            end
        end

        local speed = e.roadFollower.velocity * dt

        local newProgress = road.curve:step(e.roadFollower.progress, speed)
        e.roadFollower.progress = math.min(1, newProgress)

        if (targetVelocity > e.roadFollower.velocity) then
            local acceleration = e.roadFollower.acceleration * dt
            e.roadFollower.velocity = math.min(targetVelocity, e.roadFollower.velocity + acceleration)
        elseif (targetVelocity < e.roadFollower.velocity) then
            local deceleration = e.roadFollower.deceleration * dt
            e.roadFollower.velocity = math.max(targetVelocity, e.roadFollower.velocity - deceleration)
        end

        if (e.roadFollower.progress == 1) then
            if (road.road.to[1]) then
                e.roadFollower:setRoad(road.road.to[1])
                e.roadFollower.progress = 0
            else
                e.roadFollower:setRoad(nil)
                e:destroy()
            end
        end
    end
end

function RoadFollowing:reset()
    for _, e in ipairs(self.pool) do
        e.roadFollower:setRoad(nil)
        e:destroy()
    end
end

return RoadFollowing