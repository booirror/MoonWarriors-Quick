local GameOverScene = class("GameOverScene", function()
    return display.newScene("GameOverScene")
end)

local GameConfig = require("src.app.GameConfig")
local Effect = require("app.Effect")

function GameOverScene:ctor()
    self:init()
end

function GameOverScene:init()
    local bg = cc.Sprite:create(res.png_loading)
    bg:setPosition(display.cx, display.cy)
    self:addChild(bg)
    
    local flare = display.newSprite(res.jpg_fire)
    flare:setVisible(false)
    self:addChild(flare)
    
    local logo = display.newSprite(res.png_gameover)
    logo:setPosition(0, display.height-180)
    logo:setAnchorPoint(0, 0)
    self:addChild(logo, 10, 1)
    
    local lbscore = cc.Label:create()
    lbscore:setString(""..GameConfig.score)
    lbscore:setSystemFontSize(30)
    lbscore:setColor(cc.c3b(250, 179, 0))
    lbscore:setPosition(160, display.height-200)
    self:addChild(lbscore, 10)
    
    local playAgainNormal = cc.Sprite:create(res.png_menu, cc.rect(378, 0, 126, 33))
    local playAgainSelected = cc.Sprite:create(res.png_menu, cc.rect(378, 33, 126, 33))
    local playAgainDisabled = cc.Sprite:create(res.png_menu, cc.rect(378, 33 * 2, 126, 33))
    
    local play = cc.MenuItemSprite:create(playAgainNormal,playAgainSelected, playAgainDisabled)
    play:registerScriptTapHandler(function()
        local flare = Effect:createFlare(handler(self,self.onNewGame))
        flare:setPosition(-30, display.height-(480-297))
        flare:setVisible(true)
        self:addChild(flare)
        app:enterScene("MainScene", nil, "fade", 1.2)
    end)
    play:setPosition(display.cx, display.height-260)
    local menu = cc.Menu:create()
    menu:setPosition(0,0)
    menu:addChild(play)
    self:addChild(menu, 1, 2)
    
    local coco = display.newSprite(res.quick_png)
    coco:setPosition(160, display.height-330)
    self:addChild(coco, 10)
    
    if GameConfig.sound then
        audio.playMusic(res.mp3_mainMusic)
    end
end

function GameOverScene:onNewGame(pSender)
    app:enterScene("MainScene", nil, "fade", 1.2)
end

return GameOverScene