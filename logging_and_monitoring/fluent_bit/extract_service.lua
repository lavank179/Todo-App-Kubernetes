function add_service_label(tag, timestamp, record)
    local path = record["log_file"]

    if path ~= nil then
        -- example path: /logs/backend/app.log
        local service = string.match(path, "/logs/([^/]+)/")
        if service ~= nil then
            record["service"] = service
        end
    end

    return 1, timestamp, record
end
