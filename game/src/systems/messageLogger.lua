local Json = require("lib.json")

local MessageLogger = ECS.system({
    pool = {}
})

function MessageLogger:init()
    self.log = {}
end

function MessageLogger:__log(message)
    table.insert(self.log, message)
end

function MessageLogger:messageSent(e, message)
    self:__log("SENT: " ..message)
end

function MessageLogger:messageReceived(e, message)
    self:__log("RECEIVED: " ..message)
end

function MessageLogger:quit()
    local str = ""

    for _, message in ipairs(self.log) do
        str = str .. message .. "\n"
    end

    love.filesystem.write("log.txt", str)
end

return MessageLogger