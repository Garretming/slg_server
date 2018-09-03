local skynet = require "skynet"

local M = {}

function M:init()
    self.account_tbl = {}
end

function M:register(info)
    if self.account_tbl[info.account] then
        return {err = "account exist"}
    end

    local acc = {
        account = info.account,
        password = info.password,
        nickname = tostring(os.time())
    }

    self.account_tbl[info.account] = acc

    skynet.send("mongo", "lua", "create", acc)
    return {
        err = "success",
    }
end

function M:login(info)
    local acc = self.account_tbl[info.account]
    if not acc then
        return {err="account not exist"}
    end

    if acc.password ~= info.password then
        return {err="wrong password"}
    end

    return {
        err = "success"
    }
end

return M
