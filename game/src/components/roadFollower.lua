ECS.component("roadFollower", function(e, road, progress)
    e.road = road
    e.progress = progress or 0
    e.velocity = 0
    e.maxVelocity = 100
    e.acceleration = 30
    e.deceleration = 30
end)