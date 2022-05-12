local RoadSaver = ECS.system({
    pool = {"road", "curve"}
})

function RoadSaver:save()
    local data = {}

    for _, e in ipairs(self.pool) do
        if (e.preview) then
            goto skip
        end

        local road = e.road
        local curve = e.curve

        table.insert(data, {
            from = {
                x = curve.from.x,
                y = curve.from.y,
            },

            to = {
                x = curve.to.x,
                y = curve.to.y,
            },

            kind = curve.kind,

            spawnKind = e.spawner and e.spawner.kind,
            id = e.id and e.id.value,
            sensorId = road.sensorId,
            isTunnel = road.isTunnel and true or false,
            isBridgeRoad = road.isBridgeRoad and true or false,
            isBridgeWater = road.isBridgeWater and true or false,
            phase = e.road.phase,
        })

        ::skip::
    end

    local serializedData = JSON.encode(data)
    love.filesystem.write("roads.json", serializedData)
end

return RoadSaver