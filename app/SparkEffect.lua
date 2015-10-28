local SparkEffect = class("SparkEffect", function()
    return display.newNode()
end)

local GameConfig = require("src.app.GameConfig")

function SparkEffect:ctor()
    self.active = true
    self.scale = 1.2
    self.duration = 0.7
    
    self.spark1 = display.newSprite("#explode2.png")
    self.spark2 = display.newSprite("#explode3.png")
    self:addChild(self.spark1)
    self:addChild(self.spark2)
end

function SparkEffect:play(x, y)
    self.spark1:setPosition(cc.p(x, y))
    self.spark2:setPosition(cc.p(x, y))
    
    self.spark1:setScale(self.scale)
    self.spark2:setScale(self.scale)
    
    self.spark2:setRotation(math.random()*360)
    local right = cc.RotateBy:create(self.duration, 45)
    local scaleby = cc.ScaleBy:create(self.duration, 3, 3)
    local seq = cc.Sequence:create({right, scaleby})
    self.spark1:runAction(right)
    self.spark1:runAction(scaleby)
    self.spark1:runAction(seq)
    
    self.spark2:runAction(scaleby:clone())
    self.spark2:runAction(seq:clone())
end

function SparkEffect:destroy()
    self.active = false
    self.spark1:setVisible(false)
    self.spark2:setVisible(false)
    self.spark1:stopAllActions()
    self.spark2:stopAllActions()
end

function SparkEffect:activate()
    self.active = true
    self.spark1:setVisible(true)
    self.spark2:setVisible(true)
end

function SparkEffect:show(parent, x, y)
    local spark  = self:getAvailbleSpark()
    if spark == nil then
        spark = self:create(parent)
    end
    spark:activate()
    spark.play(x, y)
    return spark
end

function SparkEffect:getAvailbleSpark()
    local spark
    local sparkvec = GameConfig.container.sparks
    for i = 1, #sparkvec do
        spark = sparkvec[i]
        if spark.active == false then
            return spark
        end
    end
    return nil
end

function SparkEffect:create(parent)
    local spark = self.new()
    parent:addChild(spark, GameConfig.order_spark)
    table.insert(GameConfig.container.sparks, spark)
    return spark
end

function SparkEffect:preLoad(parent)
    for i =1, 10 do
        local spark = self:create(parent)
        spark:destroy()
    end
end

return SparkEffect