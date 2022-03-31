ECS.component("curve", function(e, x1, y1, x2, y2, x3, y3)
    e.value = love.math.newBezierCurve( x1, y1, x2, y2, x3, y3)
end)