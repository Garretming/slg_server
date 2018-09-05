local utils = require "utils"

local M = {}

-- 组包
function M.pack(id, msg)
    local msg_str = utils.table_2_str(msg)
    local len = 2 + 2 + #msg_str
    local data = string.pack(">HHs2", len, id, msg_str)
    return data
end

-- 拆包
function M.unpack(data)
    local id, params = string.unpack(">Hs2", data)

    params = utils.str_2_table(params)

    return id, params
end

return M
