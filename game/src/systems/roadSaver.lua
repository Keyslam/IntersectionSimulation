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
        })

        ::skip::
    end

    local serializedData = JSON.encode(data)
    love.filesystem.write("roads.txt", serializedData)
end

return RoadSaver