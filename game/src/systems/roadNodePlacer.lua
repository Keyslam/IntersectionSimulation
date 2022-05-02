local RoadNodePlacer = ECS.system()

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

        if (not editorSettings.selected) then
            if (grid.map[mouseX] and grid.map[mouseX][mouseY]) then
                local e = grid.map[mouseX][mouseY]

                editorSettings.selected = e
            else
                local e = ECS.entity(self:getWorld())
                :give("roadNode", {x = mouseX, y = mouseY})

                grid.map[mouseX] = grid.map[mouseX] or {}
                grid.map[mouseX][mouseY] = e
            end
        end
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

        if (editorSettings.selected) then
            if (grid.map[mouseX] and grid.map[mouseX][mouseY]) then
                local e = grid.map[mouseX][mouseY]

                if (e ~= editorSettings.selected) then
                    if (grid.connections[editorSettings.selected] and grid.connections[editorSettings.selected][e]) then
                        grid.connections[editorSettings.selected][e]:destroy()
                        grid.connections[editorSettings.selected][e] = nil
                        grid.connections[e][editorSettings.selected] = nil
                    else
                        local road = ECS.entity(self:getWorld())
                        :assemble(Assemblages.road, e.roadNode.position, editorSettings.selected.roadNode.position, editorSettings.roadKind)

                        grid.connections[editorSettings.selected] = grid.connections[editorSettings.selected] or {}
                        grid.connections[e] = grid.connections[e] or {}

                        grid.connections[editorSettings.selected][e] = road
                        grid.connections[e][editorSettings.selected] = road
                    end
                else
                    if (grid.connections[editorSettings.selected]) then
                        for k, _ in pairs(grid.connections[editorSettings.selected]) do
                            grid.connections[editorSettings.selected][k]:destroy()
                            grid.connections[editorSettings.selected][k] = nil
                            grid.connections[k][editorSettings.selected] = nil
                        end
                    end

                    grid.map[mouseX][mouseY] = nil
                    editorSettings.selected:destroy()
                end
            end

            editorSettings.selected = nil
        end
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
    end
end

return RoadNodePlacer