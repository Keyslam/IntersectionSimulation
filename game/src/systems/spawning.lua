local Spawning = ECS.system({
    pool = {"spawner"}
})

function Spawning:spawn(dt)
    for _, e in ipairs(self.pool) do
        if (love.math.random() > 0) then
            ECS.entity(self:getWorld())
            :assemble(Assemblages.car, e.spawner.road)
        end
    end
end

return Spawning