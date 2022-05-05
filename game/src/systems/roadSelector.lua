local RoadSelector = ECS.system({
    roads = {"road"},
    hovered = {"road", "hovered"},
    selected = {"road", "selected"},
})

local function closestRoad(world, pool)
    local minDist, minE = math.huge, 0

    for _, e in ipairs(pool) do
        local camera = world:getResource("camera")
        local mx, my = camera:worldCoords(love.mouse.getPosition())
        local dist = e.curve:distanceTo(mx, my)

        if (dist < minDist) then
            minDist = dist
            minE = e
        end
    end

    return minE
end

function RoadSelector:update(dt)
    for _, e in ipairs(self.hovered) do
        e:remove("hovered")
    end

    closestRoad(self:getWorld(), self.roads)
    :give("hovered")
end

function RoadSelector:mousepressed(button, x, y)
    if (button == 1) then
        
    end
end

return RoadSelector