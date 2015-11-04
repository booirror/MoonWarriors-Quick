local BackSky = class("BackSky", function()
    return display.newSprite("#bg01.png")
end)

local GameConfig = require("src.app.GameConfig")

function BackSky:ctor()
    self.active = true
    self:setAnchorPoint(0, 0)
end

function BackSky:destroy()
    self:setVisible(false)
    self.active = false
end

function BackSky:activate()
    self:setVisible(true)
    self.active = true
end

function BackSky:create(parent)
    local bg = self.new()
    parent:addChild(bg, -11)
    table.insert(GameConfig.container.backSkys, bg)
    return bg
end

function BackSky:getAvailable()
    local bs = nil
    local skys = GameConfig.container.backSkys
    
    for i = 1, #skys do
        bs = skys[i]
        if bs.active == false then
            return bs
        end
    end
    return nil
end

function BackSky:show(parent)
    local bs = self:getAvailable()
    if bs == nil then
        bs = self:create(parent)
    end
    bs:activate()
    return bs
end

function BackSky:preLoad(parent)
    local bg = nil
    for i=1, 2 do
        bg = self:create(parent)
        bg:activate()
    end
end

local tileMapLv = {
    "lvl1_map1.png",
    "lvl1_map2.png",
    "lvl1_map3.png",
    "lvl1_map4.png"
}

local BackTileMap = class("BackTileMap", function()
    return display.newSprite()
end)

function BackTileMap:ctor(frameName)
    self.active = true
    self:setSpriteFrame(display.newSpriteFrame(frameName))
    self:setAnchorPoint(0.5, 0)
end

function BackTileMap:destroy()
    self:setVisible(false)
    self.active = false
end

function BackTileMap:activate()
    self.active = true
    self:setVisible(true)
end

function BackTileMap:create(parent, frameName)
    local back = BackTileMap.new(frameName)
    parent:addChild(back, -10)
    table.insert(GameConfig.container.backitlemaps, back)
    return back
end

function BackTileMap:getAvailable()
    local maps = GameConfig.container.backitlemaps
    for i = 1, #maps do
        local back = maps[i]
        if back.active == false then
            return back
        end
    end
    return nil
end

function BackTileMap:show(parent)
    local tile = self:getAvailable()
    if tile == nil then
        tile = self:create(parent,tileMapLv[math.floor(math.random()*4)+1])
    end
    tile:activate()
    return tile
end

function BackTileMap:preLoad(parent)
    local backTileMap = nil
    for i = 1, #tileMapLv do
        backTileMap = BackTileMap:create(tileMapLv[i])
        backTileMap:setVisible(false)
        backTileMap.active = false
    end
end

local Background = {}
Background.backSky = BackSky
Background.backTileMap = BackTileMap
return Background
