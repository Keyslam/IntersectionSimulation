local Reference = require("src.reference")

ECS.component("route", function(e, ...)
    e.to = {}

    for i = 1, select("#", ...) do
        e.to = Reference(select(i, ...), "route")
    end
end)