local Colors = require("src.colors")

local WarningLightHandler = ECS.system({
    pool = {"warningLight", "color"}
})

function WarningLightHandler:init()
    self.idLookup = {}

    self.pool.onAdded = function(_, e)
        self:__syncColor(e)
    end

    self.pool.onRemoved = function(_, e)
        if (e.color) then
            e.color.value = Colors.warningLight.off
        end
    end
end

function WarningLightHandler:MESSAGE_SET_BRIDGE_WARNING_LIGHT_STATE(_, data)
    for _, e in ipairs(self.pool) do
        e.warningLight.state = data.state

        self:__syncColor(e)
    end

end

function WarningLightHandler:__syncColor(e)
    if (e.warningLight.state == "ON") then
        e.color.value = Colors.warningLight.on
    else
        e.color.value = Colors.warningLight.off
    end
end

return WarningLightHandler