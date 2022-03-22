return ECS.component("websocket", function(e, host, port)
    e.host = host
    e.port = port

    e.client = nil
end)