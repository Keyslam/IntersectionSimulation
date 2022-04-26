local RoadNodePlacer = ECS.system()

function RoadNodePlacer:init()
    self.selected = nil
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
    local grid = self:getWorld():getResource("grid")

    if (button == 1) then
        local mouseX, mouseY = camera:worldCoords(love.mouse.getPosition())
        mouseX = math.ceil((mouseX - grid.size/2) / grid.size) * grid.size
        mouseY = math.ceil((mouseY - grid.size/2) / grid.size) * grid.size

        if (not self.selected) then
            if (grid.map[mouseX] and grid.map[mouseX][mouseY]) then
                local e = grid.map[mouseX][mouseY]
                print("selected", e)

                self.selected = e
            else
                local e = ECS.entity(self:getWorld())
                :give("roadNode", {x = mouseX, y = mouseY})

                grid.map[mouseX] = grid.map[mouseX] or {}
                grid.map[mouseX][mouseY] = e

                self.selected = e
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
                    local e = ECS.entity(self:getWorld())
                    :assemble(Assemblages.road, e.roadNode.position, self.selected.roadNode.position, "TURN_RIGHT")
                    
                end
            end

            self.selected = nil
        end
    end
end

return RoadNodePlacer