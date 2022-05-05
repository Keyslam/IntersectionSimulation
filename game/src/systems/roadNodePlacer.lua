local RoadNodePlacer = ECS.system()

function RoadNodePlacer:init()
    local editorSettings = self:getWorld():getResource("editorSettings")
    editorSettings.preview = ECS.entity(self:getWorld())
    :give("road")
    :give("curve", Vector(0, 0), Vector(0, 0), "STRAIGHT")
    :give("color", {1, 0, 0, 1})
    :give("preview", false)
end

function RoadNodePlacer:draw()
    local camera = self:getWorld():getResource("camera")
    local grid = self:getWorld():getResource("grid")

    local mouseX, mouseY = camera:worldCoords(love.mouse.getPosition())
    mouseX = math.ceil((mouseX - grid.size/2) / grid.size) * grid.size
    mouseY = math.ceil((mouseY - grid.size/2) / grid.size) * grid.size

    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.circle("fill", mouseX, mouseY, 5)
    love.graphics.circle("line", mouseX, mouseY, 8)
end

function RoadNodePlacer:mousepressed(x, y, button)
    local camera = self:getWorld():getResource("camera")
    local editorSettings = self:getWorld():getResource("editorSettings")
    local grid = self:getWorld():getResource("grid")

    if (button == 1) then
        local mouseX, mouseY = camera:worldCoords(love.mouse.getPosition())
        mouseX = math.ceil((mouseX - grid.size/2) / grid.size) * grid.size
        mouseY = math.ceil((mouseY - grid.size/2) / grid.size) * grid.size

        local position = Vector(mouseX, mouseY)

        editorSettings.preview.curve.from = position
        editorSettings.preview.curve.to = position
        editorSettings.preview.curve:updateBezier()

        editorSettings.drawing = true
        editorSettings.preview.preview.visible = true
    end
end

function RoadNodePlacer:mousereleased(x, y, button)
    local camera = self:getWorld():getResource("camera")
    local editorSettings = self:getWorld():getResource("editorSettings")
    local grid = self:getWorld():getResource("grid")

    if (button == 1) then
        local mouseX, mouseY = camera:worldCoords(love.mouse.getPosition())
        mouseX = math.ceil((mouseX - grid.size/2) / grid.size) * grid.size
        mouseY = math.ceil((mouseY - grid.size/2) / grid.size) * grid.size

        local startPosition = editorSettings.preview.curve.from
        local endPosition = editorSettings.preview.curve.to

        if (editorSettings.startPosition == endPosition) then

        else
            local road = ECS.entity(self:getWorld())
            :assemble(Assemblages.road, startPosition, endPosition, editorSettings.roadKind)
        end

        editorSettings.drawing = false
        editorSettings.preview.preview.visible = false
    end
end

function RoadNodePlacer:mousemoved(x, y, dx, dy)
    local camera = self:getWorld():getResource("camera")
    local editorSettings = self:getWorld():getResource("editorSettings")
    local grid = self:getWorld():getResource("grid")

    if (editorSettings.drawing) then
        local mouseX, mouseY = camera:worldCoords(love.mouse.getPosition())
        mouseX = math.ceil((mouseX - grid.size/2) / grid.size) * grid.size
        mouseY = math.ceil((mouseY - grid.size/2) / grid.size) * grid.size

        local position = Vector(mouseX, mouseY)

        editorSettings.preview.curve.to = position
        editorSettings.preview.curve:updateBezier()
    end
end

function RoadNodePlacer:keypressed(key)
    local editorSettings = self:getWorld():getResource("editorSettings")

    if (key == "k") then
        if (editorSettings.roadKind == "STRAIGHT") then
            editorSettings.roadKind = "TURN_LEFT"
        elseif (editorSettings.roadKind == "TURN_LEFT") then
            editorSettings.roadKind = "TURN_RIGHT"
        elseif (editorSettings.roadKind == "TURN_RIGHT") then
            editorSettings.roadKind = "S_HORIZONTAL"
        elseif (editorSettings.roadKind == "S_HORIZONTAL") then
            editorSettings.roadKind = "S_VERTICAL"
        elseif (editorSettings.roadKind == "S_VERTICAL") then
            editorSettings.roadKind = "STRAIGHT"
        end

        editorSettings.preview.curve.kind = editorSettings.roadKind
        editorSettings.preview.curve:updateBezier()
    end
end

function RoadNodePlacer:wheelmoved(dx, dy)
    local editorSettings = self:getWorld():getResource("editorSettings")

    if (dy > 0) then
        if (editorSettings.roadKind == "STRAIGHT") then
            editorSettings.roadKind = "TURN_LEFT"
        elseif (editorSettings.roadKind == "TURN_LEFT") then
            editorSettings.roadKind = "TURN_RIGHT"
        elseif (editorSettings.roadKind == "TURN_RIGHT") then
            editorSettings.roadKind = "S_HORIZONTAL"
        elseif (editorSettings.roadKind == "S_HORIZONTAL") then
            editorSettings.roadKind = "S_VERTICAL"
        elseif (editorSettings.roadKind == "S_VERTICAL") then
            editorSettings.roadKind = "STRAIGHT"
        end
    elseif (dy < 0) then
        if (editorSettings.roadKind == "STRAIGHT") then
            editorSettings.roadKind = "S_VERTICAL"
        elseif (editorSettings.roadKind == "TURN_LEFT") then
            editorSettings.roadKind = "STRAIGHT"
        elseif (editorSettings.roadKind == "TURN_RIGHT") then
            editorSettings.roadKind = "TURN_LEFT"
        elseif (editorSettings.roadKind == "S_HORIZONTAL") then
            editorSettings.roadKind = "TURN_RIGHT"
        elseif (editorSettings.roadKind == "S_VERTICAL") then
            editorSettings.roadKind = "S_HORIZONTAL"
        end
    end

    editorSettings.preview.curve.kind = editorSettings.roadKind
    editorSettings.preview.curve:updateBezier()
end

return RoadNodePlacer