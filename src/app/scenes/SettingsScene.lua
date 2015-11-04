local SettingsScene = class("SettingsScene", function()
    return display.newScene("SettingsScene")
end)
local GameConfig = require("app.GameConfig")
function SettingsScene:ctor()
    self:init()
end

function SettingsScene:init()
    local bg = display.newSprite(res.png_loading)
    bg:setAnchorPoint(0, 0)
    local size = bg:getContentSize()
    bg:setScaleY(display.height/size.height)
    self:addChild(bg, 0, 1)
    
    local title = cc.Sprite:create(res.png_menuTitle)
    title:setPosition(display.cx, display.height-120)
    self:addChild(title)
    
    cc.MenuItemFont:setFontName("Arial")
    cc.MenuItemFont:setFontSize(18)
    
    local title1 = cc.MenuItemFont:create("Sound")
    title1:setEnabled(flase)
    
    cc.MenuItemFont:setFontName("Arial")
    cc.MenuItemFont:setFontSize(26)
    
    local item1 = cc.MenuItemToggle:create(cc.MenuItemFont:create("ON"))
    item1:addSubItem(cc.MenuItemFont:create("OFF"))
    item1:registerScriptTapHandler(function()
        local tag = item1:getSelectedIndex()
        self:onSoundControl(tag)
    end)
    
    local state = GameConfig.sound and 0 or 1
    item1:setSelectedIndex(state)
    
    cc.MenuItemFont:setFontName("Arial")
    cc.MenuItemFont:setFontSize(18)
    
    local title2 = cc.MenuItemFont:create("Mode")
    title2:setEnabled(false)
    
    cc.MenuItemFont:setFontName("Arial")
    cc.MenuItemFont:setFontSize(26)
    local item2 = cc.MenuItemToggle:create(cc.MenuItemFont:create("easy"))
    item2:addSubItem(cc.MenuItemFont:create("normal"))
    item2:addSubItem(cc.MenuItemFont:create("hard"))
    item2:registerScriptTapHandler(function()
        self:onModeControl(item2:getSelectedIndex())
    end)
    item2:setSelectedIndex(0)
    
    local back = cc.Label:create()
    back:setSystemFontName("Arial")
    back:setSystemFontSize(20)
    back:setString("Go Back")
    back:setAlignment(cc.TEXT_ALIGNMENT_CENTER)
    local backitem = cc.MenuItemLabel:create(back)
    backitem:setScale(0.8)
    backitem:registerScriptTapHandler(function()
        self:onBack()
    end)
    
    local menu = cc.Menu:create()
    title1:setPosition(display.cx*0.5, 0)
    menu:addChild(title1)
    item1:setPosition(display.cx*0.5, -title1:getContentSize().height*2)
    menu:addChild(item1)
    
    title2:setPosition(display.cx*1.5, 0)
    menu:addChild(title2)
    item2:setPosition(display.cx*1.5, -title1:getContentSize().height*2)
    menu:addChild(item2)
    
    backitem:setPosition(display.cx, backitem:getContentSize().height + 80 - display.cy)
    menu:addChild(backitem)
    menu:setPosition(0,display.cy)
    
    self:addChild(menu)
end

function SettingsScene:onBack()
    app:enterScene("MenuScene", nil, "fade", 1.2)
end

function SettingsScene:onSoundControl(tag)
    GameConfig.sound = not GameConfig.sound
    if GameConfig.sound then
        audio.playMusic(res.mp3_mainMusic)
    else
        audio.stopMusic()
    end
end

function SettingsScene:onModeControl()

end

return SettingsScene