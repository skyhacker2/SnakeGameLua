local GameScene = class("GameScene", function() return cc.Scene:create() end)
local GameLayer = require("src/GameLayer")
-- map 地图
-- level 级数
function GameScene.scene(map, level)
    local scene = GameScene.new()
    local layer = GameLayer.new()
    layer:init(map, level)
    scene:addChild(layer)
    return scene
end

return GameScene