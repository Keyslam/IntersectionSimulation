local RoadGraph = require("src.roadGraph")

local RoadFollower = ECS.component("roadFollower", function(e, road, maxVelocity, progress)
    e.road = nil
    e.progress = progress or 0
    e.velocity = 0
    e.maxVelocity = maxVelocity
    e.acceleration = 120
    e.deceleration = 120

    e.path = RoadGraph:getAvailablePaths(road)

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
            if (follower.roadFollower.progress > self.progress) then
                if (follower.roadFollower.progress < nearestProgress) then
                    nearestFollower = follower
                    nearestProgress = follower.roadFollower.progress
                end
            end
        end

        if (nearestFollower) then
            local distance = road.curve:calculateLength(50, progress, nearestProgress)

            for j = 1, i - 1 do
                distance = distance + road.curve:calculateLength(50)
            end

            return distance
        end
    end

    return nil
end

function RoadFollower:distanceToNextNonPassableLight(start)
    start = start or self.progress

    local roads = self:getTraversingRoads()
    local nonPassableLightIndex

    for i = 2, #roads do
        local road = roads[i]

        if (road.state and (road.state.value == "ORANGE" or road.state.value == "RED")) then
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
        road = nil
        -- print("stuck")
        -- road = (RoadGraph:getConnections(road) or {[1] = nil})[1]
    end

    return roads
end