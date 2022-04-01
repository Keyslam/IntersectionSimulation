local Colors = require("src.colors")

local RoadHandler = ECS.system({
    pool = {"color", "state", "id"}
})

function RoadHandler:init()
    self.idLookup = {}

    self.pool.onAdded = function(_, e)
        self.idLookup[e.id.value] = e
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

function RoadHandler:MESSAGE_SET_AUTOMOBILE_ROUTE_STATE(_, data)
    local e = self.idLookup[data.routeId]

    if (data.state == "RED") then
        e.state.value = "RED"
        e.color.value = Colors.road.red
    elseif (data.state == "ORANGE") then
        e.state.value = "ORANGE"
        e.color.value = Colors.road.orange
    elseif (data.state == "GREEN") then
        e.state.value = "GREEN"
        e.color.value = Colors.road.green
    end
end

return RoadHandler