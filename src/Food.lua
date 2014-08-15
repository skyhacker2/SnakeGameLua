local Food = class("Food", function() return cc.Sprite:create() end)

-- type食物类型
function Food:init(type, x, y)
    self:setTexture("res/food.png")
    G.setPosition(self, x, y)
    self.x = x
    self.y = y
end

return Food