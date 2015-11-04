local MenuScene = class("MenuScene", function()
    return display.newScene("MenuScene")
end)

local Effect = require("app.Effect")
local GameConfig = require("app.GameConfig")

function MenuScene:ctor()
    self:init()
end

function MenuScene:onEnter()

end

function MenuScene:onExit()

end

function MenuScene:init()
    display.addSpriteFrames(res.textureTransparentPack_plist, res.textureTransparentPack_png)
    local bg = display.newSprite(res.png_loading)
    bg:setAnchorPoint(0,0)
    local size = bg:getContentSize()
    bg:setScaleY(display.height / size.height)
    self:addChild(bg, 0, 1)
    
    self.logo = display.newSprite(res.png_logo, 0, display.height - 230)
    self.logo:setAnchorPoint(0, 0)
    self:addChild(self.logo, 10, 1)
    
    local newGameNormal = cc.Sprite:create(res.png_menu, cc.rect(0, 0, 126, 33))
    local newGameSelected = cc.Sprite:create(res.png_menu, cc.rect(0, 33, 126, 33))
    local newGameDisabled = cc.Sprite:create(res.png_menu, cc.rect(0, 66, 126, 33))
    
    local gameSettingNormal = cc.Sprite:create(res.png_menu, cc.rect(126, 0, 126, 33))
    local gameSettingSelected = cc.Sprite:create(res.png_menu, cc.rect(126, 33, 126, 33))
    local gameSettingDisabled = cc.Sprite:create(res.png_menu, cc.rect(126, 66, 126, 33))
    
    local aboutNormal = cc.Sprite:create(res.png_menu, cc.rect(252, 0, 126, 33))
    local aboutSelected = cc.Sprite:create(res.png_menu, cc.rect(252, 33, 126, 33))
    local aboutDisabled = cc.Sprite:create(res.png_menu, cc.rect(252, 66, 126, 33))
    
    
    local newGame = cc.MenuItemSprite:create(newGameNormal,newGameSelected,newGameDisabled)
    newGame:registerScriptTapHandler(function()
        self:onButtonEffect()
        newGame:setEnabled(false)
        local flare = Effect:createFlare(handler(self,self.onNewGame))
        flare:setPosition(-30, display.height-(480-297))
        flare:setVisible(true)
        self:addChild(flare)
    end)
    
    local gameSetting = cc.MenuItemSprite:create(gameSettingNormal,gameSettingSelected,gameSettingDisabled)
    gameSetting:registerScriptTapHandler(function()
        self:onSettings()
    end)
    
    local about = cc.MenuItemSprite:create(aboutNormal,aboutSelected,aboutDisabled)
    about:registerScriptTapHandler(function()
        self:onAbout()
    end)
    local menu = cc.Menu:create()
    menu:addChild(newGame)
    menu:addChild(gameSetting)
    menu:addChild(about)
    menu:alignItemsVerticallyWithPadding(10)
    
    menu:setPosition(display.cx, display.cy-80)
    self:addChild(menu, 1, 2)
    
    self:schedule(handler(self, self.update), 0.1)
    
    self.ships = {}
    local ship = display.newSprite("#ship01.png")
    ship:setAnchorPoint(0, 0)
    local pos = cc.p(math.random()*display.width, 0)
    ship:setPosition(pos)
    self:addChild(ship, 0, 4)
    ship:runAction(cc.MoveBy:create(2,cc.p(math.random()* display.width, pos.y + display.height + 100)))
    self.ships[#self.ships+1] = ship
    
    local ship2 = display.newSprite("#ship02.png")
    ship2:setPosition(0,display.height+10)
    self:addChild(ship2)
    self.ships[#self.ships+1] = ship2
    
    if GameConfig.sound then
        audio.setMusicVolume(0.7)
        audio.playMusic(res.mp3_mainMusic, true)
    end
end

function MenuScene:onNewGame(psender)
    
    app:enterScene("MainScene", nil, "fade", 1.2)
end

function MenuScene:onSettings(psender)
    self:onButtonEffect()
    app:enterScene("SettingsScene", nil, "fade", 1.2)
end

function MenuScene:onAbout(psender)
    self:onButtonEffect()
    app:enterScene("AboutScene", nil, "fade", 1.2)
end

function MenuScene:onButtonEffect()
    if GameConfig.sound then
        audio.playSound(res.mp3_btnEffect)
    end
end

function MenuScene:update()
    for k, ship in ipairs(self.ships) do
        if ship:getPositionY() > display.height then
            local pos = cc.p(math.random() * display.width, 10)
            ship:setPosition(pos)
            ship:runAction(cc.MoveBy:create(5*math.random(), cc.p(math.random()*display.width, pos.y + display.height)))
        end
    end
end

return MenuScene
