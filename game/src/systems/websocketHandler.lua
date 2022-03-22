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
            sessionName = "JustinEnNyk",
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

    local handler = self.handlers[data.eventType]

    if (not handler) then
        print("Received unhandled event type: " .. data.eventType)
        return
    end

    handler(self, e, data)
end

WebsocketHandler.handlers = {}

WebsocketHandler.handlers["SESSION_START"] = function(self, e, data)
    print("Session started")

    local message = Json.encode({
        eventType = "ENTITY_ENTERED_ZONE",

        data = {
            routeId = 4,
            sensorId = 20,
        }
    })

    e.websocket.client:send(message)
end

WebsocketHandler.handlers["SESSION_STOP"] = function(self, e, data)
    print("Session ended")
end

WebsocketHandler.handlers["SET_AUTOMOBILE_ROUTE_STATE"] = function(self, e, data)
    print("Received 'SET_AUTOMOBILE_ROUTE_STATE'")
    print("RouteID: " .. data.data.routeId)
    print("State:   " .. data.data.state)

end

WebsocketHandler.handlers["ERROR_MALFORMED_MESSAGE"] = function(self, e, data)
    for _, err in ipairs(data.data.errors) do
        print(err)
    end
end

return WebsocketHandler