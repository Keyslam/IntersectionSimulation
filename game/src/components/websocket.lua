return ECS.component("websocket", function(e, host, port, sessionName, sessionVersion)
    e.host = host
    e.port = port

    e.sessionName = sessionName
    e.sessionVersion = sessionVersion

    e.client = nil

    e.running = false
end)