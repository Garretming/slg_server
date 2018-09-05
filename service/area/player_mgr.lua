local M = {}

function M:init()
    self.player_tbl = {}
end

function M:add(player)
    self.player_tbl[player.id] = player
end

function M:remove(id)
    self.player_tbl[id] = nil
end

return M
