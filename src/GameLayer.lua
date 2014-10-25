local GameLayer = class("GameLayer", function() return cc.Layer:create() end)
local HeartBar = require "HeartBar"
local Food = require "Food"
local Barrier = require "Barrier"
local Snake = require "Snake"
local math = require "math"
local GameOver = require "GameOver"
local MapLevel = require "MapLevel"
local mapBg = {
    grass = "res/map_grass.png"
}
local scheduler = cc.Director:getInstance():getScheduler()

function GameLayer:init(map, level)
    self._map = map
    self._level = level
    local levelData = MapLevel[map][level]
    self._levelData = levelData
    local winSize = cc.Director:getInstance():getWinSize()
    local bg = cc.Sprite:create(levelData.background)
    bg:setPosition(winSize.width/2,winSize.height/2)
    self:addChild(bg, G.lowest)
    
    -- 生命条
    local heartBar = HeartBar.new()
    heartBar:init(levelData.heartNum, levelData.heartBg)
    heartBar:setPosition(heartBar:getContentSize().width / 2,
        winSize.height - heartBar:getContentSize().height/2)
    self:addChild(heartBar, G.high)
    self._heartBar = heartBar
    -- 添加蛇
    self._snake = Snake:new()
    self._snake:init(levelData.snake.size, levelData.snake.direction, levelData.snake.x, levelData.snake.y)
    self:addChild(self._snake, G.middle)
    
    -- 添加障碍物
    self._barriers = {}
    for i = 1, #levelData.barriers do
        local barrier = Barrier.new()
        barrier:init(levelData.barriers[i].direction, levelData.barriers[i].x, levelData.barriers[i].y)
        self:addChild(barrier)
        self._barriers[#self._barriers + 1] = barrier
    end

    -- 添加食物
    self._foods = {}
    self._eated = 0
    for i = 1, levelData.foods.num do
        self:addFood()
    end
    
    
    -- 更新函数
    function update()
        self:logic()    
    end
    self._updateId = scheduler:scheduleScriptFunc(update, G.updateTime, false)
    
    -- 关闭按钮
    self._closeButton = ccui.Button:create("res/close.png")
    self._closeButton:setPosition(self:getContentSize().width - self._closeButton:getContentSize().width/2,
        self:getContentSize().height - self._closeButton:getContentSize().height/2)
    self._closeButton:addTouchEventListener(function()
        scheduler:unscheduleScriptEntry(self._updateId) 
        cc.Director:getInstance():replaceScene(require("MapSelectScene").scene()) 
    end)                                
    self:addChild(self._closeButton, G.high)

    -- 点击屏幕
    function onTouch(touch, event)
        if self._isGameOver and self._isGameOver == true then return end
        if self._stop and self._stop == true then
            self._updateId = scheduler:scheduleScriptFunc(update, G.updateTime, false)
            self._stop = false 
        end
        local location = touch:getLocation()
        self._snake:onTouch(location)
    end
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouch,cc.Handler.EVENT_TOUCH_BEGAN )
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
end

function GameLayer:logic()
    self._snake:step{
        foods = self._foods,
        barriers = self._barriers,
        onEatFood = function(index)
            self:removeChild(self._foods[index],true)
            table.remove(self._foods,index)
            self:addFood()
            self._eated = self._eated + 1
        end,
        onCollision = function()
            self:onCollision()
        end,
        onEatItself = function()
            self:decreaseHeart()
        end
    }
end

function GameLayer:addFood()
    math.randomseed(os.time())
    function generateXY()
        return math.random(1, G.maxX-2), math.random(1, G.maxY-2)
    end
    function containsInBarriers(x, y)
        for i, barrier in ipairs(self._barriers) do
            if barrier:containsXY(x, y) then return true end
        end
        return false
    end
    local x, y = 0, 0
    repeat
    	x, y = generateXY()
    until not self._snake:containsXY(x, y) and not containsInBarriers(x,y)
    local food = Food.new()
    food:init(1, x, y)
    self:addChild(food, G.low)
    self._foods[#self._foods + 1] = food
end


function GameLayer:onCollision()
    self._stop = true
    scheduler:unscheduleScriptEntry(self._updateId)
    self:decreaseHeart()
end

function GameLayer:decreaseHeart()
    self._heartBar:decrease()
    if self._heartBar:getHeartNum() == 0 then
        scheduler:unscheduleScriptEntry(self._updateId)
        self:saveScore()
        local gameOver = GameOver.create{
            score = self._score,
            isNewScore = self._isNewScore,
            create = function()
                local GameScene = require "GameScene"
                local gameScene = GameScene.scene(self._map, self._level)
                return gameScene
            end,
        }
        self:addChild(gameOver, G.highest)
        self._isGameOver = true
    end
end

function GameLayer:saveScore()
    local score  = self._eated * 10 + self._snake:getSize() * 20
    self._isNewScore = false
    self._score = score
    local oldScore = cc.UserDefault:getInstance():getIntegerForKey("score",0)
    if score > oldScore then
        cc.UserDefault:getInstance():setIntegerForKey("score",score)
        self._isNewScore = true
    end
end

return GameLayer