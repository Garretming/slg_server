require "my_init"
local skynet = require "skynet"
local db = require "db"
local sock_mgr = require "sock_mgr"
local player_mgr  = require "player_mgr"
local login_mgr = require "login_mgr"
local msg_handler = require "msg_handler.init"

local CMD = {}

function CMD.start(conf)
    db:init()
    sock_mgr:start(conf)
    player_mgr:init()
    login_mgr:init()
    msg_handler.init()
end

function CMD.room_begin(msg)
    local obj = player_mgr:get_by_account(msg.account)
    if not obj then
        return
    end

    obj:room_begin(msg)
end

function CMD.get_clients()
    return {clients = sock_mgr:get_clients()}
end

function CMD.sendto_client(account, proto_name, msg)
    local obj = player_mgr:get_by_account(account)
    if not obj then
        return
    end

    obj:sendto_client(proto_name, msg)
end

skynet.start(function()
    skynet.dispatch("lua", function(_, session, cmd, subcmd, ...)
        if cmd == "socket" then
            sock_mgr[subcmd](sock_mgr, ...)
            return
        end

        local f = CMD[cmd]
        assert(f, "can't find dispatch handler cmd = "..cmd)

        if session > 0 then
            return skynet.ret(skynet.pack(f(subcmd, ...)))
        else
            f(subcmd, ...)
        end
    end)
end)
