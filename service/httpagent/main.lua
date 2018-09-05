local skynet = require "skynet"
local socket = require "socket"
local httpd = require "http.httpd"
local sockethelper = require "http.sockethelper"
local cjson = require "cjson"
local utils = require "utils"

local function response(id, code, msg, ...)
    print("web返回")
    utils.print(msg)
    local data = cjson.encode(msg)
    local ok, err = httpd.write_response(sockethelper.writefunc(id), code, data, ...)
    if not ok then
        -- if err == sockethelper.socket_error , that means socket closed.
        skynet.error(string.format("fd = %d, %s", id, err))
    end
end

local function login_lobby(id, msg)
    local ret = skynet.call("player_mgr", "lua", "login_lobby", msg)
    response(id, 200, ret)
end

-- 创建房间
local function create_room(id, msg)
    local ret = skynet.call("player_mgr", "lua", "create_room", msg)
    response(id, 200, ret)
end

-- 加入房间
local function join_room(id, msg)
    local ret = skynet.call("player_mgr", "lua", "join_room", msg)
    response(id, 200, ret)
end

local function handle(id)
    socket.start(id)
    -- limit request body size to 8192 (you can pass nil to unlimit)
    local code, url, _, _, body = httpd.read_request(sockethelper.readfunc(id), 128)
    print(code, url, body)
    if not code or code ~= 200 then
        return
    end

    local msg = cjson.decode(body)
    if url == "/login_lobby" then
        login_lobby(id, msg)
    elseif url == "/create_room" then
        create_room(id, msg)
    elseif url == "/join_room" then
        join_room(id, msg)
    end
end

skynet.start(function()
    skynet.dispatch("lua", function (_,_,id)
        handle(id)
        socket.close(id)
        -- if not pcall(handle, id) then
        --    response(id, 200, "{\"msg\"=\"exception\"}")
        -- end
    end)
end)
