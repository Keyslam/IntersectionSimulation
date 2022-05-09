local SensorHandler = ECS.system({
    pool = {"road"}
})

function SensorHandler:update(dt)
    for _, e in ipairs(self.pool) do
        if (e.road.sensorId) then
            for __, occupant in pairs(e.road.occupants) do
                if (occupant.roadFollower.progress > 0.1 and occupant.roadFollower.progress < 0.6) then
                    if (not e.road.preSensor[occupant]) then
                        e.road.preSensor[occupant] = true
                        self:getWorld():emit("ENTITY_ENTERED_ZONE", e.road.sensorId[1], e.road.sensorId[2])
                    end
                else
                    if (e.road.preSensor[occupant]) then
                        e.road.preSensor[occupant] = nil
                        self:getWorld():emit("ENTITY_EXITED_ZONE", e.road.sensorId[1], e.road.sensorId[2])
                    end
                end

                if (occupant.roadFollower.progress > 0.8 and occupant.roadFollower.progress < 0.98) then
                    if (not e.road.sensor[occupant]) then
                        e.road.sensor[occupant] = true
                        self:getWorld():emit("ENTITY_ENTERED_ZONE", e.road.sensorId[1], e.road.sensorId[2])
                    end
                else
                    if (e.road.sensor[occupant]) then
                        e.road.sensor[occupant] = nil
                        self:getWorld():emit("ENTITY_EXITED_ZONE", e.road.sensorId[1], e.road.sensorId[2])
                    end
                end
            end
        end
    end
end


return SensorHandler