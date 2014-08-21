local winSize = cc.Director:getInstance():getWinSize()

local GameOver = class("GameOver")
function GameOver.create(opt)
    local opt = opt or {}
    local layer = cc.LayerColor:create(cc.c4b(0, 0, 0, 100))
    local label = cc.Label:createWithSystemFont("GameOver","Arial",60)
    label:setPosition(winSize.width/2,winSize.height/2)
    layer:addChild(label)
    
    -- 添加分数
    local foodSprite = cc.Sprite:create("res/food.png")
    foodSprite:setPosition(winSize.width / 2 - 55, winSize.height / 1.4)
    layer:addChild(foodSprite)
    local score = "x ".. (opt.score and opt.score or 0)
    local scoreLabel = cc.Label:createWithSystemFont(score ,"Arial",40)
    scoreLabel:setPosition(winSize.width / 2 + 55, winSize.height / 1.4)
    layer:addChild(scoreLabel)
    
    -- 添加菜单
    local menu = cc.Menu:create()
    menu:setPosition(cc.p(0, 0))
    cc.MenuItemFont:setFontName("Arial")
    cc.MenuItemFont:setFontSize(40)
    layer:addChild(menu)
    
    -- 菜单回调函数
    local function restart()
        print("restart")
        if opt.create ~= nil then
            hideAds()
            local scene = opt.create()
            cc.Director:getInstance():replaceScene(scene)
        end
    end
    
    local function gotoHome()
        print("gotoHome")
        hideAds()
        cc.Director:getInstance():replaceScene(require("src/MapSelectScene").scene())
    end
    
    local menuItemLabels = {"重玩", "返回"}
    local menuItemCallbacks = {restart, gotoHome}
    
    for i, v in ipairs(menuItemLabels) do
        local item = cc.MenuItemFont:create(v)
        item:setPosition(winSize.width / 3 * i, winSize.height / 3)
        item:registerScriptTapHandler(menuItemCallbacks[i])
        menu:addChild(item)        
    end
    
    -- 显示广告
    showAds()
            
    return layer
end

function GameOver:scene()
    local scene = cc.Scene:create()
    scene:addChild(GameOver.create())
    return scene
end

-- For Test

function createGameOverScene()
    local scene = cc.Scene:create()
    local layer = createGameOver()
    scene:addChild(layer)
    return scene
end

return GameOver