local Colors = require("src.colors")
local Json = require("lib.json")

local RoadHandler = ECS.system({
    pool = {"color", "state", "id"},
    roads = {"road"},
    websocket = {"websocket"}
})

function RoadHandler:init()
    self.waitingForBridgeRoadEmpty = false
    self.waitingForBridgeWaterEmpty = false
    self.idLookup = {}
    self.t = 0

    self.pool.onAdded = function(_, e)
        self:__syncColor(e)
    end

    self.pool.onRemoved = function(_, e)
        if (e.color) then
            e.color.value = Colors.road.normal
        end
    end
end

local function handleSetRouteState(self, data)
    for _, e in ipairs(self.pool) do
        if (e.id.value == data.routeId) then
            e.state.value = data.state
            self:__syncColor(e)
        end
    end
end

function RoadHandler:MESSAGE_SET_AUTOMOBILE_ROUTE_STATE(_, data)
    handleSetRouteState(self, data)
end

function RoadHandler:MESSAGE_SET_BICYCLE_ROUTE_STATE(_, data)
    handleSetRouteState(self, data)
end

function RoadHandler:MESSAGE_SET_PEDESTRIAN_ROUTE_STATE(_, data)
    handleSetRouteState(self, data)
end

function RoadHandler:MESSAGE_SET_BOAT_ROUTE_STATE(_, data)
    handleSetRouteState(self, data)
end

function RoadHandler:MESSAGE_REQUEST_BRIDGE_ROAD_EMPTY(_, data)
    self.waitingForBridgeRoadEmpty = true
    self.t = 2
end

function RoadHandler:MESSAGE_REQUEST_BRIDGE_WATER_EMPTY(_, data)
    self.waitingForBridgeWaterEmpty = true
    self.t = 2
end

function RoadHandler:update(dt)
    if (self.waitingForBridgeRoadEmpty) then
        self.t = self.t - dt

        if (self.t < 0) then
            local isEmpty = true
            for _, e in ipairs(self.roads) do
                if (e.road.isBridgeRoad) then
                    for _, _ in pairs(e.road.occupants) do
                        isEmpty = false
                        break
                    end
                end
            end

            if (isEmpty) then
                self.waitingForBridgeRoadEmpty = false

                local message = Json.encode({
                    eventType = "ACKNOWLEDGE_BRIDGE_ROAD_EMPTY",
                })

                for _, e in ipairs(self.websocket) do
                    self:getWorld():emit("messageSent", e, message)
                    e.websocket.client:send(message)
                end
            end
        end
    end

    if (self.waitingForBridgeWaterEmpty) then
        self.t = self.t - dt

        if (self.t < 0) then
            local isEmpty = true
            for _, e in ipairs(self.roads) do
                if (e.road.isBridgeWater) then
                    for _, _ in pairs(e.road.occupants) do
                        isEmpty = false
                        break
                    end
                end
            end

            if (isEmpty) then
                self.waitingForBridgeWaterEmpty = false

                local message = Json.encode({
                    eventType = "ACKNOWLEDGE_BRIDGE_WATER_EMPTY",
                })

                for _, e in ipairs(self.websocket) do
                    self:getWorld():emit("messageSent", e, message)
                    e.websocket.client:send(message)
                end
            end
        end
    end
end

function RoadHandler:reset()
    for _, e in ipairs(self.pool) do
        e.state.value = "RED"
        self:__syncColor(e)
    end
end

function RoadHandler:__syncColor(e)
    if (e.state.value == "RED") then
        e.color.value = Colors.road.red
    elseif (e.state.value == "ORANGE" or e.state.value == "BLINKING" or e.state.value == "GREENRED") then
        e.color.value = Colors.road.orange
    elseif (e.state.value == "GREEN") then
        e.color.value = Colors.road.green
    end
end

return RoadHandler