local SyncTransformToCollider = ECS.system({
    pool = {"transform", "shape", "collider"}
})

function SyncTransformToCollider:init()
    self.colliders = {}

    self.pool.onAdded = function(_, e)
        local hc = self:getWorld():getResource("hc")

        local collider = hc:rectangle(0, 0, e.shape.value.size.w, e.shape.value.size.h)
        collider:moveTo(e.transform.position.x, e.transform.position.y)
        collider:setRotation(e.transform.rotation)

        self.colliders[e] = collider
    end

    self.pool.onRemoved = function(_, e)
        local hc = self:getWorld():getResource("hc")
        hc:remove(self.colliders[e])
        self.colliders[e] = nil
    end
end

function SyncTransformToCollider:update()
    for _, e in ipairs(self.pool) do
        local collider = self.colliders[e]

        collider:moveTo(e.transform.position.x, e.transform.position.y)
        collider:setRotation(e.transform.rotation)
    end
end

return SyncTransformToCollider