local Reference = {}
Reference.__mt = {
    __index = Reference,
}

function Reference.new(entity, componentName)
    local reference = setmetatable({
        __entity = entity,
        __componentName = componentName
    }, Reference.__mt)

    return reference
end

function Reference:set(entity, componentName)
    self.__entity = entity
    self.__componentName = componentName
end

function Reference:get()
    if (not self:resolves()) then
        return nil
    end

    return self.__entity[self.__componentName]
end

function Reference:resolves()
    if (self.__entity == nil) then
        return false
    end

    if (not self.__entity:inWorld()) then
        return false
    end

    if (not self.__entity:has(self.__componentName)) then
        return false
    end

    return true
end

return setmetatable(Reference, {
    __call = function(_, ...) return Reference.new(...) end,
})