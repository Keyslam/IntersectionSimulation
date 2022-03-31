require("src.debugHandler")

local Colors = require("src.colors")
love.graphics.setBackgroundColor(Colors.background)
love.graphics.setLineWidth(1)

ECS = require("lib.concord")

local Systems = {}
local Assemblages = {}
ECS.utils.loadNamespace("src/components")
ECS.utils.loadNamespace("src/systems", Systems)
ECS.utils.loadNamespace("src/assemblages", Assemblages)

local World = ECS.world()

World:addSystems(
    Systems.websocketHandler,
    Systems.websocketErrorHandler,
    Systems.messageLogger,

    Systems.roadHandler,

    Systems.roadRenderer,
    Systems.shapeRenderer
)

ECS.entity(World)
:assemble(Assemblages.websocketClient, "keyslam.com", 8080, "JustinEnNyk3")

-- ECS.entity(World)
-- :assemble(Assemblages.car, {x = 10, y = 10}, 0)

-- ECS.entity(World)
-- :assemble(Assemblages.pedestrian, {x = 10, y = 20}, 0)

-- ECS.entity(World)
-- :assemble(Assemblages.bicycle, {x = 10, y = 30}, 0)

ECS.entity(World)
:assemble(Assemblages.road, {x = 50, y = 50}, {x = 100, y = 75}, "S_HORIZONTAL")


function love.update(dt)
    World:emit("update", dt)
end

function love.draw()
    love.graphics.scale(4, 4)
    World:emit("draw")
end

function love.quit()
    World:emit("quit")
end