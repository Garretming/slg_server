local skynet = require "skynet"
local player_mgr = require "player_mgr"

local M = {}

function M.create_room(fd, request)
    local player = player_mgr:get_by_fd(fd)
    local id = skynet.call("room_mgr", "lua", "create_room", request.game_id, {base_app = skynet.self(), account = player:get_account()})
    return {room_id = id}
end

function M.join_room(fd, request)
    local player = player_mgr:get_by_fd(fd)
    local room_id = request.room_id
    skynet.call("room_mgr", "lua", "join_room", room_id, {base_app = skynet.self(), account = player:get_account()})
    return {room_id = room_id}
end

return M
