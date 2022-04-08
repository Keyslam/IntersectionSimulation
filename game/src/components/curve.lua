local curve = ECS.component("curve", function(e, ...)
    e.value = love.math.newBezierCurve(...)

    e.length = e:calculateLength(100)
end)

function curve:getStartPoint()
    return self.value:getControlPoint(1)
end

function curve:calculateLength(samples, start, finish)
    start = start or 0
    finish = finish or 1

    local length = 0

    local previousPointX, previousPointY = self.value:evaluate(start)
    local delta = finish - start

    for i = 2, samples do
        local t = start + i / samples * delta
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