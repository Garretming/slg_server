local skynet = require "skynet"

local function main()
    skynet.newservice("debug_console", 9000)

    skynet.newservice("room")

    skynet.exit()
end

skynet.start(main)
