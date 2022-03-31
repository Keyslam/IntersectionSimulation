local Colors = require("src.colors")

return function(e, from, to, kind)
    e
    :give("color", Colors.road.red)
    :give("road", 8)

    if (kind == "TURN_LEFT") then
        e:give("curve", from.x, from.y, from.x, to.y, to.x, to.y)
    elseif (kind == "TURN_RIGHT") then
        e:give("curve", from.x, from.y, to.x, from.y, to.x, to.y)
    elseif (kind == "S_HORIZONTAL") then
        local halfX = (from.x + to.x) / 2

        e:give("curve",
            from.x, from.y,
            halfX, from.y,
            halfX, to.y,
            to.x, to.y
        )
    elseif (kind == "S_VERTICAL") then
        local halfY = (from.y + to.y) / 2

        e:give("curve",
            from.x, from.y,
            from.x, halfY,
            to.x, halfY,
            to.x, to.y
        )
    elseif (kind == "STRAIGHT") then
        local halfX = (from.x + to.x) / 2
        local halfY = (from.y + to.y) / 2

        e:give("curve",
            from.x, from.y,
            halfX, halfY,
            to.x, to.y
        )
    end
end