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
:assemble(Assemblages.websocketClient, "keyslam.com", 8080, "JustinEnNyk")

local road1 = ECS.entity(World)
local road2a = ECS.entity(World)
local road2b = ECS.entity(World)
local road3 = ECS.entity(World)
local road15 = ECS.entity(World)
local road4a = ECS.entity(World)
local road4b = ECS.entity(World)
local road5 = ECS.entity(World)
local road7 = ECS.entity(World)
local road8a = ECS.entity(World)
local road8b = ECS.entity(World)
local road9 = ECS.entity(World)
local road10 = ECS.entity(World)
local road11 = ECS.entity(World)
local road12 = ECS.entity(World)

road1:assemble(Assemblages.road, {x = 500, y = 200}, {x = 400, y = 200}, "STRAIGHT")

road9:assemble(Assemblages.road, {x = 0, y = 200}, {x = 100, y = 200}, "STRAIGHT")
road8a:assemble(Assemblages.road, {x = 0, y = 210}, {x = 100, y = 210}, "STRAIGHT")
road8b:assemble(Assemblages.road, {x = 0, y = 220}, {x = 100, y = 220}, "STRAIGHT")
road7:assemble(Assemblages.road, {x = 0, y = 230}, {x = 100, y = 230}, "STRAIGHT")

road10:assemble(Assemblages.road, {x = 200, y = 0}, {x = 200, y = 100}, "STRAIGHT")
road11:assemble(Assemblages.road, {x = 210, y = 0}, {x = 210, y = 100}, "STRAIGHT")
road12:assemble(Assemblages.road, {x = 220, y = 0}, {x = 220, y = 100}, "STRAIGHT")

ECS.entity(World)
:assemble(Assemblages.car, {x = 200, y = 80}, math.pi/2)

function love.update(dt)
    World:emit("update", dt)
end

function love.draw()
    love.graphics.scale(2, 2)
    World:emit("draw")
end

function love.quit()
    World:emit("quit")
end