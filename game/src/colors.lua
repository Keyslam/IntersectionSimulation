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
    
    shapefill = Color(211, 55, 52),
    car = Color(225, 225, 225),
    pedestrian = Color(225, 225, 225),
    bicycle = Color(225, 225, 225),

    road = {
        normal = Color(225, 225, 225),
        red = Color(205, 73, 73),
        orange = Color(204, 134, 73),
        green = Color(108, 204, 73),
    }
}

return Colors