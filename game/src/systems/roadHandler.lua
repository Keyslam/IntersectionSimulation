local Colors = require("src.colors")

local RoadHandler = ECS.system({
    pool = {"road", "color"}
})

function RoadHandler:init()
    self.idLookup = {}

    self.pool.onAdded = function(_, e)
        self.idLookup[e.road.id] = e
        print(e.road.id)
    end

    self.pool.onRemoved = function(_, e)
        for i, oe in pairs(self.idLookup) do
            if (e == oe) then
                self.idLookup[i] = nil
                break
            end
        end
    end
end

function RoadHandler:MESSAGE_SET_AUTOMOBILE_ROUTE_STATE(e, data)
    local e = self.idLookup[data.routeId]

    if (data.state == "RED") then
        e.road.state = "RED"
        e.color.value = Colors.road.red
    elseif (data.state == "ORANGE") then
        e.road.state = "ORANGE"
        e.color.value = Colors.road.orange
    elseif (data.state == "GREEN") then
        e.road.state = "GREEN"
        e.color.value = Colors.road.green
    end
end

return RoadHandler