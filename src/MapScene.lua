local math = require('math')
local winSize = cc.Director:getInstance():getWinSize()
local g_cellWidth = 44
local g_cellHeight = 44
local g_maxCellX = math.ceil(winSize.width / g_cellWidth)
local g_maxCellY = math.ceil(winSize.height / g_cellWidth)
local g_angleMap = {
    left = {up = 90, down = -90},
    right = {up = -270, down = 270},
    up = {left = 0, right = 180},
    down = {left = 0, right = -180},
}
local g_initAngleMap = {
    left = 0,
    up = 90,
    right = 180,
    down = 270
}
local g_movedCount = 0
local g_movedTotal = 20

local scheduler = cc.Director:getInstance():getScheduler()
local logicEntry = nil

local function createLayer()
    cc.SpriteFrameCache:getInstance():addSpriteFrames("res/snake.plist")
    local layer = cc.Layer:create()
    --local snakeBatch = cc.SpriteBatchNode:create("res/snake.png")
    local background = cc.Sprite:create("res/map_grass.png")
    background:setPosition(winSize.width / 2, winSize.height / 2)
    layer:addChild(background, 0)
    
    local heartBar = cc.Sprite:create("res/heart_box.png")
    local hearts = {
        cc.Sprite:create("res/heart.png"),
        cc.Sprite:create("res/heart.png"),
        cc.Sprite:create("res/heart.png")
    }
    local heartBarSize = heartBar:getContentSize()
    for i = 1, #hearts do
        local size = hearts[i]:getContentSize()
        hearts[i]:setPosition(size.width * i, heartBarSize.height / 2)
        heartBar:addChild(hearts[i], 1, i)
    end
    heartBar:setPosition(heartBar:getContentSize().width / 2,
                         winSize.height - heartBar:getContentSize().height/2)
    layer:addChild(heartBar, 10001)
    local function createSnake()
        local headNode = {
            x = math.floor(g_maxCellX / 2),
            y = math.floor(g_maxCellY / 2),
            --x = g_maxCellX,
            --y = g_maxCellY,
            sprite = cc.Sprite:createWithSpriteFrameName("head.png"),
            direction = 'left'
        }
        local bodyNode = {
            x = headNode.x + 1,
            y = headNode.y,
            sprite = cc.Sprite:createWithSpriteFrameName("body0.png"),
            direction = 'left'
        }
        local endNode = {
            x = bodyNode.x + 1,
            y = bodyNode.y,
            sprite = cc.Sprite:createWithSpriteFrameName("end.png"),
            direction = 'left'
        }
        return {headNode, bodyNode, endNode}
    end
    
    local function setPosition(sprite, x, y)
        sprite:setPosition(x * g_cellWidth + g_cellWidth / 2, y * g_cellHeight + g_cellHeight / 2)
    end

    local snake = createSnake()
    local foods = {}
    local barriers = {
        {
            x = 10,
            y = 5,
            direction = "horizontal",
            length = 4, -- 占的位置数
            sprite = cc.Sprite:create("res/barrier.png")
        },
        {   
            x = 20,
            y = 5,
            direction = "vertical",
            length = 4, -- 占的位置数
            sprite = cc.Sprite:create("res/barrier.png")
        }
    }
    local newSnakeNode = nil
    local heartNum = 3
    local isTouchedBarrier = false
    local isGameOver = false
    
    local function addBarriers()
        for i = 1, #barriers do
            barriers[i].sprite:setAnchorPoint(1.0 / 8, 0.5)
            setPosition(barriers[i].sprite,barriers[i].x,barriers[i].y)
            if barriers[i].direction == 'vertical' then
                barriers[i].sprite:setRotation(-90)
            end
            layer:addChild(barriers[i].sprite, 1)
        end
    end
    addBarriers()
    
    local function addFood()
        math.randomseed(os.time())
    	local function generatePosition()
    	   return math.random(1, g_maxCellX-2), math.random(1, g_maxCellY-2)
    	end
    	local function isPositionValid(t, x, y)
    	   for i = 1, #t do
    	       if t[i].x == x and t[i].y == y then
    	           return false
    	       end
    	   end
    	   return true
    	end
    	local function checkBarriersPositions(x, y)
    	   for i, barrier in ipairs(barriers) do
    	       if barrier.direction == 'horizontal' then
    	           for j = barrier.x, barrier.x + barrier.length-1 do
    	               if x == j and y == barrier.y then return false end
    	           end
    	       end
                if barrier.direction == 'vertical' then
                    for j = barrier.y, barrier.y + barrier.length-1 do
                        if x == barrier.x and y == j then return false end
                    end
                end
    	   end
    	   return true
    	end
    	local x, y
    	repeat
    		x, y = generatePosition()
        until isPositionValid(snake,x,y) and isPositionValid(foods,x,y) and checkBarriersPositions(x,y)
    	local food = {
    	   x = x,
    	   y = y,
    	   sprite = cc.Sprite:create("res/food.png")
    	}
    	food.sprite:setPosition(food.x * g_cellWidth + g_cellWidth/2,
    	                       food.y * g_cellHeight + g_cellHeight/2)
    	foods[#foods+1] = food
    	layer:addChild(food.sprite, 1)
    end
    
    local function eatFood(food)
        local bodyRes = (#snake % 2 == 0) and "body0.png" or "body1.png"
        local snakeNode = {
            x = food.x,
            y = food.y,
            direction = snake[1].direction,
            sprite = cc.Sprite:createWithSpriteFrameName(bodyRes)
        }
        snakeNode.sprite:setRotation(g_initAngleMap[snakeNode.direction])
        setPosition(snakeNode.sprite, snakeNode.x, snakeNode.y)
        layer:addChild(snakeNode.sprite, snake[1].sprite:getLocalZOrder()-1)
        newSnakeNode = snakeNode
    end
        
    local function checkIsEatFood(x, y)
        local x = x or snake[1].x
        local y = y or snake[1].y
        for i, food in ipairs(foods) do
            if food.x == snake[1].x and food.y == snake[1].y then
                eatFood(food)
                layer:removeChild(food.sprite)
                table.remove(foods, i)
                return true
            end
        end
        return false
    end
    -- 检测有没有碰撞
    local function checkIsEatItself(x, y)
        for i = 2, #snake do
            if snake[i].x == x and snake[i].y == y then
                heartBar:removeChildByTag(heartNum,true)
                -- 截断身体，心心减一
                heartNum = heartNum-1
                for k, v in pairs(snake[i-1]) do
                    if k ~= "sprite" then
                        snake[#snake][k] = v
                    end
                end
                snake[i-1], snake[#snake] = snake[#snake], snake[i-1]
                for j = #snake, i, -1 do
                    layer:removeChild(snake[j].sprite,true)
                    table.remove(snake, j)
                end
                return true
            end
        end
        --print(#snake)
        return false
    end
    local function checkIsTouchBarriers(x, y)
        for i, barrier in ipairs(barriers) do
            if barrier.direction == 'horizontal' then
                for k = barrier.x, barrier.x + barrier.length-1 do
                    if x == k and y == barrier.y then
                        heartBar:removeChildByTag(heartNum,true)
                        heartNum = heartNum-1
                        return true
                    end
                end
            elseif barrier.direction == 'vertical' then
                for k = barrier.y, barrier.y + barrier.length-1 do
                    if y == k and x == barrier.x then
                        print(k, barrier.x)
                        print(y, x)
                        heartBar:removeChildByTag(heartNum,true)
                        heartNum = heartNum-1
                        return true
                    end
                end
            end
        end
        return false
    end
    
    local function gameOver()
        isGameOver = true
        require 'GameOver'
        if logicEntry ~= nil then
            scheduler:unscheduleScriptEntry(logicEntry)
        end
        local gameLayer = createGameOver()
        layer:addChild(gameLayer, 20000)
    end
    
    for i = #snake, 1, -1 do
        snake[i].sprite:setPosition(snake[i].x * g_cellWidth + g_cellWidth/2, 
                                    snake[i].y * g_cellHeight + g_cellHeight/2)
        layer:addChild(snake[i].sprite, 10000 - i)
    end

    -- 向前一步
    local function stepForward()
        for i = 1, #snake do
            local preX = snake[i].x
            local preY = snake[i].y
            local x, y = snake[i].x, snake[i].y
            
            if snake[i].direction == 'left' then
                x = (snake[i].x - 1 + g_maxCellX) % g_maxCellX
            end
            if snake[i].direction == 'right' then
                x = (snake[i].x + 1) % g_maxCellX
            end
            if snake[i].direction == 'up' then
                y = (snake[i].y + 1) % g_maxCellY
            end
            if snake[i].direction == 'down' then
                y = (snake[i].y - 1 + g_maxCellY) % g_maxCellY
            end
            -- 检查是否碰撞到障碍物
            if i == 1 then
                isTouchedBarrier = checkIsTouchBarriers(x, y)
                if isTouchedBarrier then
                    if heartNum == 0 then
                        gameOver();
                    end
                    if logicEntry ~= nil then
                        scheduler:unscheduleScriptEntry(logicEntry)
                    end
                    return
                end
            end
            snake[i].x, snake[i].y = x, y
            
            -- 当蛇到达边缘的时候，将node向外围再移动一格
            if (preX == 0 and snake[i].x == g_maxCellX-1) or 
               (preX == g_maxCellX-1 and snake[i].x == 0) or 
               (preY == 0 and snake[i].y == g_maxCellY-1) or 
               (preY == g_maxCellY-1 and snake[i].y == 0) then
               local newX, newY = snake[i].x, snake[i].y
               if snake[i].x == 0 then
                    newX = -1
               end
               if snake[i].x == g_maxCellX-1 then
                    newX = g_maxCellX
               end
               if snake[i].y == 0 then
                    newY = -1
               end
               if snake[i].y == g_maxCellY-1 then
                    newY = g_maxCellY
               end
                snake[i].sprite:setPosition(newX * g_cellWidth + g_cellWidth/2,
                    newY * g_cellHeight + g_cellHeight/2)
            end
            
            local moveTo = cc.MoveTo:create(0.2, cc.p(snake[i].x * g_cellWidth + g_cellWidth/2,
                snake[i].y * g_cellHeight + g_cellHeight/2))
            local action = cc.Sequence:create(moveTo)
            snake[i].sprite:runAction(action)
            
            -- 添加一个蛇的身体
            if newSnakeNode ~= nil then
                table.insert(snake, 2, newSnakeNode)
                --newSnakeNode = nil
                break
            end
            
        end
        if newSnakeNode == nil then
            for i = #snake, 2, -1 do
                snake[i].preDirection = snake[i].direction
                snake[i].direction = snake[i-1].direction
            end
        end
        newSnakeNode = nil 
        -- 旋转
        for i = 1, #snake do
            if snake[i].preDirection ~= nil and snake[i].direction ~= snake[i].preDirection then
                local angle = g_angleMap[snake[i].preDirection][snake[i].direction]
                --print(angle)
                local rotate = cc.RotateTo:create(0.2, angle)
                snake[i].sprite:runAction(rotate)
            end
        end
        -- 头部的preDirection
        snake[1].preDirection = snake[1].direction
    end
    
    -- 后退一步
    local function stepBackup()
        
    end
    
    -- 移动snake
    local function moveTo(node, pos, count)
        
    end
    
    -- 游戏逻辑
    local function logic(dt)
        stepForward()

        checkIsEatFood(snake[1].x,snake[1].y)
        if checkIsEatItself(snake[1].x,snake[1].y) then
            if heartNum == 0 then
                gameOver();
            end
        end
        if #foods < 1 then addFood() end
    end
    
    --layer:scheduleUpdateWithPriorityLua(update,0)
    logicEntry = scheduler:scheduleScriptFunc(logic, 0.2, false)    

    local function onTouchEnded(touch, event)
        if isTouchedBarrier and not isGameOver then
            isTouchedBarrier = false
            logicEntry = scheduler:scheduleScriptFunc(logic, 0.2, false)
        end
        local location = touch:getLocation()
        snake[1].preDirection = snake[1].direction
        if snake[1].direction == 'left' or snake[1].direction == 'right' then
            if location.y > snake[1].sprite:getPositionY() then
                snake[1].direction = 'up'
            elseif location.y < snake[1].sprite:getPositionY() then
                snake[1].direction = 'down'
            end
        elseif snake[1].direction == 'up' or snake[1].direction == 'down' then
            if location.x > snake[1].sprite:getPositionX() then
                snake[1].direction = 'right'
            elseif location.x < snake[1].sprite:getPositionX() then
                snake[1].direction = 'left'
            end
        end
        print("direction: ", snake[1].direction)
        if newSnakeNode ~= nil then
            newSnakeNode.direction = snake[1].direction
        end
    end
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_BEGAN )
    local eventDispatcher = layer:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, layer)
    return layer
end

function createMapScene()
    local scene = cc.Scene:create()
    local layer = createLayer()
    --local layer = Map:create()
    scene:addChild(layer)
    return scene
end