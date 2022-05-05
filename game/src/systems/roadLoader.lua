local Colors = require("src.colors")

local RoadLoader = ECS.system()

function RoadLoader:load()
    local serializedData= love.filesystem.read("roads.txt")

    if (serializedData) then
        local data = JSON.decode(serializedData)

        for _, roadData in ipairs(data) do
            local from = Vector(roadData.from.x, roadData.from.y)
            local to = Vector(roadData.to.x, roadData.to.y)

            local e = ECS.entity(self:getWorld())
            :assemble(Assemblages.road, from, to, roadData.kind)
        end
    end
end

return RoadLoader
