local mongo = require "skynet.db.mongo"

local M = {}

M.__index = M

function M.new()
    local o = {
        db = nil
    }
    setmetatable(o, M)
    return o
end

function M:connect(dbconf)
    self.conn = mongo.client(dbconf)
end

function M:use(db_name)
    self.conn:getDB(db_name)
    self.db = self.conn[db_name]
end

function M:find(coll_name, selector, fields)
    return self.db[coll_name]:find(selector, fields)
end

function M:find_one(coll_name, cond_tbl)
    return self.db[coll_name]:findOne(cond_tbl)
end

function M:insert(coll_name, obj)
    self.db[coll_name]:insert(obj)
end

return M
