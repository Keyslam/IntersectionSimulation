local RoadGraphSync = ECS.system({
    pool = {"road", "curve"}
})

function RoadGraphSync:init()
    self.previous = {}

    local RoadGraph = self:getWorld():getResource("roadGraph")

    self.pool.onAdded = function(_, e)
        RoadGraph:addRoad(e, e.curve.from, e.curve.to)

        self.previous[e] = {
            from = e.curve.from:clone(),
            to = e.curve.to:clone(),
        }
    end

    self.pool.onRemoved = function(_, e)
        RoadGraph:removeRoad(e)

        self.previous[e] = nil
    end
end

function RoadGraphSync:update(dt)
    local RoadGraph = self:getWorld():getResource("roadGraph")

    for _, e in ipairs(self.pool) do
        if (self.previous[e].from ~= e.curve.from or self.previous[e].to ~= e.curve.to) then
            RoadGraph:removeRoad(e)
            RoadGraph:addRoad(e, e.curve.from, e.curve.to)

            self.previous[e].from = e.curve.from
            self.previous[e].to = e.curve.to
        end
    end
end

return RoadGraphSync