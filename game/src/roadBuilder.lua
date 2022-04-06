local RoadBuilder = {}
RoadBuilder.__mt = {
    __index = RoadBuilder,
}

function RoadBuilder.new()
    local roadBuilder = setmetatable({
        nodes = {},
        edges = {},

        roads = {},
    }, RoadBuilder.__mt)

    return roadBuilder
end

function RoadBuilder:node(name, x, y, isStart)
    local node = {
        x = x,
        y = y,
        isStart = isStart
    }

    self.nodes[name] = node

    return self
end

function RoadBuilder:edge(from, to, curveType, id)
    local edge = {
        from = from,
        to = to,
        curveType = curveType,
        id = id,
    }

    table.insert(self.edges, edge)

    return self
end

function RoadBuilder:build(world)
    for _, edge in ipairs(self.edges) do
        local from = self.nodes[edge.from]
        local to = self.nodes[edge.to]

        if (from == nil) then
            error("Not registered: " .. edge.from)
        end

        if (to == nil) then
            error("Not registered: " .. edge.to)
        end

        local road = ECS.entity(world)
        :assemble(Assemblages.road, {x = from.x, y = from.y}, {x = to.x, y = to.y}, edge.curveType, edge.id)

        self.roads[road] = {
            from = edge.from,
            to = edge.to,
        }
    end

    for road, data in pairs(self.roads) do
        local to = data.to

        for oroad, odata in pairs(self.roads) do
            local from = odata.from

            if (to == from) then
                table.insert(road.connection.to, oroad)
                table.insert(oroad.connection.from, road)
            end
        end
    end

    for road, data in pairs(self.roads) do
        local from = self.nodes[data.from]

        if (from.isStart) then
            ECS.entity(world)
            :assemble(Assemblages.spawner, "CAR", road)
        end
    end
end

return setmetatable(RoadBuilder, {
    __call = function(_, ...) return RoadBuilder.new(...) end,
})