local Colors = require("src.colors")

local RoadLoader = ECS.system()

function RoadLoader:load()
    local serializedData= love.filesystem.read("roads.json")

    if (serializedData) then
        local data = JSON.decode(serializedData)

        for _, roadData in ipairs(data) do
            local from = Vector(roadData.from.x, roadData.from.y)
            local to = Vector(roadData.to.x, roadData.to.y)

            local e = ECS.entity(self:getWorld())
            :assemble(Assemblages.road, from, to, roadData.kind, roadData.id, roadData.sensorId)

            if (roadData.spawnKind) then
                e:give("spawner", roadData.spawnKind)
            end

            e.road.isTunnel = roadData.isTunnel
            e.road.isBridgeRoad = roadData.isBridgeRoad
            e.road.isBridgeWater = roadData.isBridgeWater
            e.road.phase = roadData.phase
        end
    end
end

return RoadLoader
