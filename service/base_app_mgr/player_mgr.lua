local M = {}

function M:init()
    self.player_tbl = {}
end

function M:get_player_info(id)
    return self.player_tbl[id]
end

function M:add_player(player)
    self.player_tbl[player.id] = player
end

function M:remove_player(id)
    self.player_tbl[id] = nil
end

return M
