local RoadSelector = ECS.system({
    roads = {"road", "curve", "selectable"},
    hovered = {"road", "hovered"},
    selected = {"road", "selected"},
})

local function closestRoad(world, pool)
    local minDist, minE = math.huge, 0

    for _, e in ipairs(pool) do
        local camera = world:getResource("camera")
        local grid = world:getResource("grid")
        local mx, my = camera:worldCoords(love.mouse.getPosition())
        local dist = e.curve:distanceTo(mx, my)

        local mouseX, mouseY = camera:worldCoords(love.mouse.getPosition())
        mouseX = math.ceil((mouseX - grid.size/2) / grid.size) * grid.size
        mouseY = math.ceil((mouseY - grid.size/2) / grid.size) * grid.size

        local position = Vector(mouseX, mouseY)

        if (position == e.curve.from or position == e.curve.to) then
            goto skip
        end

        if (dist < minDist) then
            minDist = dist
            minE = e
        end

        ::skip::
    end

    return minE, minDist
end

function RoadSelector:update(dt)
    for _, e in ipairs(self.hovered) do
        e:remove("hovered")
    end

    local road, minDist = closestRoad(self:getWorld(), self.roads)

    if (minDist < 20) then
        road:give("hovered")
    end
end

function RoadSelector:mousepressed(event)
    if (event.consumed) then
        return
    end

    if (event.button == 1) then
        if (#self.selected > 0) then
            for _, e in ipairs(self.selected) do
                e:remove("selected")
            end

            event.consumed = true
        end

        if (#self.hovered > 0) then
            for _, e in ipairs(self.hovered) do
                e:give("selected")
            end

            event.consumed = true
        end
    end
end

return RoadSelector