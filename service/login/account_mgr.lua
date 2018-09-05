local skynet = require "skynet"
local MongoLib = require "mongolib"
local utils = require "utils"

local mongo_host = "127.0.0.1"
local mongo_db = "herochess"

local dbconf = {
    host = "127.0.0.1",
    port = 27017,
   db="test",
   username="clark",
   password="clark",
--    authmod="mongodb_cr"
}

local M = {}

function M:init()
    self.mongo = MongoLib.new()
    self.mongo:connect(dbconf)
    self.mongo:use(mongo_db)
    self.account_tbl = {}
    self:load_all()
end

function M:load_all()
    local it = self.mongo:find("account",{},{_id = false})

    if not it then
        return
    end

    while it:hasNext() do
        local obj = it:next()
        self.account_tbl[obj.account] = obj
    end
end

function M:get_by_account(account)
    return self.account_tbl[account]
end

-- 验证账号密码
function M:verify(account, passwd)
    local info = self.account_tbl[account]
    if not info then
        return false, "account not exist"
    end

    if info.passwd ~= passwd then
        return false, "wrong password"
    end

    return true
end

-- 注册账号
function M:register(account, passwd)
    if self.account_tbl[account] then
        return false, "account exists"
    end

    local info = {account = account, passwd = passwd}
    self.account_tbl[account] = info
    self.mongo:insert("account", info)

    return true
end

return M
