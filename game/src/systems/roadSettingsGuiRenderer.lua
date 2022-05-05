local RoadSettingsGuiRenderer = ECS.system({
    pool = {"road", "curve", "selected"}
})

local kinds = {"STRAIGHT", "TURN_LEFT", "TURN_RIGHT", "S_HORIZONTAL", "S_VERTICAL"}

function RoadSettingsGuiRenderer:draw()
    local grid = self:getWorld():getResource("grid")

    if (Imgui.Begin("Road Settings")) then
        for _, e in ipairs(self.pool) do
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

            if (changedFrom or changedTo) then
                e.curve:updateBezier()
            end

            if (Imgui.Button("Delete")) then
                e:destroy()
            end
        end

        Imgui.End()
    end
end



return RoadSettingsGuiRenderer