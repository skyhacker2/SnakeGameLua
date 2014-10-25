local winSize = cc.Director:getInstance():getWinSize()

local GameOver = class("GameOver")
function GameOver.create(opt)
    local opt = opt or {}
    local layer = cc.LayerColor:create(cc.c4b(100, 100, 100, 150))
    local title = "Game Over"
    if opt.isNewScore then
        title = "新纪录"
    end
    local label = cc.Label:createWithSystemFont(title,"Arial",60)
    label:setPosition(winSize.width/2,winSize.height/2)
    layer:addChild(label)
    
    -- 添加分数
    local score = (opt.score and opt.score or 0)
    local scoreLabel = cc.Label:createWithSystemFont("分数: "..score ,"Arial",40)
    scoreLabel:setAnchorPoint(0,0)
    --scoreLabel:setPosition(winSize.width / 2, winSize.height / 1.4)
    --layer:addChild(scoreLabel)
    local maxScore = cc.UserDefault:getInstance():getIntegerForKey("score",0)
    local maxScoreLabel = cc.Label:createWithSystemFont("最高纪录: "..maxScore,"Arial",40)
    maxScoreLabel:setAnchorPoint(0,0)
    --maxScoreLabel:setPosition(winSize.width/2, winSize.height/1.4)
    --layer:addChild(maxScoreLabel)
    local scoreWrapper = cc.Node:create()
    local wrapperW = 0
    scoreWrapper:addChild(scoreLabel)
    wrapperW = wrapperW + scoreLabel:getContentSize().width + 55
    maxScoreLabel:setPosition(wrapperW,0)
    scoreWrapper:addChild(maxScoreLabel)
    wrapperW = wrapperW + maxScoreLabel:getContentSize().width;
    scoreWrapper:setContentSize(wrapperW,0)
    scoreWrapper:setAnchorPoint(0.5,0.5)
    scoreWrapper:setPosition(winSize.width/2,winSize.height/1.5)
    layer:addChild(scoreWrapper)
    
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
        cc.Director:getInstance():replaceScene(require("MapSelectScene").scene())
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