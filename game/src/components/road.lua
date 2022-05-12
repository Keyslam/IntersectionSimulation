ECS.component("road", function(e, sensorId)
    e.sensorId = sensorId
    e.occupants = {}
    e.from = {}
    e.to = {}
    e.isTunnel = false
    e.isBridgeRoad = false
    e.isBridgeWater = false
    e.phase = nil
    e.bridgeRoadProgress = 0

    e.preSensor = {}
    e.sensor = {}
end)