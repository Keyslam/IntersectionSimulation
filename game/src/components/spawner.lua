ECS.component("spawner", function(e, kind)
    e.kind = kind
    e.cooldown = 1
    e.maxCooldown = 5
    e.spawnChance = 5
end)