require("src.debugHandler")

ECS = require("lib.concord")

local Systems = {}
ECS.utils.loadNamespace("src/components")
ECS.utils.loadNamespace("src/systems", Systems)

local World = ECS.world()

World:addSystems(
    Systems.websocketHandler
)

ECS.entity(World)
:give("websocket", "keyslam.com", 8080)

function love.update(dt)
    World:emit("update", dt)
end

function love.draw()
    World:emit("draw")
end