ECS.component("road", function(e, sensorId)
    print(sensorId)
    e.sensorId = sensorId
    e.occupants = {}
    e.from = {}
    e.to = {}

    e.preSensor = {}
    e.sensor = {}
end)