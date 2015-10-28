local AboutScene = class("AboutScene", function()
    return display.newScene("AboutScene")
end)

function AboutScene:ctor()
    self:init()
end

function AboutScene:init()
    local bg = display.newSprite(res.png_loading)
    bg:setAnchorPoint(0, 0)
    local size = bg:getContentSize()
    bg:setScaleY(display.height/size.height)
    self:addChild(bg, 0, 1)
    
    local title = cc.Sprite:create(res.png_menuTitle, cc.rect(0, 36, 100, 34))
    title:setPosition(display.cx, display.height - 60)
    self:addChild(title)
    
    local text = "MoonWarriors quick版\n只有游戏才能让人类自由"
        
    
    local about = cc.Label:create()
    about:setString(text)
    about:setPosition(display.cx,display.cy)
    about:setAnchorPoint(0.5,0.5)
    about:setSystemFontSize(26)
    self:addChild(about)
    
    local btitle = cc.Label:create()
    btitle:setString("Go back")
    btitle:setSystemFontSize(25)
    local back = cc.MenuItemLabel:create(btitle)
    back:setAnchorPoint(cc.p(0.5, 0))
    back:registerScriptTapHandler(handler(self,self.onBack))
    back:setPosition(display.cx, 40)
    local menu = cc.Menu:create()
    menu:setPosition(0,0)
    menu:addChild(back)
    self:addChild(menu)

end

function AboutScene:onBack(psender)
    app:enterScene("MenuScene", nil, "fade", 1.2)
end

return AboutScene