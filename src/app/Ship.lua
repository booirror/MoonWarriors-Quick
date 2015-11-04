local Bullet = require("src.app.Bullet")
local Explosion = require("src.app.Explosion")
local GameConfig = require("src.app.GameConfig")
local scheduler = require("src.framework.scheduler")

local Ship = class("Ship", function()
    return display.newSprite("#ship01.png")
end)

function Ship:ctor(parent)
    self.speed = 220
    self.bulletSpeed = GameConfig.bulletSpeed.ship
    self.hp = 5
    self.bulletTypeValue = 1
    self.bulletPowerValue = 1
    self.throwBombing = false
    self.canBeAttack = true
    self.isThrowingBomb = false
    self.zOrder = 3000
    self.maxBulletPowerValue = 4
    self.appearPosition = cc.p(160, 60)
    self.hurtColorLife = 0
    self.active = true
    self.bornSprite = nil
    self.timeTick = 0
    
    self:setPosition(self.appearPosition)
    parent:addChild(self, self.zOrder, GameConfig.unitTag.player)
    local frames = display.newFrames("ship%02d.png", 1, 2)
    local animation = display.newAnimation(frames,0.1)
    local animate = cc.Animate:create(animation)
    self:runAction(cc.RepeatForever:create(animate))
    
    self:initBornSprite()
    self:born()
    self:setBlendFunc(gl.SRC_ALPHA, gl.ONE)
end

function Ship:shoot(dt)
    local offset = 13
    local x, y = self:getPosition()
    local cs = self:getContentSize()
    local b = Bullet:showByShip(self:getParent())
    b:setPosition(x+offset, y + 3 + cs.height*0.3)
    local b = Bullet:showByShip(self:getParent())
    b:setPosition(x-offset, y + 3 + cs.height*0.3)
end

function Ship:destroy()
    GameConfig.life = GameConfig.life - 1
    scheduler.unscheduleGlobal(self.schedluer)
    local explosion = Explosion:show(self:getParent():getParent())
    explosion:setPosition(self:getPosition())
    if (GameConfig.sound) then
        audio.playSound(res.mp3_shipDestroyEffect)
    end
end

function Ship:hurt()
    if self.canBeAttack then
        self.hurtColorLife = 2
        self.hp = self.hp - 1
    end
end

function Ship:update(dt)
    if self.hp <= 0 then
        self.active = false
        self:destroy()
    end
    self.timeTick = self.timeTick + dt
    if self.timeTick > 0.1 then
        self.timeTick = 0
        if self.hurtColorLife > 0 then
            self.hurtColorLife = self.hurtColorLife - 1
        end
    end
end

function Ship:collideRect()
    local x, y = self:getPosition()
    local a = self:getContentSize()
    return cc.rect(x - a.width/2,y - a.height/2,a.width,a.height/2)
end

function Ship:initBornSprite()
    self.bornSprite = display.newSprite("#ship03.png")
    self.bornSprite:setPosition(self:getContentSize().width / 2, 12)
    self.bornSprite:setVisible(false)
    self:addChild(self.bornSprite, 3000, 99999)
end

function Ship:born()
    self.canBeAttack = false
    self.bornSprite:setScale(0)
    self.bornSprite:runAction(cc.ScaleTo:create(0.5,1,1))
    self.bornSprite:setVisible(true)
    local blink = cc.Blink:create(3, 9)
    local makeBeAttack = cc.CallFunc:create(function()
        self.canBeAttack = true
        self:setVisible(true)
        self.bornSprite:setVisible(false)
    end)
    local dt = cc.DelayTime:create(0.5)
    self:runAction(cc.Sequence:create({dt, blink, makeBeAttack}))
    self.hp = 5
    self.hurtColorLife = 0
    self.active = true
    self.schedluer = scheduler.scheduleGlobal(handler(self, self.shoot), 1/6)
end

return Ship