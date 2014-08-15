local Selector = class("Selector", function() return cc.Layer:create() end)
local G = require "src/G"
local s = G.winSize

-- 木板
local Board = class("Board", function() return cc.Node:create() end)
function Board:init(opt)
    local opt = opt or {}
    --self:setAnchorPoint(0.5,0.5)
    self._bg = cc.Sprite:create("res/map_selector.png")
    self._bg:setPosition(self._bg:getContentSize().width/2, self._bg:getContentSize().height/2)
    self:addChild(self._bg, G.lowest)
    
    self:setContentSize(self._bg:getContentSize())
    self:setAnchorPoint(0.5, 0.5)
    
    self._mapTextures = {
        "res/map_grass.png", "res/map_stone.png", "res/map_snow.png",
    }
    
    self._curMap = opt.mapNum and opt.mapNum or 1
    -- 画面精灵
    local cs = self:getContentSize()
    self._sprite = cc.Sprite:create(self._mapTextures[self._curMap])
    self._sprite:setPosition(cs.width/2, self._sprite:getContentSize().height/1.8)
    self:addChild(self._sprite, G.low)
    
end

function Board:nextMap()
    self._curMap = (self._curMap + 1) % #self._mapTextures + 1
    self._sprite:setTexture(self._mapTextures[self._curMap])
end

function Board:getSelectedMap()
    local mapName = {"grass", "stone", "snow"}
    return mapName[self._curMap]
end


function Board:onTouchBegan(touch, event)
    local location = touch:getLocation()
    local ret = cc.rectContainsPoint(self:getBoundingBox(),location)

    return ret
end

function Board:onTouchMoved(touch, event)
    print("touchMoved")
end

function Board:onTouchEnded(touch, event)
    print("touchEnded")
end

function Selector:init(opt)
    local opt = opt or {}
    local rings = cc.Sprite:create("res/rings.png")
    rings:setPosition(s.width/3,s.height - rings:getContentSize().height/2)
    self:addChild(rings,G.low)
    
    -- 木板
    self._board = Board:new()
    self._board:init()
    self._board:setPosition(s.width/3, s.height - 100)
    self:addChild(self._board, G.lowest)
    self._boardX, self._boardY = self._board:getPosition()
    
    local eventListener = cc.EventListenerTouchOneByOne:create()
    eventListener:setSwallowTouches(true)
    eventListener:registerScriptHandler(
        function(touch, event) return self:onTouchBegan(touch, event) end, 
        cc.Handler.EVENT_TOUCH_BEGAN)
    eventListener:registerScriptHandler(
        function(touch, event) self:onTouchMoved(touch, event) end,
        cc.Handler.EVENT_TOUCH_MOVED)
    eventListener:registerScriptHandler(
        function(touch, event) self:onTouchEnded(touch, event) end,
        cc.Handler.EVENT_TOUCH_ENDED)    
    local dispatcher = self:getEventDispatcher()
    dispatcher:addEventListenerWithSceneGraphPriority(eventListener, self)
end

function Selector:onTouchBegan(touch, event)
    local ret = cc.rectContainsPoint(self._board:getBoundingBox(), touch:getLocation())
    self._prevPos = touch:getLocation()
    self._moved = false
    return ret
end

function Selector:onTouchMoved(touch, event)
    local location = touch:getLocation()
    if location.y > self._prevPos.y then return end
    local len = self._prevPos.y - location.y
    if len > 30 then self._moved = true end
    
    if self._boardY - len < self._board:getContentSize().height / 2 + 30 then return end
    
    self._board:setPositionY(self._boardY - len )
end

function Selector:onTouchEnded(touch, event)
    if not self._moved then 
        cc.Director:getInstance():replaceScene(require("src/GameScene").scene(self._board:getSelectedMap(),1))
    end
    local moveTo = cc.MoveTo:create(0.2,cc.p(self._boardX, self._boardY))
    local func = cc.CallFunc:create(function() self._board:nextMap() end)
    self._board:runAction(cc.Sequence:create(moveTo,func))
    self._moved = false
end

return Selector