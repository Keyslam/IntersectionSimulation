local Spawning = ECS.system({
    pool = {"spawner"},
    websockets = {"websocket"}
})

function Spawning:update(dt)
    -- if (#self.websockets == 0) then
    --     return
    -- end

    -- if (not self.websockets[1].websocket.running) then
    --     return
    -- end

    local settings = self:getWorld():setResource("settings")
    if (not settings.spawningEnabled) then
        return
    end

    for _, e in ipairs(self.pool) do
        e.spawner.cooldown = e.spawner.cooldown - dt

        if (e.spawner.cooldown <= 0) then
            if (love.math.random() > 0.9) then
                local _e = ECS.entity(self:getWorld())
                if (e.spawner.kind == "AUTOMOBILE") then
                    _e:assemble(Assemblages.car, e)
                elseif (e.spawner.kind == "BICYCLE") then
                    _e:assemble(Assemblages.bicycle, e)
                elseif (e.spawner.kind == "PEDESTRIAN") then
                    _e:assemble(Assemblages.pedestrian, e)
                elseif (e.spawner.kind == "BOAT") then
                    _e:assemble(Assemblages.boat, e)
                end
            end

            e.spawner.cooldown = e.spawner.maxCooldown
        end
    end
end

return Spawning