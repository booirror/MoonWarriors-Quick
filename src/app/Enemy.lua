local EnemyType = require("src.app.EnemyType")
local Bullet = require("src.app.Bullet")
local Explosion = require("src.app.Explosion")
local SparkEffect = require("src.app.SparkEffect")
local scheduler = require("src.framework.scheduler")
local GameConfig = require("src.app.GameConfig")

local Enemy = class("Enemy", function()
    return display.newSprite()
end)

function Enemy:ctor(args)
    self.id = 0
    self.enemyType = 1
    self.active = true
    self.speed = 200
    self.bulletSpeed = GameConfig.bulletSpeed.enemy
    self.hp = 15
    self.bulletPowerValue = 1
    self.moveType = nil
    self.scoreValue = 200
    self.zOrder = 100
    self.delayTime = 1+1.2*math.random()
    self.attackMode = GameConfig.enemyAttackMode.normal
    self.hurtColorLife = 0
    self.hp = args.HP
    self.moveType = args.moveType
    self.scoreValue = args.scoreValue
    self.attackMode = args.attackMode
    self.enemyType = args.type
    self.timeTick = 0
    
    self:setSpriteFrame(display.newSpriteFrame(args.textureName))
    self.timer = scheduler.scheduleGlobal(handler(self, self.shoot), self.delayTime)
    self:scheduleUpdate()
    self:setBlendFunc(gl.SRC_ALPHA, gl.ONE)
    self:addNodeEventListener(cc.NODE_EVENT, function(event)
        if event.name == "exit" then
            scheduler.unscheduleGlobal(self.timer)
            self.timer = nil
        end
    end)
end

function Enemy:destroy()
    GameConfig.score = GameConfig.score + self.scoreValue
    local a = Explosion:show(self:getParent():getParent())
    local x, y = self:getPosition()
    a:setPosition(x, y)
    SparkEffect:show(self:getParent():getParent(), x, y)
    if GameConfig.sound then
        audio.playSound(res.mp3_explodeEffect)
    end
    
    self:setVisible(false)
    self.active = false
    self:stopAllActions()
    scheduler.unscheduleGlobal(self.timer)
    GameConfig.activeEnemies = GameConfig.activeEnemies - 1
end

function Enemy:update(dt)
    if self.active == false then return end
    local x, y = self:getPosition()
    if ((x < 0 or x > 320) and (y < 0 or y > 480)) then
        self.active = false
    end
    self.timeTick = self.timeTick + dt
    if (self.timeTick > 0.1) then
        self.timeTick = 0
        if (self.hurtColorLife > 0) then
            self.hurtColorLife = self.hurtColorLife - 1 
        end
    end

    x, y = self:getPosition()
    local g_sharedGameLayer = self:getParent():getParent()
    if (x < 0 or x > g_sharedGameLayer.screenRect.width 
        or y < 0 or y > g_sharedGameLayer.screenRect.height 
        or self.hp <= 0) then
        self.active = false
        self:destroy()
    end
end

function Enemy:shoot()
    local x, y = self:getPosition()
    local b = Bullet:showByEnemy(self:getParent())
    b:setPosition(x, y - self:getContentSize().height * 0.2)
end

function Enemy:hurt()
    self.hurtColorLife = 2
    self.hp = self.hp - 1
end

function Enemy:attack()
    local e = self
    local p = cc.p(80 + (display.width - 160)*math.random(), display.height)
    local esize = e:getContentSize()
    e:setPosition(p)

    local x, y, offset, tmpAction
    local a0, a1 = 0, 0
    local fire = cc.CallFunc:create(handler(self, self.shoot))
    if e.moveType == GameConfig.enemyMoveType.attack then
        x, y = self:getParent():getParent().ship:getPosition()
        tmpAction = cc.Sequence:create({cc.MoveTo:create(1, cc.p(x, y)), fire})
    elseif e.moveType == GameConfig.enemyMoveType.vertical then
        offset = cc.p(0, -display.height - esize.height)
        tmpAction = cc.Sequence:create({cc.MoveBy:create(4, offset), fire})
    elseif e.moveType == GameConfig.enemyMoveType.horizontal then
        offset = cc.p(0, -100 - 200*math.random())
        a0 = cc.MoveBy:create(0.5, offset)
        a1 = cc.MoveBy:create(1, cc.p(-50 - 100 * math.random(), 0))
        local onComplete = cc.CallFunc:create(function(ps)
            local a2 = cc.DelayTime:create(1)
            local a3 = cc.MoveBy:create(1, cc.p(100+100*math.random(), 0))
            local seq = cc.Sequence:create({a2, a3, a2:clone(), a3:reverse()})
            ps:runAction(cc.RepeatForever:create(seq))
        end)
        tmpAction = cc.Sequence:create({a0, fire, a1, onComplete})
    elseif e.moveType == GameConfig.enemyMoveType.overlap then
        local newX = p.x <= display.width /2 and 320 or -320
        a0 = cc.MoveBy:create(4, cc.p(newX, -240))
        a1 = cc.MoveBy:create(4, cc.p(-newX, -320))
        tmpAction = cc.Sequence:create({a0, a1, fire})
    end
    e:runAction(tmpAction)
end

function Enemy:collideRect()
    local x, y = self:getPosition()
    local a = self:getContentSize()
    return cc.rect(x - a.width / 2, y - a.height / 4, a.width, a.height / 2+20)
end

function Enemy:getAvailable(args)
    local es = GameConfig.container.enemies
    local one = nil
    for i =1, #es do
        one = es[i]
        if one.active == false and one.enemyType == args.type then
            one.hp = args.HP
            one.active = true
            one.moveType = args.moveType
            one.scoreValue = args.scoreValue
            one.attackMode = args.attackMode
            one.hurtColorLife = 0
            
            one.timer = scheduler.scheduleGlobal(handler(one, one.shoot), one.delayTime)
            one:setVisible(true)
            return  one
        end
    end
    return nil
end

function Enemy:show(parent, args)
    local enmey = nil
    enmey = Enemy:getAvailable(args)
    if enmey == nil then
        enmey = self:create(parent, args)
    end
    GameConfig.activeEnemies = GameConfig.activeEnemies + 1
    return enmey
end


function Enemy:create(parent, args)
    local enemy = self.new(args)
    parent:addEnemy(enemy, enemy.zOrder, GameConfig.unitTag.enemy)
    table.insert(GameConfig.container.enemies, enemy)
    return enemy
end

return Enemy