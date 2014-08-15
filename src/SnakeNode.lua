local SnakeNode = class("SnakeNode", function() return cc.Sprite:create() end)

function SnakeNode:init(texture, x, y, direction)
    self:setTexture(texture)
    self.x = x
    self.y = y
    self.direction = direction
    self.preX = x
    self.preY = y
    G.setPosition(self, x, y)
    self:rotateTo(G.initAngleMap[direction])
end

function SnakeNode:moveTo(x, y)
    self.preX = self.x
    self.preY = self.y
    self.x = x
    self.y = y
    local pos = G.getPosition(x, y)
    local moveTo = cc.MoveTo:create(G.updateTime, pos)
    local action = cc.Sequence:create(moveTo)
    self:runAction(action)
end


function SnakeNode:rotateTo(angle)
    local rotateTo = cc.RotateTo:create(G.updateTime,angle)
    self:runAction(rotateTo)
end

function SnakeNode:cloneValue(node)
    node.x = self.x
    node.y = self.y
    node.preX = self.preX
    node.preY = self.preY
    node.direction = self.direction
end

return SnakeNode