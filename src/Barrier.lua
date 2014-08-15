local Barrier = class("Barrier",function() return cc.Sprite:create("res/barrier.png") end)

-- direction 1 水平
-- direction 2 垂直
function Barrier:init(direction, x, y)
    self._direction = direction
    self._positions = {}
    if direction == 1 then 
        for i = x, x + 3 do
            self._positions[#self._positions + 1] = {x = i, y = y}
        end
    end
    
    if direction == 2 then 
        for i = y, y + 3 do
            self._positions[#self._positions + 1] = {x = x, y = i}
        end
        self:setRotation(-90)
    end
    self:setAnchorPoint(1.0 / 8, 0.5)
    G.setPosition(self, x, y)
end

function Barrier:containsXY(x, y)
    for i, pos in ipairs(self._positions) do
        if pos.x == x and pos.y == y then
            cclog("pos %f, %f", pos.x, pos.y)
            return true
        end
    end
    return false
end

return Barrier