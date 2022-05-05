local Colors = require("src.colors")

return function(e, from, to, kind, id, sensorId)
    e
    :give("color", Colors.road.normal)
    :give("road", sensorId)
    :give("selectable")

    if (id) then
        e
        :give("state", "RED")
        :give("id", id)
    end

    e:give("curve", from, to, kind)
end