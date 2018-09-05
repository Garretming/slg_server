local sock_mgr = require "sock_mgr"

local handler_tbl = {"room", "game"}

local M = {}

function M.init_handler(name)
    local m = require ("msg_handler."..name)
    if not m then
        return
    end

    for func_name,func in pairs(m) do
        sock_mgr:register_callback(name.."."..func_name, func)
    end
end

function M.init()
    for _,name in ipairs(handler_tbl) do
        M.init_handler(name)
    end
end

return M
