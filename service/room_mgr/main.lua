local skynet = require "skynet"
require "skynet.manager"
local G = require "global"
local room_mgr = require "room_mgr"
local timer_mgr = require "timer_mgr"

local function init()
    G.timer_mgr = timer_mgr.new()
    G.room_mgr = room_mgr
    room_mgr:init()
    G.room_timer = G.timer_mgr:add(1*1000, -1, function() room_mgr:check_ready() end)
end

local CMD = {}

function CMD.create_room(game_id, player_info)
    return room_mgr:create(game_id, player_info)
end

function CMD.join_room(room_id, player_info)
    return room_mgr:join(room_id, player_info)
end

function CMD.room_begin(room_id)
    room_mgr:room_begin(room_id)
end

local function dispatch(_, session, cmd, ...)
    local f = CMD[cmd]
    assert(f, "room_mgr接收到非法lua消息: "..cmd)

    if session == 0 then
        f(...)
    else
        skynet.ret(skynet.pack(f(...)))
    end
end

skynet.start(function ()
    skynet.dispatch("lua", dispatch)

    init()

    skynet.register("room_mgr")

    skynet.error("room_mgr booted...")
end)
