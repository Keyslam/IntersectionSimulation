local Shapes = require("src.shapes")
local Colors = require("src.colors")

return function(e, road)
    return e
    :give("roadFollower", road, 80)
    :give("transform", {x = 0, y = 0}, 0)
    :give("shape", Shapes.pedestrian)
    :give("color", Colors.pedestrian)
    :give("collider")
end