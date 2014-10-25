local MapSelectLayer = class("MapSelectLayer", function() return cc.Layer:create() end)
local G = require "G"
local Selector = require "Selector"
function MapSelectLayer:init()
    local bg = cc.Sprite:create("res/map_select_bg.jpg")
    bg:setPosition(G.winSize.width/2,G.winSize.height/2)
    bg:setScale(G.winSize.width / bg:getContentSize().width,G.winSize.height / bg:getContentSize().height)
    self:addChild(bg, G.lowest)
    
    -- 下拉选择控件
    self._selector = Selector.new()
    self._selector:init()
    self:addChild(self._selector, G.low)
    
    -- 关闭按钮
    self._closeButton = ccui.Button:create("res/close.png")
    self._closeButton:setPosition(self:getContentSize().width - self._closeButton:getContentSize().width/2,
        self:getContentSize().height - self._closeButton:getContentSize().height/2)
    self._closeButton:addTouchEventListener(function()
        cc.Director:getInstance():endToLua()
    end)                                
    self:addChild(self._closeButton)
    
end

return MapSelectLayer