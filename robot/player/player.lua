local net = require "net"

local M = {}

function M:init(account, passwd)
    self.status = "login"
    self.account = account
    self.passwd = passwd
end

function M:get_account()
    return self.account
end

function M:get_passwd()
    return self.passwd
end

function M:set_fd(fd)
    self.fd = fd
end

function M:send_request(name, msg)
    net:send_request(self.fd, name, msg)
end

return M
