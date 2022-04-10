require("src.debugHandler")

local HC = require("lib.hc")

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

    Systems.roadFollowing,
    Systems.syncRoadToTransform,
    Systems.spawning,
    Systems.sensorHandler,

    Systems.syncTransformToCollider,

    Systems.roadHandler,

    Systems.roadRenderer,
    Systems.shapeRenderer
)

World:setResource("hc", HC.new(100))

ECS.entity(World)
:assemble(Assemblages.websocketClient, "keyslam.com", 8080, "pannekoek")

RoadBuilder()

:node("1-start", 550, 240, "1")
:node("1-end", 450, 240)
:node("1-post", 400, 240)

:node("2a-start", 550, 250, "2a")
:node("2a-end", 450, 250)

:node("2b-start", 550, 260, "2b")
:node("2b-end", 450, 260)

:node("3-start", 550, 270, "3")
:node("3-end", 450, 270)
:node("3-post", 400, 270)


:node("4a-start", 300, 500, "4a")
:node("4a-end", 300, 400)
:node("4a-post", 300, 350)

:node("4b-start", 310, 500, "4b")
:node("4b-end", 310, 400)
:node("4b-post", 310, 350)

:node("5-start", 290, 500, "5")
:node("5-end", 290, 400)
:node("5-post", 290, 350)

:node("7-start", 0, 330, "7")
:node("7-end", 100, 330)
:node("7-post", 180, 330)

:node("8a-start", 0, 310, "8a")
:node("8a-end", 100, 310)

:node("8b-start", 0, 320, "8b")
:node("8b-end", 100, 320)

:node("9-start", 0, 300, "9")
:node("9-end", 100, 300)
:node("9-post", 150, 300)

:node("10-start", 200,   0, "10")
:node("10-end",   200, 100)
:node("10-post",  200, 150)

:node("11-start", 210, 0, "11")
:node("11-end", 210, 100)

:node("12-start", 220, 0, "12")
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


:edge("1-start", "1-end", "STRAIGHT", nil, {1, 1})
:edge("1-end", "1-post", "STRAIGHT", 1)
:edge("1-post", "1-5-9-start", "TURN_RIGHT", 1)

:edge("2a-start", "2a-end", "STRAIGHT", nil, {2, 1})
:edge("2a-end", "2-10-start", "STRAIGHT", 2)

:edge("2b-start", "2b-end", "STRAIGHT", nil, {2, 2})
:edge("2b-end", "2b-5-start", "STRAIGHT", 2)

:edge("3-start", "3-end", "STRAIGHT", nil, {3, 1})
:edge("3-end", "3-post", "STRAIGHT", 3)
:edge("3-post", "3-7-11-start", "TURN_RIGHT", 3)

:edge("4a-start", "4a-end", "STRAIGHT", nil, {4, 1})
:edge("4a-end", "4a-post", "STRAIGHT", 4)
:edge("4a-post", "4a-8a-12-start", "TURN_LEFT", 4)

:edge("4b-start", "4b-end", "STRAIGHT", nil, {4, 2})
:edge("4b-end", "4b-post", "STRAIGHT", 4)
:edge("4b-post", "4b-8b-start", "TURN_LEFT", 4)

:edge("5-start", "5-end", "STRAIGHT", nil, {5, 1})
:edge("5-end", "5-post", "STRAIGHT", 5)
:edge("5-post", "1-5-9-start", "S_VERTICAL", 5)
:edge("5-post", "2b-5-start", "TURN_LEFT", 5)


:edge("7-start", "7-end", "STRAIGHT", nil, {7, 1})
:edge("7-end", "7-post", "STRAIGHT", 7)
:edge("7-post", "3-7-11-start", "TURN_RIGHT", 7)

:edge("8a-start", "8a-end", "STRAIGHT", nil, {8, 1})
:edge("8a-end", "4a-8a-12-start", "STRAIGHT", 8)

:edge("8b-start", "8b-end", "STRAIGHT", nil, {8, 2})
:edge("8b-end", "4b-8b-start", "STRAIGHT", 8)

:edge("9-start", "9-end", "STRAIGHT", nil, {9, 1})
:edge("9-end", "9-post", "STRAIGHT", 9)
:edge("9-post", "1-5-9-start", "TURN_RIGHT", 9)


:edge("10-start", "10-end", "STRAIGHT", nil, {10, 2})
:edge("10-end", "10-post", "STRAIGHT", 10)
:edge("10-post", "2-10-start", "TURN_LEFT", 10)

:edge("11-start", "11-end", "STRAIGHT", nil, {11, 1})
:edge("11-end", "3-7-11-start", "STRAIGHT", 11)

:edge("12-start", "12-end", "STRAIGHT", nil, {12, 1})
:edge("12-end", "12-post", "STRAIGHT", 12)
:edge("12-post", "4a-8a-12-start", "TURN_LEFT", 12)

:edge("2-10-start", "2-10-end", "STRAIGHT")
:edge("3-7-11-start", "3-7-11-end", "STRAIGHT")
:edge("4a-8a-12-start", "4a-8a-12-end", "STRAIGHT")
:edge("4b-8b-start", "4b-8b-end", "STRAIGHT")
:edge("1-5-9-start", "1-5-9-end", "STRAIGHT")
:edge("2b-5-start", "2b-5-end", "STRAIGHT")

:build(World)

local autospawning = false
local spawnTimer = 0.3

function love.update(dt)
    if (autospawning) then
        spawnTimer = spawnTimer - dt
        if (spawnTimer <= 0) then
            spawnTimer = 0.3
            World:emit("spawn")
        end
    end

    World:emit("update", dt)

end

function love.draw()
    love.graphics.scale(1.5, 1.5)
    World:emit("draw")

    love.graphics.print(love.timer.getFPS())

    -- local hc = World:getResource("hc")
    -- love.graphics.setColor(1, 1, 1, 0.1)
    -- hc._hash:draw("line", false, true)

    -- for _, shape in pairs(hc._hash:shapes()) do
    --     love.graphics.setColor(1, 0, 0, 1)
    --     shape:draw("line")
    -- end
end

function love.quit()
    World:emit("quit")
end


function love.keypressed(key)
    if (key == "a") then
        autospawning = not autospawning
        return
    end

    if (key == "s") then
        World:emit("spawn_pre")
    end
end

local TICK_RATE = 1 / 300
local MAX_FRAME_SKIP = 25

function love.run()
    if love.load then love.load(love.arg.parseGameArguments(arg), arg) end
 
    -- We don't want the first frame's dt to include time taken by love.load.
    if love.timer then love.timer.step() end

    local lag = 0.0

    -- Main loop time.
    return function()
        -- Process events.
        if love.event then
            love.event.pump()
            for name, a,b,c,d,e,f in love.event.poll() do
                if name == "quit" then
                    if not love.quit or not love.quit() then
                        return a or 0
                    end
                end
                love.handlers[name](a,b,c,d,e,f)
            end
        end

        -- Cap number of Frames that can be skipped so lag doesn't accumulate
        if love.timer then lag = math.min(lag + love.timer.step(), TICK_RATE * MAX_FRAME_SKIP) end

        while lag >= TICK_RATE do
            if love.update then love.update(TICK_RATE) end
            lag = lag - TICK_RATE
        end

        if love.graphics and love.graphics.isActive() then
            love.graphics.origin()
            love.graphics.clear(love.graphics.getBackgroundColor())
 
            if love.draw then love.draw() end
            love.graphics.present()
        end

        -- Even though we limit tick rate and not frame rate, we might want to cap framerate at 1000 frame rate as mentioned https://love2d.org/forums/viewtopic.php?f=4&t=76998&p=198629&hilit=love.timer.sleep#p160881
        if love.timer then love.timer.sleep(0.001) end
    end
end