
require("config")
require("cocos.init")
require("framework.init")
require("app.ResourceConfig")
local MyApp = class("MyApp", cc.mvc.AppBase)

function MyApp:ctor()
    MyApp.super.ctor(self)
end

function MyApp:run()
    cc.FileUtils:getInstance():addSearchPath("res/")
    cc.FileUtils:getInstance():addSearchPath("res/ImageRaw/")
    cc.FileUtils:getInstance():addSearchPath("res/Music/")
    self:enterScene("MenuScene")
    cc.Director:getInstance():setDisplayStats(false)
end

return MyApp
