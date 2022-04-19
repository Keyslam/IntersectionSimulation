local curve = ECS.component("curve", function(e, ...)
    e.value = love.math.newBezierCurve(...)

    e.derivative = e.value:getDerivative()
    e.length = e:calculateLength(100)
end)

function curve:getStartPoint()
    return self.value:getControlPoint(1)
end

function curve:step(t, step)
    t = (t < 0 and 0) or (t > 1 and 1) or t

	local dx, dy = self.derivative:evaluate(t)
	local dlen = math.sqrt(dx * dx + dy * dy)

	dx, dy = -dy / dlen, dx / dlen
	t = t + step / dlen

    return t
end

function curve:calculateLength(samples, start, finish)
    start = start or 0
    finish = finish or 1

    local length = 0

    local previousPointX, previousPointY = self.value:evaluate(start)
    local t = start

    local i = 0

    while (t <= finish) do
        i = i + 1
        local currentPointX, currentPointY = self.value:evaluate(t)

        t = self:step(t, 5)

        local dx = previousPointX - currentPointX
        local dy = previousPointY - currentPointY

        local distance = math.sqrt(dx * dx + dy * dy)

        length = length + distance

        previousPointX = currentPointX
        previousPointY = currentPointY
    end

    -- for i = 2, samples do
    --     local t = start + i / samples * delta
    --     local currentPointX, currentPointY = self.value:evaluate(t)

    --     local dx = previousPointX - currentPointX
    --     local dy = previousPointY - currentPointY

    --     local distance = math.sqrt(dx * dx + dy * dy)

    --     length = length + distance

    --     previousPointX = currentPointX
    --     previousPointY = currentPointY
    -- end

    return length
end