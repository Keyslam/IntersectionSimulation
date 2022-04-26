local Spawning = ECS.system({
    pool = {"spawner"},
    websockets = {"websocket"}
})

function Spawning:spawn()
    if (not self.websockets[1].websocket.running) then
        return
    end

    for _, e in ipairs(self.pool) do
        if (love.math.random() > 0.96) then
            ECS.entity(self:getWorld())
            :assemble(Assemblages.car, e.spawner.road)
        end
    end
end

function Spawning:spawn_pre()
    if (not self.websockets[1].websocket.running) then
        return
    end

    for _, e in ipairs(self.pool) do
        local id = e.spawner.id

        if (id == "south" or id == "8a" or id == "8b") then
            ECS.entity(self:getWorld())
            :assemble(Assemblages.car, e.spawner.road)
        end

        if (id == "5") then
            for i = 1, 1 do
                ECS.entity(self:getWorld())
                :assemble(Assemblages.car, e.spawner.road)
            end
        end

        if (id == "10") then
            for i = 1, 1 do
                ECS.entity(self:getWorld())
                :assemble(Assemblages.car, e.spawner.road)
            end
        end
    end
end

return Spawning