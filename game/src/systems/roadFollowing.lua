local RoadFollowing = ECS.system({
    pool = {"roadFollower"}
})

function RoadFollowing:update(dt)
    local RoadGraph = self:getWorld():getResource("roadGraph")

    for _, e in ipairs(self.pool) do
        local road = e.roadFollower.road

        local targetVelocity = e.roadFollower.maxVelocity

        if (not e.roadFollower.isBrakingForLight) then
            local distanceToNextNonPassableLight = e.roadFollower:distanceToNextNonPassableLight()

            if (distanceToNextNonPassableLight) then
                local nextFrameProgress = math.min(1, e.roadFollower.progress + e.roadFollower.velocity * dt / road.curve.length)
                local nextFrameDistanceToNextNonPassableLight = e.roadFollower:distanceToNextNonPassableLight(nextFrameProgress)

                local stoppingDistance = (e.roadFollower.velocity ^ 2) / (2 * e.roadFollower.deceleration) + 5

                local canBreakInTime = stoppingDistance < distanceToNextNonPassableLight + 5
                local canBreakInTimeNextFrame = stoppingDistance < nextFrameDistanceToNextNonPassableLight

                if (canBreakInTime and not canBreakInTimeNextFrame) then
                    e.roadFollower.isBrakingForLight = true
                end
            end
        end

        if (e.roadFollower.isBrakingForLight) then
            if road.state and (road.state.value == "ORANGE" or road.state.value == "RED") then
                e.roadFollower.isBrakingForLight = false
                targetVelocity = e.roadFollower.maxVelocity
            end

            targetVelocity = 0

            local distanceToNextNonPassableLight = e.roadFollower:distanceToNextNonPassableLight()

            if (not distanceToNextNonPassableLight or distanceToNextNonPassableLight > 200) then
                e.roadFollower.isBrakingForLight = false
            end
        end

        local distanceToNextFollower = e.roadFollower:distanceToNextFollower()
        if (distanceToNextFollower) then
            local stoppingDistance = (e.roadFollower.velocity ^ 2) / (2 * e.roadFollower.deceleration)

            if (distanceToNextFollower - stoppingDistance < 30) then
                e.roadFollower.isBrakingForFollower = true
            end
        end

        if (e.roadFollower.isBrakingForFollower) then
            if (not distanceToNextFollower) then
                e.roadFollower.isBrakingForFollower = false
            else
                local stoppingDistance = (e.roadFollower.velocity ^ 2) / (2 * e.roadFollower.deceleration)

                if (distanceToNextFollower - stoppingDistance > 50) then
                    e.roadFollower.isBrakingForFollower = false
                end
            end
        end

        if (e.collider) then
            local hc = self:getWorld():getResource("hc")

            local shapeCollisions = hc:collisions(e.collider.shape)
            local lookaheadCollisions = hc:collisions(e.collider.lookahead)

            for otherShape, separating_vector in pairs(lookaheadCollisions) do
                if (otherShape == e.collider.shape) then
                    goto continue
                end

                if (otherShape.isBody) then
                    local otherCollisions = hc:collisions(otherShape.entity.collider.shape)
                    if (otherCollisions[e.collider.shape]) then
                        if (otherShape.entity.roadFollower.id > e.roadFollower.id) then
                            targetVelocity = 0
                        end
                    else
                        targetVelocity = 0
                    end

                    goto continue
                end

                ::continue::
            end
        end

        if (e.roadFollower.isBrakingForFollower) then
            targetVelocity = 0
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
            if (e.roadFollower.path[road]) then
                local newRoad = e.roadFollower.path[road]
                e.roadFollower:setRoad(newRoad)
                e.roadFollower.progress = 0

                if (
                    road.road.sensorId == nil and newRoad.road.sensorId ~= nil or
                    road.road.sensorId ~= nil and newRoad.road.sensorId == nil or
                    (road.road.sensorId ~= nil and newRoad.road.sensorId ~= nil and
                        ((road.road.sensorId[1] ~= newRoad.road.sensorId[1]) or (road.road.sensorId[2] ~= newRoad.road.sensorId[2]))
                    )
                ) then
                    if (road.road.sensorId) then
                        self:getWorld():emit("ENTITY_EXITED_ZONE", road.road.sensorId[1], road.road.sensorId[2])
                    end

                    if (newRoad.road.sensorId) then
                        self:getWorld():emit("ENTITY_ENTERED_ZONE", newRoad.road.sensorId[1], newRoad.road.sensorId[2])
                    end
                end
            else
                if (road.road.sensorId) then
                    self:getWorld():emit("ENTITY_EXITED_ZONE", road.road.sensorId[1], road.road.sensorId[2])
                end

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