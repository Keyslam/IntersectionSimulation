local Colors = require("src.colors")
local Json = require("lib.json")

local BarrierHandler = ECS.system({
    pool = {"barrier"},
    websocket = {"websocket"}
})

function BarrierHandler:init()
    self.progress = 0
    self.state = "UP"
    self.acknowledged = "UP"
end

function BarrierHandler:update(dt)
    if (self.state == "UP") then
        self.progress = math.max(0, self.progress - dt * 0.25)

        if (self.progress == 0 and self.state ~= self.acknowledged) then
            local message = Json.encode({
                eventType = "ACKNOWLEDGE_BARRIERS_STATE",
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
                eventType = "ACKNOWLEDGE_BARRIERS_STATE",
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
        e.barrier.size = self.progress
    end
end

function BarrierHandler:MESSAGE_REQUEST_BARRIERS_STATE(_, data)
    self.state = data.state
    print(data.state)
end

return BarrierHandler