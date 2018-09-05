local M = {}

function M:init()
    self.token_tbl = {}
end

function M:get(account)
    local t = self.token_tbl[account]
    if not t then
        return nil
    end

    if os.now() - t.time > 3600 then
        return nil
    end

    return t.token
end

function M:gen(account)
    local t = {
        token = math.random(1000000,99999999),
        time = os.time()
    }

    self.token_tbl[acount] = t
    return t.token
end

function M:verify(account, token)
    local t = self.token_tbl[account]
    if not then
        return false
    end

    if os.now() - t.time > 3600 then
        return false
    end

    return t.token == token
end

return
