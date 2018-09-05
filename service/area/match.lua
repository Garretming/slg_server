--状态定义

-- dealt 发牌
-- get_card 摸牌
-- pong 碰
-- kong 杠
-- chow 吃
-- out_card 打出牌

local mjlib = require "base.mjlib"
local utils = require "utils"

local M = {}

M.__index = M

function M.new(...)
    local o = {}
    setmetatable(o, M)
    M.init(o, ...)
    return o
end

function M:init(room)
    self.room = room
    self.cards = {}

    self.active_seat = 1
    self.players = {}
    for i=1,4 do
        self.players[i] = self:init_player(i)
    end

    utils.print(self.players)
end

function M:init_player(i)
    local info = {
        seat = i,
        stand_cards = {},
        waves = {},
        active = false,
    }
    return info
end

function M:begin()
    -- 洗牌
    self.cards = mjlib.create(true)
    self.cards_num = #self.cards
    -- 每人发13张牌
    for i=1,4 do
        self:dealt_card(self.players[i].stand_cards, 13)
    end
    self.status = "dealt"

    for i=1,4 do
        local msg = {
            cards = self.players[i].cards
        }
        self.room:send_client(i, "match.dealt", msg)
    end
end

function M:dealt_card(tbl, num)
    self.cards_num = self.cards_num - num
    for _=1,34 do
        table.insert(tbl, 0)
    end

    for i=1,num do
        local index = self.cards[self.cards_num + i]
        tbl[index] = tbl[index] + 1
    end
end

function M:get_card()
    local player = self.players[self.active_seat]

    local card = self.cards[self.card_num]
    player.stand_card[card] = player.stand_card[card] + 1
    self.card_num = self.card_num - 1
end

function M:out_card(card)
    local player = self.players[self.active_seat]
    player.stand_card[card] = player.stand_card[card] - 1
    self.status = "out_card"
end

return M
