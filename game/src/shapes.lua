local Shapes = {}

Shapes.car = {
    outline = {
        0, 0,
        7, 0,
        8, 1,
        8, 3,
        7, 4,
        0, 4,
    },
}

Shapes.pedestrian = {
    outline = {
        0, 0,
        1, 0,
        2, 1,
        1, 2,
        0, 2,
    },
}

Shapes.bicycle = {
    outline = {
        0, 0,
        3, 0,
        4, 1,
        3, 2,
        0, 2,
    },
}

Shapes.boat = {
    outline = {
       7, 0,
       38, 0,
       39, 1,
       49, 1,
       50, 2,
       52, 2,
       53, 3,
       54, 3,
       57, 6,
       57, 14,
       54, 17,
       53, 17,
       52, 18,
       50, 18,
       49, 19,
       39, 19,
       38, 20,
       6, 20,
       5, 19,
       4, 19,
       3, 18,
       2, 18,
       0, 16,
       0, 4,
       2, 2,
       3, 2,
       4, 1,
       6, 1
    },
}

Shapes.warningLight = {
    outline = {
        1, 0,
        6, 0,
        7, 1,
        7, 6,
        6, 7,
        1, 7,
        0, 6,
        0, 1,
    }
}

for _, shape in pairs(Shapes) do
    for k, v in pairs(shape.outline) do
        shape.outline[k] = v * 5
    end
end

for _, shape in pairs(Shapes) do
    local minX = math.huge
    local minY = math.huge
    local maxX = 0
    local maxY = 0

    for i = 1, #shape.outline, 2 do
        local x = shape.outline[i]
        local y = shape.outline[i+1]

        minX = math.min(minX, x)
        minY = math.min(minY, y)

        maxX = math.max(maxX, x)
        maxY = math.max(maxY, y)
    end

    shape.boundingbox = {
        topLeft = {x = minX, y = minY},
        topRight = {x = maxX, y = minY},
        bottomLeft = {x = minX, y = maxY},
        bottomRight = {x = maxX, y = maxY},
    }

    shape.size = {w = maxX - minX, h = maxY - minY}
end

return Shapes