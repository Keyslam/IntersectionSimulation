local Websocket = require("lib.websocket")
local Json = require("lib.json")

local WebsocketHandler = ECS.system({
    pool = {"websocket"}
})

function WebsocketHandler:init()
    local clients = {}

    self.pool.onAdded = function(_, e)
        print("Connecting")
        e.websocket.client = Websocket.new(e.websocket.host, e.websocket.port)
        clients[e] = e.websocket.client

        function e.websocket.client.onopen()
            self:onOpen(e)
        end

        function e.websocket.client.onmessage(_, message)
            self:onMessage(e, message)
        end
    end

    self.pool.onRemoved = function(_, e)
        print("Disconnecting")
        clients[e]:close()
        clients[e] = nil
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
            sessionName = e.websocket.sessionName,
            sessionVersion = e.websocket.sessionVersion,

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

    e.websocket.running = true
end

function WebsocketHandler.MESSAGE_SESSION_STOP(self, e, data)
    e.websocket.running = false

    self:getWorld():emit("reset")
end

function WebsocketHandler:ENTITY_ENTERED_ZONE(routeId, sensorId)
    local message = Json.encode({
        eventType = "ENTITY_ENTERED_ZONE",

        data = {
            routeId = routeId,
            sensorId = sensorId,
        }
    })

    for _, e in ipairs(self.pool) do
        self:getWorld():emit("messageSent", e, message)
        e.websocket.client:send(message)
    end
end

function WebsocketHandler:ENTITY_EXITED_ZONE(routeId, sensorId)
    local message = Json.encode({
        eventType = "ENTITY_EXITED_ZONE",

        data = {
            routeId = routeId,
            sensorId = sensorId,
        }
    })

    for _, e in ipairs(self.pool) do
        self:getWorld():emit("messageSent", e, message)
        e.websocket.client:send(message)
    end
end


return WebsocketHandler