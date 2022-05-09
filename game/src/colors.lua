local function Color(r, g, b, a)
    return {
        r / 255,
        g / 255,
        b / 255,
        a and a / 255 or 1
    }
end

local Colors = {
    background = Color(17, 17, 30),
    
    outline = Color(225, 225, 225),
    car = Color(211, 55, 52),
    pedestrian = Color(211, 55, 52),
    bicycle = Color(211, 55, 52),
    boat = Color(211, 55, 52),

    road = {
        normal = Color(225, 225, 225),
        red = Color(205, 73, 73),
        orange = Color(204, 134, 73),
        green = Color(108, 204, 73),
    },

    warningLight = {
        on = Color(205, 73, 73),
        off = Color(0, 0, 0, 0),
    },

    barrier = Color(225, 225, 225),
}

return Colors