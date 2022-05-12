local Colors = require("src.colors")
local Json = require("lib.json")

local BridgeHandler = ECS.system({
    pool = {"road"},
    websocket = {"websocket"}
})

function BridgeHandler:init()
    self.progress = 1
    self.state = "DOWN"
    self.acknowledged = "DOWN"
end

function BridgeHandler:MESSAGE_REQUEST_BRIDGE_STATE(_, data)
    self.state = data.state
end

function BridgeHandler:update(dt)
    if (self.state == "UP") then
        self.progress = math.max(0, self.progress - dt * 0.25)

        if (self.progress == 0 and self.state ~= self.acknowledged) then
            local message = Json.encode({
                eventType = "ACKNOWLEDGE_BRIDGE_STATE",
                data = {
                    state = self.state
                }
            })

            for _, e in ipairs(self.websocket) do
                self:getWorld():emit("messageSent", e, message)
                e.websocket.client:send(message)
            end

            self.acknowledged = self.state
        end
    end

    if (self.state == "DOWN") then
        self.progress = math.min(1, self.progress + dt * 0.25)

        if (self.progress == 1 and self.state ~= self.acknowledged) then
            local message = Json.encode({
                eventType = "ACKNOWLEDGE_BRIDGE_STATE",
                data = {
                    state = self.state
                }
            })

            for _, e in ipairs(self.websocket) do
                self:getWorld():emit("messageSent", e, message)
                e.websocket.client:send(message)
            end

            self.acknowledged = self.state
        end
    end

    for _, e in ipairs(self.pool) do
        e.road.bridgeRoadProgress = self.progress
    end
end

return BridgeHandler