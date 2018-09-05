local skynet = require "skynet"

local CMD = {}

function CMD.create()

end

function CMD.join()

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
