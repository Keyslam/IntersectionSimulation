local Json = require("lib.json")

local MessageLogger = ECS.system({
    pool = {}
})

function MessageLogger:init()
    -- TODO: Move to component
    self.file = love.filesystem.newFile("log.txt")
    self.file:open("w")
end

function MessageLogger:__log(message)
    self.file:write(message)
end

function MessageLogger:messageSent(e, message)
    self:__log("SENT: " ..message.."\n")
end

function MessageLogger:messageReceived(e, message)
    self:__log("RECEIVED: " ..message.."\n")
end

function MessageLogger:quit()
    self.file:close()
end

return MessageLogger