local net = require "net"
local player = require "player"

local M = {}

function M:enter()
    self.fd = net:connect("127.0.0.1", 8888)
    local msg = {
        account = player:get_account(),
        passwd = player:get_passwd()}
    net:send_request(self.fd, "login.login", msg)
    player:set_fd(self.fd)
end

function M:tick()

end

function M:leave()

end

return M
