local RoadNodePlacer = ECS.system({
    pool = {"road", "curve", "selectable"}
})

function RoadNodePlacer:init()
    local editorSettings = self:getWorld():getResource("editorSettings")
    editorSettings.preview = ECS.entity(self:getWorld())
    :give("road")
    :give("curve", Vector(0, 0), Vector(0, 0), "STRAIGHT")
    :give("color", {205 / 255, 73 / 255, 73 / 255})
    :give("preview", false)
end

function RoadNodePlacer:draw()
    local camera = self:getWorld():getResource("camera")
    local grid = self:getWorld():getResource("grid")

    local mouseX, mouseY = camera:worldCoords(love.mouse.getPosition())
    mouseX = math.ceil((mouseX - grid.size/2) / grid.size) * grid.size
    mouseY = math.ceil((mouseY - grid.size/2) / grid.size) * grid.size

    love.graphics.setColor(205 / 255, 73 / 255, 73 / 255)
    love.graphics.circle("fill", mouseX, mouseY, 5)
    love.graphics.circle("line", mouseX, mouseY, 8)
end

function RoadNodePlacer:mousepressed(event)
    if (event.consumed) then
        return
    end

    local camera = self:getWorld():getResource("camera")
    local editorSettings = self:getWorld():getResource("editorSettings")
    local grid = self:getWorld():getResource("grid")

    local mouseX, mouseY = camera:worldCoords(love.mouse.getPosition())
    mouseX = math.ceil((mouseX - grid.size/2) / grid.size) * grid.size
    mouseY = math.ceil((mouseY - grid.size/2) / grid.size) * grid.size

    local position = Vector(mouseX, mouseY)

    if (event.button == 1) then
        editorSettings.preview.curve.from = position
        editorSettings.preview.curve.to = position
        editorSettings.preview.curve:updateBezier()

        editorSettings.drawing = true
        editorSettings.preview.preview.visible = true

        event.consumed = true
    end

    if (event.button == 2) then
        editorSettings.movingTos = {}
        editorSettings.movingFroms = {}

        for _, e in ipairs(self.pool) do
            if (e.curve.to == position) then
                table.insert(editorSettings.movingTos, e)
            end

            if (e.curve.from == position) then
                table.insert(editorSettings.movingFroms, e)
            end
        end

        editorSettings.moving = true

        event.consumed = true
    end
end

function RoadNodePlacer:mousereleased(event)
    if (event.consumed) then
        return
    end

    local editorSettings = self:getWorld():getResource("editorSettings")

    local camera = self:getWorld():getResource("camera")
    local grid = self:getWorld():getResource("grid")

    local mouseX, mouseY = camera:worldCoords(love.mouse.getPosition())
    mouseX = math.ceil((mouseX - grid.size/2) / grid.size) * grid.size
    mouseY = math.ceil((mouseY - grid.size/2) / grid.size) * grid.size

    local position = Vector(mouseX, mouseY)

    if (editorSettings.drawing and event.button == 1) then
        local startPosition = editorSettings.preview.curve.from
        local endPosition = editorSettings.preview.curve.to

        if (startPosition == endPosition) then

        else
            local road = ECS.entity(self:getWorld())
            :assemble(Assemblages.road, startPosition, endPosition, editorSettings.roadKind)
        end

        editorSettings.drawing = false
        editorSettings.preview.preview.visible = false

        event.consumed = true
    end

    if (editorSettings.moving and event.button == 2) then
        for _, e in ipairs(editorSettings.movingTos) do
            e.curve.to = position
            e.curve:updateBezier()
        end

        for _, e in ipairs(editorSettings.movingFroms) do
            e.curve.from = position
            e.curve:updateBezier()
        end

        editorSettings.moving = false

        event.consumed = false
    end
end

function RoadNodePlacer:mousemoved(x, y, dx, dy)
    local camera = self:getWorld():getResource("camera")
    local editorSettings = self:getWorld():getResource("editorSettings")
    local grid = self:getWorld():getResource("grid")

    local mouseX, mouseY = camera:worldCoords(love.mouse.getPosition())
    mouseX = math.ceil((mouseX - grid.size/2) / grid.size) * grid.size
    mouseY = math.ceil((mouseY - grid.size/2) / grid.size) * grid.size

    local position = Vector(mouseX, mouseY)

    if (editorSettings.drawing) then
        editorSettings.preview.curve.to = position
        editorSettings.preview.curve:updateBezier()
    end

    if (editorSettings.moving) then
        for _, e in ipairs(editorSettings.movingTos) do
            e.curve.to = position
            e.curve:updateBezier()
        end

        for _, e in ipairs(editorSettings.movingFroms) do
            e.curve.from = position
            e.curve:updateBezier()
        end

        editorSettings.moving = true
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