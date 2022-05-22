local RoadGraph = require("src.roadGraph")

local id = 0

local RoadFollower = ECS.component("roadFollower", function(e, road, maxVelocity, progress)
    e.road = nil
    e.progress = progress or 0
    e.velocity = 0
    e.maxVelocity = maxVelocity
    e.acceleration = 120
    e.deceleration = 120

    e.isBrakingForLight = false
    e.isBrakingForFollower = false

    e.id = id
    id = id + 1

    e.path = {}

    do
        local availablePaths = RoadGraph:getAvailablePaths(road)
        local _road = road
        while (_road) do
            local aval = availablePaths[_road]
            if (not aval) then
                break
            end

            local pick = love.math.random(1, #aval)
            local connections = RoadGraph:getConnections(_road)
            local index = availablePaths[_road][pick]
            local next = connections[index]
            e.path[_road] = next
            _road = next
        end
    end

    -- e.path = RoadGraph:getAvailablePaths(road)

    e:setRoad(road)
end)

function RoadFollower:setRoad(road)
    if (self.road) then
        self.road.road.occupants[self.__entity] = nil
    end

    self.road = road

    if (self.road) then
        self.road.road.occupants[self.__entity] = self.__entity
    end
end

function RoadFollower:distanceToNextFollower()
    local roads = self:getTraversingRoads()

    for i, road in ipairs(roads) do
        local progress = i == 1 and self.progress or 0

        local nearestFollower = nil
        local nearestProgress = math.huge

        for __, follower in pairs(road.road.occupants) do
            if (i > 1 or follower.roadFollower.progress > self.progress) then
                if (follower.roadFollower.progress < nearestProgress) then
                    nearestFollower = follower
                    nearestProgress = follower.roadFollower.progress
                end
            end
        end

        if (nearestFollower) then
            local distance

            if (i == 1) then
                distance = roads[1].curve:calculateLength(50, progress, nearestProgress)
            else
                distance = roads[1].curve:calculateLength(50, self.progress, 1)

                for j = 2, i do
                    distance = distance + roads[j].curve:calculateLength(50, 0, nearestProgress)
                end
            end

            distance = distance - nearestFollower.shape.value.size.h

            return distance
        end
    end

    return nil
end

function RoadFollower:distanceToNextNonPassableLight(start)
    start = start or self.progress

    local roads = self:getTraversingRoads()
    local nonPassableLightIndex

    local phase = math.floor((love.timer.getTime() / 2) % 4) + 1

    for i = 2, #roads do
        local road = roads[i]

        -- if (road.road.phase and road.road.phase ~= phase) then
        --     nonPassableLightIndex = i
        -- end

        if (road.road.isBridgeRoad and WarningLightsOn) then
            nonPassableLightIndex = i

            break
        end

        if (road.state and (road.state.value == "ORANGE" or road.state.value == "RED")) then
            nonPassableLightIndex = i

            break
        end

        if (road.state and (road.state.value == "GREENRED" and road.road.isBridgeWater)) then
            nonPassableLightIndex = i

            break
        end
    end

    if (nonPassableLightIndex) then
        local distance = roads[1].curve:calculateLength(10, start, 1)

        for i = 2, nonPassableLightIndex - 1 do
            distance = distance + roads[i].curve.length
        end

        return distance
    end

    return nil
end

function RoadFollower:getTraversingRoads()
    local roads = {}

    local road = self.road

    while (road) do
        table.insert(roads, road)
        road = self.path[road]
    end

    return roads
end