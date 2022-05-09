local RoadGraph = {
    roads = {}
}

function RoadGraph:addRoad(e, from, to)
    local road = {
        e = e,
        from = from,
        to = to,
        connections = {},
    }
    self.roads[e] = road

    for _, otherRoad in pairs(self.roads) do
        if (road.to == otherRoad.from) then
            table.insert(road.connections, otherRoad.e)
        end

        if (otherRoad.to == road.from) then
            table.insert(otherRoad.connections, road.e)
        end
    end
end

function RoadGraph:removeRoad(e)
    local road = self.roads[e]
    self.roads[e] = nil

    for _, otherRoad in pairs(self.roads) do
        for i = #otherRoad.connections, 1, -1 do
            local connection = otherRoad.connections[i]
            if (road == connection) then
                table.remove(otherRoad.connections, i)
            end
        end
    end
end

function RoadGraph:getConnections(e)
    return self.roads[e] and self.roads[e].connections or {}
end

local function getAvailablePaths(self, e, visited, parentNode)
    visited[e] = true
    local connections = self:getConnections(e)
    if (#connections == 0) then
        return true
    end

    parentNode[e] = {}
    local hasAValidPath = false


    for i, connection in ipairs(connections) do
        if (visited[connection]) then
            goto skip
        end

        hasAValidPath = getAvailablePaths(self, connection, visited, parentNode) or hasAValidPath
        
        if (hasAValidPath) then
            table.insert(parentNode[e], i)
        end

        ::skip::
    end

    return hasAValidPath
end

function RoadGraph:getAvailablePaths(e)
    local visited = {}
    local root = {}

    getAvailablePaths(self, e, visited, root)

    return root
end

return RoadGraph