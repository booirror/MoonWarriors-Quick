local Explosion = class("Explosion", function()
    return display.newSprite("#explosion_01.png")
end)

local GameConfig = require("src.app.GameConfig")

function Explosion:ctor()
    self.tmpWidth = 0
    self.tmpHeight = 0
    self.active = true
    
    local sz = self:getContentSize()
    self.tmpWidth = sz.width
    self.tmpHeight = sz.height
    self.animation = display.getAnimationCache("Explosion")
    self:setBlendFunc(gl.SRC_ALPHA, gl.ONE)
end

function Explosion:play()
    local anim = cc.Animate:create(self.animation)
    local call = cc.CallFunc:create(handler(self, self.destroy))
    self:runAction(cc.Sequence:create({anim, call}))
end

function Explosion:destroy()
    self:setVisible(false)
    self.active = false
    self:stopAllActions()
end

function Explosion:sharedExplosion()
    local frames = display.newFrames("explosion_%02d.png", 1, 35)
    local anim = display.newAnimation(frames, 0.04)
    display.setAnimationCache("Explosion", anim)
end

function Explosion:activate()
    self.active = true
    self:setVisible(true)
end

function Explosion:getAvailible()
    local con = GameConfig.container.explosions
    for i=1, #con do
        local exp = con[i]
        if exp.active == false then
            return exp
        end
    end
    return nil
end

function Explosion:show(parent)
    local exp = self:getAvailible()
    if exp == nil then
        exp = self:create(parent)
    end
    exp:activate()
    exp:play()
    return exp
end

function Explosion:create(parent)
    local exp = self.new()
    parent:addExplosions(exp)
    table.insert(GameConfig.container.explosions, exp)
    return exp
end

function Explosion:preLoad(parent)
    local exp = nil
    for i = 0, 6 do
        exp = self:create(parent)
        exp:destroy()
    end
end

return Explosion
