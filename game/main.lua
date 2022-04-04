require("src.debugHandler")

local RoadBuilder = require("src.roadBuilder")
local Colors = require("src.colors")
love.graphics.setBackgroundColor(Colors.background)
love.graphics.setLineWidth(1)

ECS = require("lib.concord")

local Systems = {}
Assemblages = {}
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

RoadBuilder()

:node("1-start", 550, 240)
:node("1-end", 450, 240)
:node("1-post", 400, 240)

:node("2a-start", 550, 250)
:node("2a-end", 450, 250)

:node("2b-start", 550, 260)
:node("2b-end", 450, 260)

:node("3-start", 550, 270)
:node("3-end", 450, 270)
:node("3-post", 400, 270)


:node("4a-start", 300, 450)
:node("4a-end", 300, 400)
:node("4a-post", 300, 350)

:node("4b-start", 310, 450)
:node("4b-end", 310, 400)
:node("4b-post", 310, 350)

:node("5-start", 290, 450)
:node("5-end", 290, 400)
:node("5-post", 290, 350)

:node("7-start", 0, 330)
:node("7-end", 100, 330)
:node("7-post", 180, 330)

:node("8a-start", 0, 310)
:node("8a-end", 100, 310)

:node("8b-start", 0, 320)
:node("8b-end", 100, 320)

:node("9-start", 0, 300)
:node("9-end", 100, 300)
:node("9-post", 150, 300)

:node("10-start", 200,   0)
:node("10-end",   200, 100)
:node("10-post",  200, 150)

:node("11-start", 210, 0)
:node("11-end", 210, 100)

:node("12-start", 220, 0)
:node("12-end", 220, 100)
:node("12-post", 220, 150)

:node("2-10-start", 150, 250)
:node("2-10-end",     0, 250)

:node("1-5-9-start", 300, 150)
:node("1-5-9-end", 300, 0)

:node("3-7-11-start", 210, 350)
:node("3-7-11-end", 210, 450)

:node("4a-8a-12-start", 400, 310)
:node("4a-8a-12-end", 550, 310)

:node("4b-8b-start", 400, 320)
:node("4b-8b-end", 550, 320)

:node("2b-5-start", 150, 260)
:node("2b-5-end", 0, 260)


:edge("1-start", "1-end", "STRAIGHT")
:edge("1-end", "1-post", "STRAIGHT", 1)
:edge("1-post", "1-5-9-start", "TURN_RIGHT", 1)

:edge("2a-start", "2a-end", "STRAIGHT")
:edge("2a-end", "2-10-start", "STRAIGHT", 2)

:edge("2b-start", "2b-end", "STRAIGHT")
:edge("2b-end", "2b-5-start", "STRAIGHT", 2)

:edge("3-start", "3-end", "STRAIGHT")
:edge("3-end", "3-post", "STRAIGHT", 3)
:edge("3-post", "3-7-11-start", "TURN_RIGHT", 3)

:edge("4a-start", "4a-end", "STRAIGHT")
:edge("4a-end", "4a-post", "STRAIGHT", 4)
:edge("4a-post", "4a-8a-12-start", "TURN_LEFT", 4)

:edge("4b-start", "4b-end", "STRAIGHT")
:edge("4b-end", "4b-post", "STRAIGHT")
:edge("4b-post", "4b-8b-start", "TURN_LEFT", 4)

:edge("5-start", "5-end", "STRAIGHT")
:edge("5-end", "5-post", "STRAIGHT", 5)
:edge("5-post", "1-5-9-start", "S_VERTICAL", 5)
:edge("5-post", "2b-5-start", "TURN_LEFT", 5)


:edge("7-start", "7-end", "STRAIGHT")
:edge("7-end", "7-post", "STRAIGHT", 7)
:edge("7-post", "3-7-11-start", "TURN_RIGHT", 7)

:edge("8a-start", "8a-end", "STRAIGHT")
:edge("8a-end", "4a-8a-12-start", "STRAIGHT", 8)

:edge("8b-start", "8b-end", "STRAIGHT")
:edge("8b-end", "4b-8b-start", "STRAIGHT", 8)

:edge("9-start", "9-end", "STRAIGHT")
:edge("9-end", "9-post", "STRAIGHT", 9)
:edge("9-post", "1-5-9-start", "TURN_RIGHT", 9)


:edge("10-start", "10-end", "STRAIGHT")
:edge("10-end", "10-post", "STRAIGHT", 10)
:edge("10-post", "2-10-start", "TURN_LEFT", 10)

:edge("11-start", "11-end", "STRAIGHT")
:edge("11-end", "3-7-11-start", "STRAIGHT", 11)

:edge("12-start", "12-end", "STRAIGHT")
:edge("12-end", "12-post", "STRAIGHT", 12)
:edge("12-post", "4a-8a-12-start", "TURN_LEFT", 12)

:edge("2-10-start", "2-10-end", "STRAIGHT")
:edge("3-7-11-start", "3-7-11-end", "STRAIGHT")
:edge("4a-8a-12-start", "4a-8a-12-end", "STRAIGHT")
:edge("4b-8b-start", "4b-8b-end", "STRAIGHT")
:edge("1-5-9-start", "1-5-9-end", "STRAIGHT")
:edge("2b-5-start", "2b-5-end", "STRAIGHT")

:build(World)

ECS.entity(World)
:assemble(Assemblages.car, {x = 210, y = 80}, math.pi/2)

function love.update(dt)
    World:emit("update", dt)
end

function love.draw()
    love.graphics.scale(1, 1)
    World:emit("draw")
end

function love.quit()
    World:emit("quit")
end