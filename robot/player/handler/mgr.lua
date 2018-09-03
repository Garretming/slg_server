local net = require "net"
local login_handler = require "handler.login"
local room_handler = require "handler.room"


local M = {}

function M:init()
    self:add_handler("login", login_handler)
    self:add_handler("room", room_handler)
end

function M:add_handler(name, module)
    for k,v in pairs(module) do
        net:register_msg_handler(name.."."..k, v)
    end
end

return M
