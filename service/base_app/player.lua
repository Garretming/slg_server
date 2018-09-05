local db = require "db"
local sock_mgr = require "sock_mgr"

local M = {}

M.__index = M

function M.create(...)
    local o = {}
    setmetatable(o, M)

    M.init(o, ...)
    return o
end

function M:init(fd, account)
    self.fd = fd
    self.account = account
    self.status = "load from db"
end

function M:load_from_db()
    local obj = db:load_player(self.account)
    if obj then
        self._db = obj
    else
        self:_create_db()
    end
end

function M:_create_db()
    local obj = {
        account = self.account,
        nick_name = "Hero"..os.time(),
        score = 0,
    }
    db:save_player(obj)
    self._db = obj
end

function M:pack()
    return {
        account = self.account,
        nick_name = self._db.nick_name,
        score = self._db.score
    }
end

function M:sendto_client(proto_name, msg)
    sock_mgr:send(self.fd, proto_name, msg)
end

function M:get_account()
    return self.account
end

function M:room_begin(msg)
    self.area = msg.addr
    self.room_id = msg.room_id
    self:sendto_client("room.room_begin", {})
end

return M
