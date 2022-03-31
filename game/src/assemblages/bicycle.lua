local Shapes = require("src.shapes")
local Colors = require("src.colors")

return function(e, position, rotation)
    return e
    :give("transform", position, rotation)
    :give("shape", Shapes.bicycle)
    :give("color", Colors.bicycle)
end