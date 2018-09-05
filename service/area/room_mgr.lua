-- 房间管理器
local M = {}

function M:init()
    self.tbl = {}
end

function M:get(id)
    return self.tbl[id]
end

function M:add(obj)
    self.tbl[obj.id] = obj
end

function M:remove(obj)
    self.tbl[obj.id] = nil
end

return M
