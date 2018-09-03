local skynet = require "skynet"
require "skynet.manager"
local room_owner
local players = {}

local function create_players()
    room_owner = skynet.newservice("player", "robot1", "robot1")
    table.insert(players, skynet.newservice("player", "robot2", "robot2"))
    table.insert(players, skynet.newservice("player", "robot3", "robot3"))
    table.insert(players, skynet.newservice("player", "robot4", "robot4"))
end

local CMD = {}

function CMD.login_success()

end

function CMD.create_room_success(room_id)
    print("玩家创建房间成功")
    skynet.timeout(3*100, function()
        for _,v in ipairs(players) do
            skynet.send(v, "lua", "join_room", room_id)
        end
    end)
end

skynet.start(function ()
    skynet.dispatch("lua", function (src, session, cmd, ...)
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

    create_players()

    skynet.register("room")
end)
