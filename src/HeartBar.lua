local HeartBar = class("HeartBar", function() return cc.Sprite:create("res/heart_box.png") end)

function HeartBar:init(heartNum)
    self._heartNum = heartNum
    local heartBarSize = self:getContentSize()
    for i = 1, self._heartNum do
        local heart = cc.Sprite:create("res/heart.png")
        local size = heart:getContentSize()
        heart:setPosition(size.width * i, heartBarSize.height / 2)
        self:addChild(heart, 1, i)
    end
end

function HeartBar:getHeartNum()
    return self._heartNum
end

function HeartBar:decrease()
    self:removeChildByTag(self._heartNum,true)
    self._heartNum = self._heartNum - 1
end

return HeartBar