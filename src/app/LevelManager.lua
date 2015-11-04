local LevelConfig = require("src.app.LevelConfig")
local Enemy = require("src.app.Enemy")
local EnemyType = require("src.app.EnemyType")
local GameConfig = require("src.app.GameConfig")

local LevelManager = class("LevelManager")

function LevelManager:ctor(game)
    if not game then
        return
    end
    self.layer = game
    self:setLevel(LevelConfig.Level1)
end

function LevelManager:setLevel(level)
    local e = level.enemies
    for i = 1, #level.enemies do
        e[i].showTime = self:minuteToSecond(e[i].showTime)
    end
    self.currentLevel = level
end

function LevelManager:minuteToSecond(m)
    if not m then
        return 0
    end
    if type(m) ~= "number" then
        local mins = m:split(':')
        if #mins == 1 then
            return tonumber(mins[1])
        else
            return tonumber(mins[1]*60 + tonumber(mins[2]))
        end
    else
        return m
    end
end

function LevelManager:loadLevelResource(dt)
    if GameConfig.activeEnemies >= self.currentLevel.enemyMax then
        return
    end
    local level = self.currentLevel
    for i=1, #level.enemies do
        local e = level.enemies[i]
        if e then
            if e.showType == "Once" then
                if e.showTime == dt then
                    for i = 1, #e.types do
                        self:addEnemyToGame(e.types[i])
                    end
                end
            elseif e.showType == "Repeate" then
                if dt % e.showTime == 0 then
                    for i = 1, #e.types do
                        self:addEnemyToGame(e.types[i])
                    end
                end
            end
        end
    end
end

function LevelManager:addEnemyToGame(type)
    local e = Enemy:show(self.layer, EnemyType[type])
    e:attack()
end


return LevelManager
