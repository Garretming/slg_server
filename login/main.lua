local skynet = require "skynet"

function main()
    skynet.newservice("httplistener", skynet.getenv("LOGIN_WEB_PORT"))

    skynet.newservice("mongo")
    skynet.call("mongo", "lua", "start")

    skynet.newservice("account_mgr")
    skynet.call("account_mgr", "lua", "start")

    skynet.exit()
end

skynet.start(main)
