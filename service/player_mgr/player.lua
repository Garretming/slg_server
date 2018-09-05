local M = {}

M.__index = M

function M.new(...)
    local o = {}
    setmetatable(o, M)
    o:init(...)
end

function M:init(...)

end

return
