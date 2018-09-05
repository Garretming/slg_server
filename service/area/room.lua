local skynet = require "skynet"
local utils = require "utils"
local match = require "match"

-- 房间类，每个房间为一场比赛
local M = {}

M.__index = M

function M.new(...)
    local o = {}
    setmetatable(o, M)

    M.init(o, ...)

    return o
end

function M:init(info)
    self.id = info.id
    self.player_list = info.player_list
    print("创建牌桌")
    utils.print(info)
end

function M:begin()
    local msg = {addr = skynet.self(), room_id = self.id}

    for _,v in ipairs(self.player_list) do
        msg.account = v.account
        skynet.error("发送room_begin到"..v.base_app)
        skynet.send(v.base_app, "lua", "room_begin", msg)
    end

    skynet.send("room_mgr", "lua", "room_begin", self.id)

    self:begin_match()
end

function M:begin_match()
    self.match = match.new(self)
    self.match:begin()
end

function M:send_client(seat, proto_name, msg)
    local player = self.player_list[seat]
    skynet.send(player.base_app, "lua", "sendto_client", player.account, proto_name, msg)
end

function M:send_all_client(proto_name, msg)
    for _,player in ipairs(self.player_list) do
        skynet.send(player.base_app, "lua", "sendto_client", player.account, proto_name, msg)
    end
end

return M
