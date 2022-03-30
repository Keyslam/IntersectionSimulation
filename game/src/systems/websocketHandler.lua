local Websocket = require("lib.websocket")
local Json = require("lib.json")

local WebsocketHandler = ECS.system({
    pool = {"websocket"}
})

function WebsocketHandler:init()
    self.pool.onAdded = function(_, e)
        e.websocket.client = Websocket.new(e.websocket.host, e.websocket.port)

        function e.websocket.client.onopen()
            self:onOpen(e)
        end

        function e.websocket.client.onmessage(_, message)
            self:onMessage(e, message)
        end
    end
end

function WebsocketHandler:update(dt)
    for _, e in ipairs(self.pool) do
        e.websocket.client:update()
    end
end

function WebsocketHandler:onOpen(e)
    local message = Json.encode({
        eventType = "CONNECT_SIMULATOR",

        data = {
            sessionName = "JustinEnNyk2",
            sessionVersion = 1,

            discardParseErrors = false,
            discardEventTypeErrors = false,
            discardMalformedDataErrors = false,
            discardInvalidStateErrors = false,
        }
    })

    e.websocket.client:send(message)
end

function WebsocketHandler:onMessage(e, message)
    local data = Json.decode(message)

    self:getWorld():emit("messageReceived", e, message)
    self:getWorld():emit("MESSAGE_"..data.eventType, e, data.data)
end

function WebsocketHandler.MESSAGE_SESSION_START(self, e, data)
    print("Session started")

    local message = Json.encode({
        eventType = "ENTITY_ENTERED_ZONE",

        data = {
            routeId = 4,
            sensorId = 20,
        }
    })

    self:getWorld():emit("messageSent", e, message)
    e.websocket.client:send(message)
end

function WebsocketHandler.MESSAGE_SESSION_STOP(self, e, data)
    print("Session ended")
end

function WebsocketHandler.MESSAGE_SET_AUTOMOBILE_ROUTE_STATE(self, e, data)
    print("Received 'SET_AUTOMOBILE_ROUTE_STATE'")
    print("RouteID: " .. data.routeId)
    print("State:   " .. data.state)

end

return WebsocketHandler