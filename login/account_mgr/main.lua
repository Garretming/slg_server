local skynet = require "skynet"
require "skynet.manager"
local account_mgr = require "account_mgr"

local CMD = {}

function CMD.start(conf)
    account_mgr:init()
end

function CMD.register(msg)
    return account_mgr:register(msg)
end

function CMD.login(msg)
    return account_mgr:login(msg)
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
    skynet.register("account_mgr")
end)
