local skynet = require "skynet"

local function main()
    skynet.newservice("debug_console", 8081)

    -- 登陆服务
    local login = skynet.newservice("login")
    skynet.call(login, "lua", "start", {
        port = 16800,
        maxclient = 1000,
        nodelay = true,
    })

    -- base_app_mgr
    skynet.uniqueservice("base_app_mgr")
    skynet.call("base_app_mgr", "lua", "start")

    -- area_mgr
    skynet.uniqueservice("area_mgr")
    skynet.call("area_mgr", "lua", "start")

    -- room_mgr
    skynet.uniqueservice("room_mgr")

    skynet.exit()
end

skynet.start(main)
