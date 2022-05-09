require("src.debugHandler")

local Camera = require("lib.camera")
local RoadGraph = require("src.roadGraph")

local Colors = require("src.colors")
love.graphics.setBackgroundColor(Colors.background)
love.graphics.setLineWidth(1)

ECS = require("lib.concord")
Imgui = require("imgui")
Vector = require("lib.vector")
JSON = require("lib.json")

local Systems = {}
Assemblages = {}
ECS.utils.loadNamespace("src/components")
ECS.utils.loadNamespace("src/systems", Systems)
ECS.utils.loadNamespace("src/assemblages", Assemblages)

local World = ECS.world()

World:setResource("grid", {
    size = 50,
    visible = true,
    map = {},
    connections = {}
})
World:setResource("editorSettings", {
    preview = nil,
    drawing = false,
    roadKind = "STRAIGHT",
    nodesVisible = true,
    directionsVisible = true,
})
World:setResource("camera", Camera(-3000, -200, 0.5))
World:setResource("roadGraph", RoadGraph)
World:setResource("settings", {
    spawningEnabled = false,
})

World:addSystems(
    Systems.roadGraphSync,

    Systems.gridRenderer,
    Systems.roadSelector,
    Systems.roadNodePlacer,

    Systems.websocketHandler,
    Systems.websocketErrorHandler,
    Systems.messageLogger,

    Systems.spawning,
    Systems.roadFollowing,
    Systems.syncRoadToTransform,
    Systems.sensorHandler,

    Systems.roadHandler,

    Systems.roadRenderer,
    Systems.shapeRenderer,

    Systems.roadSaver,
    Systems.roadLoader,

    Systems.roadSettingsGuiRenderer
)

local sessionName = "JustinEnNyk"
local websocketClient = nil

function love.load()
    World:emit("load")
end

function love.update(dt)
    Imgui.NewFrame(true)

    World:emit("update", dt)
end

function love.draw()
    local camera = World:getResource("camera")

    camera:attach()
    World:emit("draw")
    camera:detach()

    local grid = World:getResource("grid")
    local editorSettings = World:getResource("editorSettings")
    local settings = World:setResource("settings")

    if (Imgui.Begin("Debug")) then
        Imgui.Separator()
        Imgui.Text("FPS: " ..love.timer.getFPS())

        sessionName = Imgui.InputText("Session name", sessionName, 20)

        if (not websocketClient) then
            if (Imgui.Button("Connect")) then
                websocketClient = ECS.entity(World)
                :assemble(Assemblages.websocketClient, "keyslam.com", 8080, sessionName)
            end
        else
            if (Imgui.Button("Disconnect")) then
                websocketClient:destroy()
                websocketClient = nil
            end
        end

        Imgui.Separator()

        settings.spawningEnabled = Imgui.Checkbox("Spawning enabled", settings.spawningEnabled)
        grid.visible = Imgui.Checkbox("Grid visible", grid.visible)
        editorSettings.nodesVisible = Imgui.Checkbox("Nodes visible", editorSettings.nodesVisible)
        editorSettings.directionsVisible = Imgui.Checkbox("Directions visible", editorSettings.directionsVisible)
    end

    love.graphics.setColor(1, 1, 1, 1)
    Imgui.Render()
end

function love.quit()
    World:emit("save")
    World:emit("quit")

    Imgui.ShutDown()
end

function love.mousepressed(x, y, button)
    Imgui.MousePressed(button)

    if (not Imgui.GetWantCaptureMouse()) then
        local event = {
            x = x,
            y = y,
            button = button,
            consumed = false,
        }
        World:emit("mousepressed", event)
    end
end

function love.mousereleased(x, y, button)
    Imgui.MouseReleased(button)

    if (not Imgui.GetWantCaptureMouse()) then
        local event = {
            x = x,
            y = y,
            button = button,
            consumed = false,
        }

        World:emit("mousereleased", event)
    end
end

function love.mousemoved(x, y, dx, dy)
    Imgui.MouseMoved(x, y)

    if (not Imgui.GetWantCaptureMouse()) then
        World:emit("mousemoved", x, y, dx, dy)

        if (love.mouse.isDown(2) and love.keyboard.isDown("lctrl")) then
            local camera = World:getResource("camera")
            camera:move(-dx / camera.scale, -dy / camera.scale)
        end
    end
end

function love.wheelmoved(dx, dy)
    Imgui.WheelMoved(dy)

    if (not Imgui.GetWantCaptureMouse()) then
        World:emit("wheelmoved", dx, dy)

        if (love.keyboard.isDown("lctrl")) then
            local camera = World:getResource("camera")

            if (dy > 0) then
                camera:zoom(1.1)
            else
                camera:zoom(0.9)
            end
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