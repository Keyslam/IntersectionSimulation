local curve = ECS.component("curve", function(e, from, to, kind)
    e.from = from
    e.to = to
    e.value = nil
    e.kind = kind

    e:updateBezier()
end)

function curve:updateBezier()
    local vertices = nil

    if (self.kind == "TURN_LEFT") then
        vertices = {
            self.from.x, self.from.y,
            self.from.x, self.to.y,
            self.to.x, self.to.y
        }
    elseif (self.kind == "TURN_RIGHT") then
        vertices = {
            self.from.x, self.from.y,
            self.to.x, self.from.y,
            self.to.x, self.to.y
        }
    elseif (self.kind == "S_HORIZONTAL") then
        local halfX = (self.from.x + self.to.x) / 2

        vertices = {
            self.from.x, self.from.y,
            halfX, self.from.y,
            halfX, self.to.y,
            self.to.x, self.to.y
        }
    elseif (self.kind == "S_VERTICAL") then
        local halfY = (self.from.y + self.to.y) / 2

        vertices = {
            self.from.x, self.from.y,
            self.from.x, halfY,
            self.to.x, halfY,
            self.to.x, self.to.y
        }
    elseif (self.kind == "STRAIGHT") then
        local halfX = (self.from.x + self.to.x) / 2
        local halfY = (self.from.y + self.to.y) / 2

        vertices = {
            self.from.x, self.from.y,
            halfX, halfY,
            self.to.x, self.to.y
        }
    else
        error("Unknown curve kind", self.kind)
    end

    self.value = love.math.newBezierCurve(vertices)
    self.derivative = self.value:getDerivative()
    self.length = self:calculateLength(100)
end

local function sqr(x)
    return x * x
end

local function dist2(v, w)
    return sqr(v.x - w.x) + sqr(v.y - w.y)
end

local function distToSegmentSquared(p, v, w)
    local l2 = dist2(v, w)

    if (l2 == 0) then
        return dist2(p, v)
    end

    local t = ((p.x - v.x) * (w.x - v.x) + (p.y - v.y) * (w.y - v.y)) / l2;
    t = math.max(0, math.min(1, t));

    return dist2(p, {
        x = v.x + t * (w.x - v.x),
        y = v.y + t * (w.y - v.y)
    })
end

local function distToSegment(p, v, w)
    return math.sqrt(distToSegmentSquared(p, v, w));
end

function curve:distanceTo(x, y)
    local minDist = math.huge

    local point = Vector(x, y)

    local sx1, sy1 = self.value:evaluate(0)
    for t = 0.1, 1, 0.1 do
        local sx2, sy2 = self.value:evaluate(t)

        local dist = distToSegment(point, Vector(sx1, sy1), Vector(sx2, sy2))

        if (dist < minDist) then
            minDist = dist
        end

        sx1 = sx2
        sy1 = sy2
    end

    return minDist
end

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