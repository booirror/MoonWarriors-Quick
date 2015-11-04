local LevelManager = require("src.app.LevelManager")
local Ship = require("src.app.Ship")
local Explosion = require "src.app.Explosion"
local Bullet = require "src.app.Bullet"
local Enemy = require "src.app.Enemy"
local HitEffect = require "src.app.HitEffect"
local SparkEffect = require "src.app.SparkEffect"
local GameConfig = require "src.app.GameConfig"
local scheduler = require("src.framework.scheduler")
local Background = require "src.app.Background"
local BackSky = Background.backSky
local BackTileMap = Background.backTileMap

local state = {playing = 0, gameover = 1}
local maxContaintWidth = 40
local maxContainHeight = 40


local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

function MainScene:ctor()
    self.time = 0
    self.ship = nil
    self.backSky = nil
    self.backSkyHeight = 0
    self.backSkyRe = nil
    self.levelManager = nil
    self.tmpScore = 0
    self.isBackSkyReload = false
    self.isBackTileReload = false
    self.lbScore = nil
    self.screenRect = nil
    self.explosionAnimation = {}
    self.beginPos = cc.p(0, 0)
    self.state = state.playing
    self.explosions = nil
    self.texOpaqueBatch = nil
    self.texTransparentBatch = nil
    self:init()
end

function MainScene:onEnter()
end

function MainScene:onExit()
end

function MainScene:resetData()
    GameConfig.container.enemies = {}
    GameConfig.container.enemyBullets = {}
    GameConfig.container.playerBullets = {}
    GameConfig.container.explosions = {}
    GameConfig.container.sparks = {}
    GameConfig.container.hits = {}
    GameConfig.container.backSkys = {}
    GameConfig.container.backitlemaps = {}
    GameConfig.activeEnemies = 0
    GameConfig.score = 0
    GameConfig.life = 10
end

function MainScene:init()
    self:resetData()
    self.state = state.playing
    display.addSpriteFrames(res.textureOpaquePack_plist, res.textureOpaquePack_png)
    display.addSpriteFrames(res.textureTransparentPack_plist,res.textureTransparentPack_png)
    display.addSpriteFrames(res.explosion_plist, res.explosion_png)
    display.addSpriteFrames(res.b01_plist, res.b01_png)
    
    self.layer = display.newLayer()
    self.layer:addNodeEventListener(cc.NODE_TOUCH_EVENT, handler(self, self.onTouch))
    self:addChild(self.layer)
    self.layer:setTouchEnabled(true)
    
    self.texOpaqueBatch = display.newBatchNode(res.textureOpaquePack_png)
    self.texOpaqueBatch:setBlendFunc(gl.SRC_ALPHA, gl.ONE)
    self:addChild(self.texOpaqueBatch)
    
    self.texTransparentBatch = display.newBatchNode(res.textureTransparentPack_png)
    --self.texTransparentBatch:setBlendFunc(gl.SRC_ALPHA, gl.ONE)
    self:addChild(self.texTransparentBatch)
    
    self.levelManager = LevelManager.new(self)
    self.screenRect = cc.rect(0, 0, display.width, display.height+10)
    
    self.lbScore = cc.Label:createWithBMFont(res.fnt_arial_14, "Score: 0", cc.TEXT_ALIGNMENT_RIGHT, 0, cc.p(0, 0))
    self.lbScore:setAnchorPoint(1, 0)
    self:addChild(self.lbScore, 1000)
    self.lbScore:setPosition(display.width - 5, display.height - 30)
    
    local life = display.newSprite("#ship01.png")
    life:setScale(0.6)
    life:setPosition(30, display.height - 22)
    self.texTransparentBatch:addChild(life, 1, 5)
    
    self.lbLife = cc.Label:create()
    self.lbLife:setPosition(60, display.height - 22)
    self.lbLife:setString("0")
    self.lbLife:setSystemFontSize(20)
    self.lbLife:setColor(cc.c3b(255,0,0))
    self:addChild(self.lbLife, 1000)
    
    self.ship = Ship.new(self.texTransparentBatch)
    
    
    self:setLocalZOrder(self.ship.zOrder)
    self:setTag(GameConfig.unitTag.player)

    self.explosions = display.newBatchNode(res.explosion_png)
    self.explosions:setBlendFunc(gl.SRC_ALPHA, gl.ONE)
    self:addChild(self.explosions)
    
    Explosion:sharedExplosion()
    
    if GameConfig.sound then
        audio.playMusic(res.mp3_bgMusic, true)
    end
    
    self:initBackground()
    local label = cc.Label:create()
    label:setString("Main Menu")
    label:setSystemFontSize(18)
    local sysMenuItem = cc.MenuItemLabel:create(label)
    sysMenuItem:registerScriptTapHandler(handler(self, self.onSysMenu))
    sysMenuItem:setAnchorPoint(0, 0)
    sysMenuItem:setPosition(display.width-95, 5)
    local menu = cc.Menu:create()
    menu:setPosition(0,0)
    menu:addChild(sysMenuItem)
    self:addChild(menu, 1, 2)
    self:scheduleUpdate()
    self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, handler(self, self.update))
    self.scoreTimer = scheduler.scheduleGlobal(handler(self, self.scoreCounter), 1)
    self.moveTimer = scheduler.scheduleGlobal(handler(self, self.moveTileMap), 5)
end

function MainScene:onSysMenu(sender)
    app:enterScene("MenuScene", nil, "fade", 1.2)
end

function MainScene:scoreCounter()
    if self.state == state.playing then
        self.time = self.time + 1
        self.levelManager:loadLevelResource(self.time)
    end
end

function MainScene:onTouch(event)
    if event.name == "moved" or event.name == "dragged" then
        if self.state == state.playing then
            local delta = cc.pSub(cc.p(event.x, event.y), cc.p(event.prevX, event.prevY))
            local x, y = self.ship:getPosition()
            local currp = cc.p(x, y)
            currp = cc.pAdd(currp, delta)
            currp = cc.pGetClampPoint(currp, cc.p(0, 0), cc.p(display.width, display.height))
            self.ship:setPosition(currp)
        end
    end
    return true
end

function MainScene:update(dt)
    if self.state == state.playing then
        self:checkCollision()
        self:removeInactiveUnit(dt)
        self:checkReBorn()
        self:updateUI()
        self:moveBackground(dt)
    end
end

function MainScene:checkCollision()
    local enemies = GameConfig.container.enemies
    local bullets = GameConfig.container.playerBullets
    for i = 1, #enemies do
        local e = enemies[i]
        if e.active then
            for j =1, #bullets do
                local b = bullets[j]
                if b.active and self:collide(e, b) then
                    b:hurt()
                    e:hurt()
                end
            end
            if self:collide(e, self.ship) then
                if self.ship.active then
                    self.ship:hurt()
                    e:hurt()
                end
            end
        end
    end
    for i = 1, #GameConfig.container.enemyBullets do
        local eb = GameConfig.container.enemyBullets[i]
        if eb.active and self:collide(eb, self.ship) then
            if self.ship.active then
                self.ship:hurt()
                eb:hurt()
            end
        end
    end
end

function MainScene:removeInactiveUnit(dt)
    local updateChildren = function(children)
        for i = 1, #children do
            local c = children[i]
            if c and c.active then
                c:update(dt)
            end
        end
    end
    updateChildren(self.texOpaqueBatch:getChildren())
    updateChildren(self.texTransparentBatch:getChildren())
end

function MainScene:checkReBorn()
    local ship = self.ship
    if GameConfig.life > 0 and not ship.active then
        ship:born()
    elseif GameConfig.life <= 0 and not ship.active then
        self.state = state.gameover
        self.ship = nil
        local dt = cc.DelayTime:create(0.2)
        local cf = cc.CallFunc:create(handler(self, self.onGameOver))
        self:runAction(cc.Sequence:create({dt, cf}))
    end
end

function MainScene:updateUI()
    if self.tmpScore < GameConfig.score then
        self.tmpScore = self.tmpScore + 1
    end
    self.lbLife:setString(GameConfig.life .. " ")
    self.lbScore:setString("Score: " .. self.tmpScore)
end

function MainScene:collide(a, b)
    local ax, ay = a:getPosition()
    local bx, by = b:getPosition()
    if math.abs(ax - bx) > maxContaintWidth or math.abs(ay - by) > maxContainHeight then
        return false
    end
    local aRect = a:collideRect()
    local bRect = b:collideRect()
    return cc.rectIntersection(aRect,bRect)
end

function MainScene:initBackground()
    self.backSky = BackSky:show(self)
    self.backSkyHeight = self.backSky:getContentSize().height
    self:moveTileMap()
end

function MainScene:moveTileMap()
    local backTileMap = BackTileMap:show(self)
    local rand = math.random()
    backTileMap:setPosition(rand*display.width, display.height)
    local move = cc.MoveBy:create(rand*2+10, cc.p(0, -display.height-240))
    local func = cc.CallFunc:create(function()
        backTileMap:destroy()
    end)
    local seq = cc.Sequence:create({move, func})
    backTileMap:runAction(seq)
end

function MainScene:moveBackground(dt)
    local mdt = 16*dt
    local skyHieght = self.backSkyHeight
    local sky = self.backSky
    local currY = sky:getPositionY() - mdt
    local skyRe = self.backSkyRe
    
    if skyHieght + currY <= display.height then
        if skyRe ~= nil then
            assert(false, "may be memory leak")    
        end
        self.backSkyRe = self.backSky
        self.backSky = BackSky:show(self)
        self.backSky:setPositionY(currY + skyHieght - 2)
    else
        sky:setPositionY(currY)
        if (skyRe) then
            currY = skyRe:getPositionY() - mdt
            if (currY + skyHieght < 0) then
                skyRe:destroy()
                self.backSkyRe = nil
            else
                skyRe:setPositionY(currY)
            end
        end
    end
end

function MainScene:onGameOver()
    self:unscheduleUpdate()
    scheduler.unscheduleGlobal(self.moveTimer)
    scheduler.unscheduleGlobal(self.scoreTimer)
    app:enterScene("GameOverScene", nil, "fade", 1.2)
end

function MainScene:addEnemy(e, z, t)
    self.texTransparentBatch:addChild(e, z, t)
end

function MainScene:addExplosions(e)
    self.explosions:addChild(e)
end

function MainScene:addBulletHits(hit, z)
    self.texOpaqueBatch:addChild(hit, z)
end

function MainScene:addSpark(sp)
    self.texOpaqueBatch:addChild(sp)
end

function MainScene:addBullet(b, z, t)
    self.texOpaqueBatch:addChild(b, z, t)
end

return MainScene
