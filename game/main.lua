require("src.debugHandler")

local HC = require("lib.hc")
local Camera = require("lib.camera")

local Colors = require("src.colors")
love.graphics.setBackgroundColor(Colors.background)
love.graphics.setLineWidth(1)

ECS = require("lib.concord")
Imgui = require("imgui")

local Systems = {}
Assemblages = {}
ECS.utils.loadNamespace("src/components")
ECS.utils.loadNamespace("src/systems", Systems)
ECS.utils.loadNamespace("src/assemblages", Assemblages)

local World = ECS.world()

World:addSystems(
    Systems.gridRenderer,
    Systems.roadNodeRenderer,
    Systems.roadNodePlacer,

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
    Systems.shapeRenderer,

    Systems.editorGuiRenderer
)

World:setResource("hc", HC.new(100))
World:setResource("grid", {
    size = 50,
    map = {},
    connections = {}
})
World:setResource("editorSettings", {
    selected = nil,
    roadKind = "STRAIGHT",
})
World:setResource("camera", Camera(0, 0, 1))

ECS.entity(World)
:assemble(Assemblages.websocketClient, "keyslam.com", 8080, "test")

function love.update(dt)
    Imgui.NewFrame(true)

    World:emit("update", dt)
end

function love.draw()
    local camera = World:getResource("camera")

    camera:attach()
    World:emit("draw")
    camera:detach()

    World:emit("drawHud")

    love.graphics.setColor(1, 1, 1, 1)
    Imgui.Render()
end

function love.quit()
    Imgui.ShutDown()
    World:emit("quit")
end

function love.mousepressed(x, y, button)
    Imgui.MousePressed(button)

    if (not Imgui.GetWantCaptureMouse()) then
        World:emit("mousepressed", x, y, button)
    end
end

function love.mousereleased(x, y, button)
    Imgui.MouseReleased(button)

    if (not Imgui.GetWantCaptureMouse()) then
        World:emit("mousereleased", x, y, button)
    end
end

function love.mousemoved(x, y, dx, dy)
    Imgui.MouseMoved(x, y)

    if (not Imgui.GetWantCaptureMouse()) then
        if (love.mouse.isDown(2)) then
            local camera = World:getResource("camera")
            camera:move(-dx / camera.scale, -dy / camera.scale)
        end
    end
end

function love.wheelmoved(dx, dy)
    Imgui.WheelMoved(dy)

    if (not Imgui.GetWantCaptureMouse()) then
        local camera = World:getResource("camera")

        if (dy > 0) then
            camera:zoom(1.1)
        else
            camera:zoom(0.9)
        end
    end
end

function love.textinput(t)
    Imgui.TextInput(t)
    if (not Imgui.GetWantCaptureKeyboard()) then
        World:emit("textinput", t)
    end
end

function love.keypressed(key)
    Imgui.KeyPressed(key)
    if (not Imgui.GetWantCaptureKeyboard()) then
        World:emit("keypressed", key)
    end
end

function love.keyreleased(key)
    Imgui.KeyReleased(key)
    if (not Imgui.GetWantCaptureKeyboard()) then
        World:emit("keyreleased", key)
    end
end