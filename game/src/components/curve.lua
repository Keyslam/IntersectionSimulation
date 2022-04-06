local curve = ECS.component("curve", function(e, ...)
    e.value = love.math.newBezierCurve(...)

    e.length = e:calculateLength(100)
end)

function curve:getStartPoint()
    return self.value:getControlPoint(1)
end

function curve:calculateLength(samples)
    local length = 0

    local previousPointX, previousPointY = self.value:evaluate(0)

    for i = 2, samples do
        local t = i / samples
        local currentPointX, currentPointY = self.value:evaluate(t)

        local dx = previousPointX - currentPointX
        local dy = previousPointY - currentPointY

        local distance = math.sqrt(dx * dx + dy * dy)

        length = length + distance

        previousPointX = currentPointX
        previousPointY = currentPointY
    end

    return length
end