local skynet = require "skynet"
local player_mgr = require "player_mgr"
local room = require "room"
local room_mgr = require "room_mgr"

local area_id = ...
area_id = tonumber(area_id)

local CMD = {}

function CMD.create_room(info)
    print("创建游戏")

    local obj = room.new(info)
    room_mgr:add(obj)
    obj:begin()
end

function CMD.leave()

end

function CMD.test()
end

skynet.start(function ()
    skynet.dispatch("lua", function (_, session, cmd, ...)
        local f = CMD[cmd]
        assert(f, cmd)

        if session == 0 then
            f(...)
        else
            skynet.ret(skynet.pack(f(...)))
        end
    end)

    room_mgr:init()
end)
