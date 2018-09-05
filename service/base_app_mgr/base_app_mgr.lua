local skynet = require "skynet"

local M = {}

function M:init()
    self.base_app_tbl = {}
end

-- 创建baseapp
function M:create_base_apps()
    for i = 1, 2 do
        local addr = skynet.newservice("base_app", i)
        local info = {
            addr = addr,
            port = 16800 + i
        }

        self.base_app_tbl[addr] = info
    end
end

function M:start_base_apps()
    for _,v in pairs(self.base_app_tbl) do
        skynet.call(v.addr, "lua", "start", {
            port = v.port,
            maxclient = 1000,
            nodelay = true,
        })
    end
end

function M:get_base_app_info(addr)
    return self.base_app_tbl[addr]
end

function M:get_base_app_tbl()
    return self.base_app_tbl
end

return M
