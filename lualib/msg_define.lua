local MsgDefine = {}

local _idTbl = {

    -- 登陆协议
    {name = "login.login"},
    {name = "login.register"},
    -- baseapp登陆
    {name = "login.login_baseapp"},
    {name = "room.create_room"},
    {name = "room.join_room"},
    {name = "room.room_begin"},
    {name = "match.dealt"}
}

local _nameTbl = {}

for id, v in ipairs(_idTbl) do
    _nameTbl[v.name] = id
end

function MsgDefine.nameToId(name)
    return _nameTbl[name]
end

function MsgDefine.idToName(id)
    local v = _idTbl[id]
    if not v then
        return
    end

    return v.name
end

function MsgDefine.getNameById(id)
    return _idTbl[id]
end

function MsgDefine.getIdByName(name)
    local id = _nameTbl[name]
    return _idTbl[id]
end

return MsgDefine
