local skynet = require "skynet"

local M = {}

function M:init()
    self.acc_tbl = {}
end

function M:get(account)
    return self.acc_tbl[account]
end

function M:add(obj)
    self.acc_tbl[obj.account] = obj
end

return M
