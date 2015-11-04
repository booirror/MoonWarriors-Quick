local HitEffect = class("HitEffect", function()
    return display.newSprite("#hit.png")
end)

local GameConfig = require("src.app.GameConfig")

function HitEffect:ctor()
    self.active = true
    self:setBlendFunc(gl.SRC_ALPHA, gl.ONE)
end

function HitEffect:play(x, y, roatation, scale)
    self:setPosition(x, y)
    self:setRotation(roatation)
    self:setScale(scale)
    self:setOpacity(255)
    self:runAction(cc.ScaleBy:create(0.3, 2, 2))
    local fout = cc.FadeOut:create(0.3)
    local call = cc.CallFunc:create(handler(self, self.destroy))
    self:runAction(cc.Sequence:create({fout, call}))
end

function HitEffect:destroy()
    self:setVisible(false)
    self.active = false
end

function HitEffect:show(parent, x, y, rotation, scale)
    local effect = nil
    local hits = GameConfig.container.hits
    for i = 1, #hits do
        effect = hits[i]
        if effect.active == false then
            effect:setVisible(true)
            effect.active = true
            effect:play(x, y, rotation, scale)
            return effect
        end
    end
    effect = self:create(parent)
    effect:play(x, y, rotation, scale)
    return effect
end

function HitEffect:create(parent)
    local effect = self.new()
    parent:getParent():addBulletHits(effect, GameConfig.order_effect)
    table.insert(GameConfig.container.hits, effect)
    return effect
end

function HitEffect:preLoad(parent)
    for i = 1, 10 do
        local hit = self:create(parent)
        hit:destroy()
    end
end

return HitEffect