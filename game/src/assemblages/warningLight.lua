local Shapes = require("src.shapes")
local Colors = require("src.colors")

return function(e, x, y)
    return e
    :give("transform", {x = x, y = y}, 0)
    :give("shape", Shapes.warningLight)
    :give("color", Colors.warningLight.off)
    :give("warningLight")
end