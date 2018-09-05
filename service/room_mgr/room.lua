local skynet = require "skynet"
local G = require "global"

local M = {}

M.__index = M

function M.new(...)
    local o = {}
    setmetatable(o, M)
    M.init(o, ...)
    return o
end

function M:init(id, game_id, player_info)
    self.id = id
    self.game_id = game_id
    self.owner_account = player_info.account
    self.player_list = {player_info}
    self.ready = false
    self.getting_area = false
end

function M:add(player_info)
    table.insert(self.player_list, player_info)
    if #self.player_list == 4 then
        print("房间凑齐了四个人")
        self.ready = true
        G.room_mgr:add_ready(self)
    end
end

function M:start()
    print("开启一桌")
    local area = skynet.call("area_mgr", "lua", "get_area", self.game_id)
    self.getting_area = true
    skynet.send(area.addr, "lua", "create_room", self:pack())
end

function M:pack()
    return {
        id = self.id,
        owner_account = self.owner_account,
        player_list = self.player_list
    }
end

return M
