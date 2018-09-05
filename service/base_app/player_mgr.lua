local M = {}

function M:init()
    self.player_tbl = {}
    self.fd_2_player = {}
end

function M:get_by_account(account)
    return self.player_tbl[account]
end

function M:get_by_fd(fd)
    return self.fd_2_player[fd]
end

function M:add(obj)
    self.player_tbl[obj.account] = obj
    self.fd_2_player[obj.fd] = obj
end

function M:remove(obj)
    self.player_tbl[obj.account] = nil
    self.fd_2_player[obj.fd] = nil
end

return M


