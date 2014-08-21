local MapSelectLayer = class("MapSelectLayer", function() return cc.Layer:create() end)
local G = require "src/G"
local Selector = require "src/Selector"
function MapSelectLayer:init()
    local bg = cc.Sprite:create("res/map_select_bg.png")
    bg:setPosition(G.winSize.width/2,G.winSize.height/2)
    bg:setScale(G.winSize.width / bg:getContentSize().width,G.winSize.height / bg:getContentSize().height)
    self:addChild(bg, G.lowest)
    
    -- 下拉选择控件
    self._selector = Selector.new()
    self._selector:init()
    self:addChild(self._selector, G.low)
    
end

return MapSelectLayer