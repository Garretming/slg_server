local skynet = require "skynet"
local player_mgr = require "player_mgr"

local CMD = {}

function CMD.login_lobby(info)
    local acc = player_mgr:get(info.account)
    if not acc then
        player_mgr:add(info)
    end

    return {
        err = "success",
        room_card = 100,
    }
end

function CMD.create_room(msg)
    local acc = player_mgr:get(info.account)
    if not acc then
        return {err="relogin"}
    end

    local info = {
        account = acc.account,
        options = acc.options,
    }
    return = skynet.call("room_mgr", "lua", "create_room", info)
end

function CMD.join_room(msg)
    local acc = player_mgr:get(info.account)
    if not acc then
        return {err="relogin"}
    end

    local info = {
        account = acc.account,
        room_id = msg.room_id,
    }
    return = skynet.call("room_mgr", "lua", "join_room", info)
end

skynet.start(function()
    skynet.dispatch("lua", function(_, session, cmd, ...)
        local f = CMD[cmd]
        if not f then
            return
        end

        if session > 0 then
            skynet.ret(skynet.pack(f(...)))
        else
            f(...)
        end
    end)
end)
