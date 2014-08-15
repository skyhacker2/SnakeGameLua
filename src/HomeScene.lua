local HomeScene = class("HomeScene", function() return cc.Scene:create() end)

function HomeScene.scene()
    local layer = require("src/HomeLayer").new()
    layer:init()
    local scene = HomeScene.new()
    scene:addChild(layer)
    return scene
end

return HomeScene