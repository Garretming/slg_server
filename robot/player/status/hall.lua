local net = require "net"
local player = require "player"

local M = {}

function M:enter()
    if player:get_account() == "robot1" then
        player:send_request("room.create_room", {game_id = 1})
    end
end

function M:tick()

end

function M:leave()

end

return M
