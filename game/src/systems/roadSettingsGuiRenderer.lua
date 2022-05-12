local RoadSettingsGuiRenderer = ECS.system({
    pool = {"road", "curve", "selected"}
})

local kinds = {"STRAIGHT", "TURN_LEFT", "TURN_RIGHT", "S_HORIZONTAL", "S_VERTICAL"}
local spawnings = {"NONE", "AUTOMOBILE", "BICYCLE", "PEDESTRIAN", "BOAT"}
local ids = {
    1, 2, 3, 4, 5, 7, 8, 9, 10, 11, 12, 15,
    21, 22, 23, 24,
    31, 32, 33, 34, 35, 36, 37, 38,
    41, 42
}
local sensorIds = {
    {1, 1}, {1, 2}, {2, 1}, {2, 2}, {2, 3}, {2, 4}, {3, 1}, {3, 2}, {4, 1}, {4, 2}, {4, 3}, {4, 4}, {5, 1}, {5, 2}, {7, 1}, {7, 2}, {8, 1}, {8, 2}, {8, 3}, {8, 4}, {9, 1}, {9, 2}, {10, 1}, {10, 2}, {11, 1}, {11, 2}, {12, 1}, {12, 2}, {15, 1}, {15, 2},
    {21, 1}, {22, 1}, {23, 1}, {24, 1},
    {31, 1}, {31, 2}, {32, 1}, {32, 2}, {33, 1}, {33, 2}, {34, 1}, {34, 2}, {35, 1}, {35, 2}, {36, 1}, {36, 2}, {37, 1}, {37, 2}, {38, 1}, {38, 2},
    {41, 1}, {42, 1},
}

function RoadSettingsGuiRenderer:draw()
    local RoadGraph = self:getWorld():getResource("roadGraph")
    local grid = self:getWorld():getResource("grid")

    if (Imgui.Begin("Road Settings")) then
        for _, e in ipairs(self.pool) do
            Imgui.Separator()
            local changedFrom, changedTo = false, false
            e.curve.from.x, e.curve.from.y, changedFrom = Imgui.DragFloat2("From", e.curve.from.x, e.curve.from.y, grid.size)
            e.curve.to.x, e.curve.to.y, changedTo = Imgui.DragFloat2("To", e.curve.to.x, e.curve.to.y, grid.size)

            if (Imgui.BeginCombo("Kind", e.curve.kind)) then
                for _, kind in ipairs(kinds) do
                    if (Imgui.Selectable(kind)) then
                        e.curve.kind = kind
                        e.curve:updateBezier()
                    end
                end

                Imgui.EndCombo()
            end

            if (Imgui.Button("Invert")) then
                e.curve.from.x, e.curve.from.y, e.curve.to.x, e.curve.to.y = e.curve.to.x, e.curve.to.y, e.curve.from.x, e.curve.from.y

                if (e.curve.kind == "TURN_LEFT") then
                    e.curve.kind = "TURN_RIGHT"
                elseif (e.curve.kind == "TURN_RIGHT") then
                    e.curve.kind = "TURN_LEFT"
                end

                e.curve:updateBezier()
            end

            Imgui.Separator()

            if (Imgui.BeginCombo("Spawning", e.spawner and e.spawner.kind or "NONE")) then
                for _, spawning in ipairs(spawnings) do
                    if (Imgui.Selectable(spawning)) then
                        if (spawning == "NONE") then
                            e:remove("spawner")
                        else
                            if (e.spawner) then
                                e.spawner.kind = spawning
                            else
                                e:give("spawner", spawning)
                            end
                        end
                    end
                end

                Imgui.EndCombo()
            end

            if (changedFrom or changedTo) then
                e.curve:updateBezier()
            end

            if (Imgui.BeginCombo("ID", e.id and e.id.value or "NONE")) then
                if (Imgui.Selectable("NONE")) then
                    e:remove("id")
                    e:remove("state")
                end

                for _, id in ipairs(ids) do
                    if (Imgui.Selectable(id)) then
                        e:give("id", id)
                        e:give("state", "RED")
                    end
                end

                Imgui.EndCombo()
            end

            if (Imgui.BeginCombo("Sensor ID", e.road.sensorId and e.road.sensorId[1] ..".".. e.road.sensorId[2] or "NONE")) then
                if (Imgui.Selectable("NONE")) then
                    e.road.sensorId = nil
                end

                for _, sensorId in ipairs(sensorIds) do
                    if (Imgui.Selectable(sensorId[1] ..".".. sensorId[2])) then
                        e.road.sensorId = sensorId
                    end
                end

                Imgui.EndCombo()
            end

            if (Imgui.BeginCombo("Phase", e.road.phase or "NONE")) then
                if (Imgui.Selectable("NONE")) then
                    e.road.phase = nil
                end

                for _, phase in ipairs({1, 2, 3, 4}) do
                    if (Imgui.Selectable(phase)) then
                        e.road.phase = phase
                    end
                end

                Imgui.EndCombo()
            end

            Imgui.Separator()

            e.road.isTunnel = Imgui.Checkbox("Is Tunnel", e.road.isTunnel)
            e.road.isBridgeRoad = Imgui.Checkbox("Is Bridge Road", e.road.isBridgeRoad)
            e.road.isBridgeWater = Imgui.Checkbox("Is Bridge Water", e.road.isBridgeWater)

            Imgui.Separator()

            if (Imgui.Button("Spawn (Automobile)")) then
                ECS.entity(self:getWorld())
                :assemble(Assemblages.car, e)
            end

            Imgui.SameLine()

            if (Imgui.Button("Spawn (Bicycle)")) then
                ECS.entity(self:getWorld())
                :assemble(Assemblages.bicycle, e)
            end

            if (Imgui.Button("Spawn (Pedestrian)")) then
                ECS.entity(self:getWorld())
                :assemble(Assemblages.pedestrian, e)
            end

            Imgui.SameLine()

            if (Imgui.Button("Spawn (Boat)")) then
                ECS.entity(self:getWorld())
                :assemble(Assemblages.boat, e)
            end

            Imgui.Separator()

            if (Imgui.Button("Delete")) then
                e:destroy()
            end
        end

        Imgui.End()
    end
end



return RoadSettingsGuiRenderer