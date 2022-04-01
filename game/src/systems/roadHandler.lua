local Colors = require("src.colors")

local RoadHandler = ECS.system({
    pool = {"color", "state", "id"}
})

function RoadHandler:init()
    self.idLookup = {}

    self.pool.onAdded = function(_, e)
        self:__syncColor(e)
    end
end

function RoadHandler:MESSAGE_SET_AUTOMOBILE_ROUTE_STATE(_, data)
    for _, e in ipairs(self.pool) do
        if (e.id.value == data.routeId) then
            e.state.value = data.state
            self:__syncColor(e)
        end
    end

end

function RoadHandler:__syncColor(e)
    if (e.state.value == "RED") then
        e.color.value = Colors.road.red
    elseif (e.state.value == "ORANGE") then
        e.color.value = Colors.road.orange
    elseif (e.state.value == "GREEN") then
        e.color.value = Colors.road.green
    end
end

return RoadHandler