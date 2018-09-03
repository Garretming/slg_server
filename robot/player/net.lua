local skynet = require "skynet"
local socket = require "socket"
local utils = require "utils"
local msg_define = require "msg_define"

local M = {
    fds = {},
    handler_tbl = {}
}

function M:connect(ip, port)
    local fd = socket.open(ip, port)
    if not fd then
        skynet.error("连接 "..ip..":"..port.."成功")
        return
    end

    self.fds[fd] = {
        last = "",
        packs = {}
    }

    skynet.fork(function() self:recv_loop(fd) end)

    skynet.error("连接"..ip..":"..port.."成功")
    return fd
end

function M:recv_loop(fd)
    while true do
        if not self.fds[fd] then
            return
        end

        local str = socket.read(fd)
        if str then
            self:data(fd, str)
        else
            self:close()
            return
        end
    end
end

function M:data(fd, str)
    skynet.error("收到数据"..#str)
    local info = self.fds[fd]
    if not info then
        return
    end

    local last = info.last .. str

    local len
    local pack_list = {}
    repeat
        if #last < 2 then
            break
        end
        len = last:byte(1) * 256 + last:byte(2)
        if #last < len + 2 then
            break
        end
        table.insert(pack_list, last:sub(3, 2 + len))
        last = last:sub(3 + len) or ""
    until(false)

    info.last = last

    for _,v in ipairs(pack_list) do
        self:deal_package(fd, v)
    end
end

function M:deal_package(fd, data)
    skynet.error("deal package len = "..#data)
    local id, param_str = string.unpack(">Hs2", data)
    print("recv package:", id, param_str)

    local name = msg_define.idToName(id)
    local param = utils.str_2_table(param_str)

    self:dispatch_msg(fd, name, param)
end

function M:close(fd)
    socket.close(fd)
    self.fds[fd] = nil
end

function M:send_request(fd, name, msg)
    local id = msg_define.nameToId(name)
    local msg_str = utils.table_2_str(msg)
    local len = 2 + 2 + #msg_str
    local data = string.pack(">HHs2", len, id, msg_str)
    socket.write(fd, data)

    skynet.error("send msg "..name)
end

function M:dispatch_msg(fd, name, param)
    local info = self.handler_tbl[name]
    if not info then
        skynet.error("can't find msg handler msg = "..name)
        return
    end
    if info.obj then
        info.handler(info.obj, fd, param)
    else
        info.handler(fd, param)
    end
end

function M:register_msg_handler(name, handler, obj)
    self.handler_tbl[name] = {handler = handler, obj = obj}
end

return M
