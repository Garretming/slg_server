local skynet = require "skynet"
local utils = require "utils"

local M = {}

function M.create_room(fd, msg)
    print(fd, name, msg)
    if msg.errmsg then
        return
    end

    skynet.send("room", "lua", "create_room_success", msg.room_id)
    utils.print(msg)
end

function M.join_room()

end

return M
