local Json = require("lib.json")

local WebsocketErrorHandler = ECS.system({
    pool = {}
})

function WebsocketErrorHandler.MESSAGE_ERROR_NOT_PARSEABLE(self, e, data)
    print("Error - Not parseable: '"..data.receivedMessage.."'")
end

function WebsocketErrorHandler.MESSAGE_ERROR_UNKNOWN_EVENT_TYPE(self, e, data)
    local receivedMessage = Json.decode(data.receivedMessage)

    print("Error - Unknown event type: '"..receivedMessage.eventType.."'")
end

function WebsocketErrorHandler.MESSAGE_ERROR_MALFORMED_MESSAGE(self, e, data)
    print("Error - Malformed message:")
    for _, err in ipairs(data.errors) do
        print("\t"..err)
    end
end

function WebsocketErrorHandler.MESSAGE_ERROR_INVALID_STATE(self, e, data)
    print("Error - Invalid state: '"..data.errors.."'")
end

return WebsocketErrorHandler