local HomeLayer = class("HomeLayer", function()
    return cc.Layer:create() end
)

function HomeLayer:init()
    local winSize = cc.Director:getInstance():getWinSize()
    local background = cc.Sprite:create("res/main_1.jpg")
    background:setPosition(winSize.width / 2,winSize.height / 2)
    self:addChild(background)
    
    local startBtn = cc.MenuItemImage:create("res/start_btn.png","res/start_touched_btn.png","res/start_btn.png")
    local settingBtn = cc.MenuItemImage:create("res/setting_btn.png","res/setting_touched_btn.png","res/setting_btn.png")
    settingBtn:setPosition(0, startBtn:getPositionY() - startBtn:getContentSize().height)
    
    function startMenuCallback()
        cc.Director:getInstance():replaceScene(require("MapSelectScene").scene("grass",1))
    end
    startBtn:registerScriptTapHandler(startMenuCallback)
    local menu = cc.Menu:create(startBtn, settingBtn)
    menu:setPosition(winSize.width / 2, winSize.height / 4)
    self:addChild(menu)
end

return HomeLayer