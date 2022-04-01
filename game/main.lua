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

:node("1-start", 600, 190)
:node("1-end", 500, 190)
:node("1-post", 450, 190)

:node("2a-start", 600, 200)
:node("2a-end", 500, 200)

:node("2b-start", 600, 210)
:node("2b-end", 500, 210)

:node("3-start", 600, 220)
:node("3-end", 500, 220)
:node("3-post", 450, 220)


:node("4a-start", 350, 400)
:node("4a-end", 350, 350)
:node("4a-post", 350, 300)

:node("4b-start", 360, 400)
:node("4b-end", 360, 350)
:node("4b-post", 360, 300)

:node("5-start", 340, 400)
:node("5-end", 340, 350)
:node("5-post", 340, 300)

:node("7-start", 0, 280)
:node("7-end", 100, 280)
:node("7-post", 180, 280)

:node("8a-start", 0, 260)
:node("8a-end", 100, 260)

:node("8b-start", 0, 270)
:node("8b-end", 100, 270)

:node("9-start", 0, 250)
:node("9-end", 100, 250)
:node("9-post", 150, 250)

:node("10-start", 200,   0)
:node("10-end",   200, 100)
:node("10-post",  200, 150)

:node("11-start", 210, 0)
:node("11-end", 210, 100)

:node("12-start", 220, 0)
:node("12-end", 220, 100)
:node("12-post", 220, 150)

:node("2-10-start", 150, 200)
:node("2-10-end",     0, 200)

:node("1-5-9-start", 350, 100)
:node("1-5-9-end", 350, 0)

:node("3-7-11-start", 210, 300)
:node("3-7-11-end", 210, 400)

:node("4a-8a-12-start", 450, 260)
:node("4a-8a-12-end", 550, 260)

:node("4b-8b-start", 450, 270)
:node("4b-8b-end", 550, 270)

:node("2b-5-start", 150, 210)
:node("2b-5-end", 0, 210)


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

function love.update(dt)
    World:emit("update", dt)
end

function love.draw()
    love.graphics.scale(3, 3)
    World:emit("draw")
end

function love.quit()
    World:emit("quit")
end