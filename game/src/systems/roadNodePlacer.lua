local RoadNodePlacer = ECS.system()

function RoadNodePlacer:init()
    self.selected = nil
    self.roadKind = "STRAIGHT"
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

function RoadNodePlacer:drawHud()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print("Road kind: " ..self.roadKind, 5, 30)
end

function RoadNodePlacer:mousepressed(x, y, button)
    local camera = self:getWorld():getResource("camera")
    local grid = self:getWorld():getResource("grid")

    if (button == 1) then
        local mouseX, mouseY = camera:worldCoords(love.mouse.getPosition())
        mouseX = math.ceil((mouseX - grid.size/2) / grid.size) * grid.size
        mouseY = math.ceil((mouseY - grid.size/2) / grid.size) * grid.size

        if (not self.selected) then
            if (grid.map[mouseX] and grid.map[mouseX][mouseY]) then
                local e = grid.map[mouseX][mouseY]

                self.selected = e
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
    local grid = self:getWorld():getResource("grid")

    if (button == 1) then
        local mouseX, mouseY = camera:worldCoords(love.mouse.getPosition())
        mouseX = math.ceil((mouseX - grid.size/2) / grid.size) * grid.size
        mouseY = math.ceil((mouseY - grid.size/2) / grid.size) * grid.size

        if (self.selected) then
            if (grid.map[mouseX] and grid.map[mouseX][mouseY]) then
                local e = grid.map[mouseX][mouseY]

                if (e ~= self.selected) then
                    if (grid.connections[self.selected] and grid.connections[self.selected][e]) then
                        grid.connections[self.selected][e]:destroy()
                        grid.connections[self.selected][e] = nil
                        grid.connections[e][self.selected] = nil
                    else
                        local road = ECS.entity(self:getWorld())
                        :assemble(Assemblages.road, e.roadNode.position, self.selected.roadNode.position, self.roadKind)

                        grid.connections[self.selected] = grid.connections[self.selected] or {}
                        grid.connections[e] = grid.connections[e] or {}

                        grid.connections[self.selected][e] = road
                        grid.connections[e][self.selected] = road
                    end
                else
                    if (grid.connections[self.selected]) then
                        for k, _ in pairs(grid.connections[self.selected]) do
                            grid.connections[self.selected][k]:destroy()
                            grid.connections[self.selected][k] = nil
                            grid.connections[k][self.selected] = nil
                        end
                    end

                    grid.map[mouseX][mouseY] = nil
                    self.selected:destroy()
                end
            end

            self.selected = nil
        end
    end
end

function RoadNodePlacer:keypressed(key)
    if (key == "k") then
        if (self.roadKind == "STRAIGHT") then
            self.roadKind = "TURN_LEFT"
        elseif (self.roadKind == "TURN_LEFT") then
            self.roadKind = "TURN_RIGHT"
        elseif (self.roadKind == "TURN_RIGHT") then
            self.roadKind = "S_HORIZONTAL"
        elseif (self.roadKind == "S_HORIZONTAL") then
            self.roadKind = "S_VERTICAL"
        elseif (self.roadKind == "S_VERTICAL") then
            self.roadKind = "STRAIGHT"
        end
    end
end

return RoadNodePlacer