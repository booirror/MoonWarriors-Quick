local HitEffect = require("src.app.HitEffect")
local GameConfig = require("src.app.GameConfig")
local Bullet = class("Bullet", function()
    return display.newSprite()
end)

function Bullet:ctor(speed, type, mode)
    self.active = true
    self.vX = 0
    self.vY = 200
    self.power = 1
    self.hp = 1
    self.moveType = nil
    self.zOrder = 3000
    self.attackMode = GameConfig.enemyAttackMode.normal
    self.parentType = GameConfig.bulletType.player
    self.vY = -speed
    self.attackMode = mode
    self:setSpriteFrame(display.newSpriteFrame(type))
    self:setBlendFunc(gl.SRC_ALPHA, gl.ONE)
end

function Bullet:update(dt)
    local x, y = self:getPosition()
    self:setPosition(x - self.vX*dt, y - self.vY*dt)
    if x < 0
        or x > display.width
        or y < 0
        or y > display.height
        or self.hp <= 0 then
        self:destroy()
        self:explodeEffect()
    end
end

function Bullet:hurt()
    self.hp = self.hp - 1
end

function Bullet:explodeEffect()
    local x, y = self:getPosition()
    local explode = HitEffect:show(self:getParent(),x,y, math.random()*360, 0.75)
end

function Bullet:destroy()
    self.active = false
    self:setVisible(false)
end

function Bullet:collideRect()
    local x, y = self:getPosition()
    return cc.rect(x-3, y-3, 6, 6)
end

function Bullet:activate()
    self.active = true
    self.hp = 1
    self:setVisible(true)
end

function Bullet:findAvailable(mode)
    if mode == GameConfig.unitTag.playerBullet then
        local bv = GameConfig.container.playerBullets
        for i = 1, #bv do
            local b = bv[i]
            if b.active == false then
                b:activate()
                return b
            end
        end
    else
        local bv = GameConfig.container.enemyBullets
        for i = 1, #bv do
            local b = bv[i]
            if b.active == false then
                b:activate()
                return b
            end
        end
    end
    return nil
end

function Bullet:show(parent, speed, type, attackMode, zorder, mode)
    local bullet = nil
    bullet = self:findAvailable(mode)
    if not bullet then
        bullet = self:create(parent, speed, type, attackMode, zorder, mode)
    end
    return bullet
end

function Bullet:showByShip(parent)
    return self:show(parent, GameConfig.bulletSpeed.ship, "W1.png", GameConfig.enemyAttackMode.normal, 3000, GameConfig.unitTag.playerBullet)
end

function Bullet:showByEnemy(parent)
    return self:show(parent, GameConfig.bulletSpeed.enemy, "W2.png", GameConfig.enemyAttackMode.normal, 3000, GameConfig.unitTag.enemyBullet)
end

function Bullet:create(parent, speed, type, attackMode, zorder, mode)
    local b = self.new(speed, type, attackMode)
    b:activate()
    parent:getParent():addBullet(b, zorder, mode)
    if mode == GameConfig.unitTag.playerBullet then
        table.insert(GameConfig.container.playerBullets,b)
    else
        table.insert(GameConfig.container.enemyBullets,b)
    end
    return b
end

function Bullet:preLoad(parent)
    local bullet = nil
    for i = 1, 10 do
        local bullet = Bullet.create(parent, GameConfig.bulletSpeed.ship, "W1.png", GameConfig.enemyAttackMode.normal, 3000, GameConfig.unitTag.playerBullet)
        bullet:setVisible(false)
        bullet.active = false
    end
    for i = 1, 10 do
        bullet = Bullet.create(parent, GameConfig.bulletSpeed.enemy, "W2.png", GameConfig.enemyAttackMode.normal, 3000, GameConfig.unitTag.enemyBullet)
        bullet:setVisible(false)
        bullet.active = false
    end
end

return Bullet
