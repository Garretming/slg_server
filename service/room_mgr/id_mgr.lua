local game_list = require "game_list"
local id_mgr = {}

function id_mgr:init()
    math.randomseed(os.time())
    self.tbl =  {}
    for i = 1, 999999 do
        self.tbl[i] = i
    end

    -- self.game_map_room_id = {}
    -- for _, game in pairs(game_list) do
    --     self.game_map_room_id[game.id] = {}
    -- end

    -- self.room_id_map_game = {}
end

function id_mgr:gen_id(game_id)
    local len = #self.tbl 
    local index = math.random(1, len)
    local ret_id = self.tbl[index]
    self.tbl[index] = self.tbl[len]
    self.tbl[len] = nil

    -- table.insert(self.game_map_room_id[game_id], ret_id)
    -- self.room_id_map_game[ret_id] = game_id

    return ret_id
end

return id_mgr
