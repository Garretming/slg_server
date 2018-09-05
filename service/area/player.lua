local M = {}

M.__index = M

function M.new(...)
    local o = {}
    setmetatable(o, M)

    M.init(o, ...)
    return o
end

function M:init(id, name)
    self.id = id
    self.name = name
end

function M:start_game(cards)
    self:stand_card = {}
    self:wave_list = {}
end

return M


