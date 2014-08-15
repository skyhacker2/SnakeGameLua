local Snake = class("Snake", function() return cc.Layer:create() end)
local SnakeNode = require "src/SnakeNode"
require "math"
function Snake:ctor()
    self._nodes = {}
end

function Snake:init(len, direction, x, y)
    local len = len or 3
    local direction = direction or "left"
    local x = x or math.floor(G.maxX / 2)
    local y = y or math.floor(G.maxY / 2)
    print(x)
    self.nextZ = self:zIndexGenerator()
    local head = SnakeNode:new()
    head:init("res/head.png", x, y, direction)
    self._nodes[#self._nodes + 1] = head
    
    function nextPosition()
        if direction == 'left' then x = x + 1; return end
        if direction == 'right' then x = x - 1; return end
        if direction == 'up' then  y = y - 1; return end
        if direction == 'down' then y = y + 1; return end
    end
    
    for i = 1, len do
        nextPosition()
        local body = SnakeNode:new()
        local res = i % 2 ~= 0 and "res/body0.png" or "res/body1.png"
        body:init(res, x, y, direction)
        self._nodes[#self._nodes + 1] = body
    end
    nextPosition()
    local endNode = SnakeNode:new()
    endNode:init("res/end.png", x, y, direction)
    self._nodes[#self._nodes + 1] = endNode
    for i = 1, #self._nodes do
        self:addChild(self._nodes[i], self.nextZ())
    end
end

function Snake:step(opt)
    local opt = opt or {}
    for i = 1, #self._nodes do
        local node = self._nodes[i]
        local x, y = node.x, node.y
        if node.direction == 'left' then
            x = (node.x - 1 + G.maxX) % G.maxX
        end
        if node.direction == 'right' then
            x = (node.x + 1) % G.maxX
        end
        if node.direction == 'up' then
            y = (node.y + 1) % G.maxY
        end
        if node.direction == 'down' then
            y = (node.y - 1 + G.maxY) % G.maxY
        end
        
        -- 检测与障碍物碰撞
        if opt.barriers ~= nil then
            if self:isCollideWithBarriers(opt.barriers, x, y) then
                if opt.onCollision then opt.onCollision() end
                return 
            end
        end
        
        -- 当蛇到达边缘的时候，将node向外围再移动一格
        if (node.x == 0 and x == G.maxX-1) or 
            (node.x == G.maxX-1 and x == 0) or 
            (node.y == 0 and y == G.maxY-1) or 
            (node.y == G.maxY-1 and y == 0) then
            local newX, newY = x, y
            if x == 0 then
                newX = -1
            end
            if x == G.maxX-1 then
                newX = G.maxX
            end
            if y == 0 then
                newY = -1
            end
            if y == G.maxY-1 then
                newY = G.maxY
            end
            G.setPosition(node, newX, newY)
        end
        --print(x, y)
        node:moveTo(x, y)
        if self._newNode ~= nil then
            table.insert(self._nodes, 2, self._newNode)
            break
        end
    end
    
    if self._newNode == nil then
        for i = #self._nodes, 2, -1 do
            self._nodes[i].preDirection = self._nodes[i].direction
            self._nodes[i].direction = self._nodes[i-1].direction
        end
    end
    self._newNode = nil
    
    -- 旋转
    for i = 1, #self._nodes do
        local node = self._nodes[i]
        if node.preDirection ~= nil and node.preDirection ~= node.direction then
            local angle = G.angleMap[node.preDirection][node.direction]
            node:rotateTo(angle)
        end
    end 
    -- 头部的preDirection
    if self._nodes[1] ~= nil then
        self._nodes[1].preDirection = self._nodes[1].direction
    end
    
    -- 检测有没有吃到食物
    if opt.foods ~= nil then
        local ret, i = self:eatFood(opt.foods)
        if ret then
            if opt.onEatFood then opt.onEatFood(i) end
        end
    end
    
    -- 检测有没有吃到自己
    if self:isEatMyself() then
        if opt.onEatItself then opt.onEatItself() end
    end
end

function Snake:onTouch(location)
    if #self._nodes == 0 then return end
    if self._nodes[1]:getPositionX() <= G.winSize.width / 2 then
        self:onTouchLeft(location)
    else
        self:onTouchRight(location)
    end
    if self._newNode ~= nil then
        self._newNode.direction = self._nodes[1].direction
    end
end

function Snake:onTouchLeft(location)
    print("onTouchLeft")
    local head = self._nodes[1]
    head.preDirection = head.direction
    if head.direction == 'left' or head.direction == 'right' then
        if location.y > head:getPositionY() then
            head.direction = 'up'
        elseif location.y < head:getPositionY() then
            head.direction = 'down'
        end
    elseif head.direction == 'up' or head.direction == 'down' then
        if location.x > head:getPositionX() then
            head.direction = 'right'
        elseif location.x < head:getPositionX() then
            head.direction = 'left'
        end
    end
    
end

function Snake:onTouchRight(location)
    print("onTouchRight")
    local head = self._nodes[1]
    head.preDirection = head.direction
    if head.direction == 'left' or head.direction == 'right' then
        if location.y < head:getPositionY() then
            head.direction = 'up'
        elseif location.y > head:getPositionY() then
            head.direction = 'down'
        end
    elseif head.direction == 'up' or head.direction == 'down' then
        if location.x < head:getPositionX() then
            head.direction = 'right'
        elseif location.x > head:getPositionX() then
            head.direction = 'left'
        end
    end
end

function Snake:eatFood(foods)
    if #self._nodes == 0 then return end
    for i = 1, #foods do
        if foods[i].x == self._nodes[1].x and
            foods[i].y == self._nodes[1].y then
            -- 吃到食物，添加一节
            self._newNode = SnakeNode:new()
            local texture = #self._nodes % 2 ~= 0 and "res/body0.png" or "res/body1.png"
            self._newNode:init(texture,foods[i].x, foods[i].y, self._nodes[i].direction)
            self:addChild(self._newNode, self.nextZ())
            return true, i
        end
    end
    return false
end

function Snake:isCollideWithBarriers(barriers, x, y)
    for i, barrier in ipairs(barriers) do
        if barrier:containsXY(x, y) then
            return true
        end
    end
    return false
end

function Snake:isEatMyself()
    local head = self._nodes[1]
    for i = 2, #self._nodes do
        local node = self._nodes[i]
        if head.x == node.x and head.y == node.y then
            -- 截断
            local endnode = self._nodes[#self._nodes]
            -- 复制前一节点所有属性到结尾节点
            self._nodes[i-1]:cloneValue(endnode)
            --endnode, self._nodes[i-1] = self._nodes[i-1], endnode
            --self._nodes[i-1]:cloneValue(self._nodes[#self._nodes])
            self._nodes[#self._nodes], self._nodes[i-1] = self._nodes[i-1], self._nodes[#self._nodes]

            for k = #self._nodes, i, -1 do
                self:removeChild(self._nodes[k],true)
                table.remove(self._nodes,k)
            end
            endnode:rotateTo(G.initAngleMap[endnode.direction])
            G.setPosition(endnode, endnode.x, endnode.y)
            print(#self._nodes)
            return true
        end
    end
    return false
end

function Snake:containsXY(x, y)
    for i = 1, #self._nodes do
        if self._nodes[i].x == x and
            self._nodes[i].y == y then
            return true
        end
    end
    return false
end

function Snake:zIndexGenerator()
    local z = 1000
    return function()
        z = z - 1
        return z + 1
    end
end

return Snake

