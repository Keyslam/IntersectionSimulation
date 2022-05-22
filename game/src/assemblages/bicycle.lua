local Shapes = require("src.shapes")
local Colors = require("src.colors")

return function(e, road)
    return e
    :give("roadFollower", road, 150)
    :give("transform", {x = 0, y = 0}, 0)
    :give("shape", Shapes.bicycle)
    :give("color", Colors.bicycle)
    :give("collider")
end