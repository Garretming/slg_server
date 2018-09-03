local skynet = require "skynet"
local utils = require "utils"
local player = require "player"
local net = require "net"
local status_mgr = require "status.mgr"

local function conn_baseapp(fd, ip, port)
    net:close(fd)

    fd = net:connect(ip, port)

    net:send_request(fd, "login.login_baseapp", {account = player:get_account(), token = "token"})
    player:set_fd(fd)
end

local M = {}

function M.login(fd, msg)
    if msg.errmsg == "account not exist" then
        local request = {
            account = player:get_account(),
            passwd = player:get_passwd()
        }
        net:send_request(fd, "login.register", request)
        return
    end

    conn_baseapp(fd, msg.ip, msg.port)
end

function M.register(fd, msg)
    conn_baseapp(fd, msg.ip, msg.port)
end

function M.login_baseapp(fd, msg)
    status_mgr:enter("hall")
end

return M
