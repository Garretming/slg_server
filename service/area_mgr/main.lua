-- 每个area是一个赛场，本服务是赛场管理器
local skynet = require "skynet"
require "skynet.manager"
local area_mgr = require "area_mgr"

local CMD = {}

function CMD.start()
    area_mgr:init()
end

function CMD.get_area(game_id)
    return area_mgr:get_area(game_id)
end

local function dispatch(_, session, cmd, ...)
    local f = CMD[cmd]
    assert(f, "area_mgr接收到非法lua消息: "..cmd)

    if session == 0 then
        f(...)
    else
        skynet.ret(skynet.pack(f(...)))
    end
end

skynet.start(function ()
    skynet.dispatch("lua", dispatch)

    skynet.register("area_mgr")

    skynet.error("area_mgr booted...")
end)
