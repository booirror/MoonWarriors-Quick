local Effect = {}

function Effect:createFlare(callback)
    local flare = cc.Sprite:create(res.jpg_fire)
    flare:setBlendFunc(gl.SRC_ALPHA, gl.ONE)
    flare:setOpacity(0)
    flare:setRotation(-120)
    flare:setScale(0.2)
    
    local opacityAnim = cc.FadeTo:create(0.5, 255)
    local opacDim = cc.FadeTo:create(1, 0)
    local biggeAnim = cc.ScaleBy:create(0.7, 1.2, 1.2)
    local biggerEase = cc.EaseSineOut:create(biggeAnim)
    local moveAnim = cc.MoveBy:create(0.5, cc.p(328, 0))
    local easeMove = cc.EaseSineOut:create(moveAnim)
    local rotateAnim = cc.RotateBy:create(2.5, 90)
    local rotateEase = cc.EaseExponentialOut:create(rotateAnim)
    local bigger = cc.ScaleTo:create(0.5, 1)
    
    local onComplete = cc.CallFunc:create(callback)
    local killflare = cc.CallFunc:create(function()
        flare:removeFromParent()
    end)
    
    flare:runAction(cc.Sequence:create({opacityAnim, biggerEase, opacDim, killflare, onComplete})) 
    flare:runAction(easeMove)
    flare:runAction(rotateEase)
    flare:runAction(bigger)
    return flare
end

return Effect