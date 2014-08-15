local MapSelectScene = class("MapSelectScene", function() return cc.Scene:create() end)
local MapSelectLayer = require "src/MapSelectLayer"

function MapSelectScene.scene()
    local scene = MapSelectScene:new()
    local layer = MapSelectLayer:new()
    layer:init()
    scene:addChild(layer)
    return scene
end

return MapSelectScene