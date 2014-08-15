local math = require "math"
G = G or {}
G.winSize = cc.Director:getInstance():getWinSize()
G.cellWidth = 44
G.cellHeight = 44
G.maxX = math.ceil(G.winSize.width / G.cellWidth)
G.maxY = math.ceil(G.winSize.height / G.cellHeight)
G.angleMap = {
    left = {up = 90, down = -90},
    right = {up = -270, down = 270},
    up = {left = 0, right = 180},
    down = {left = 0, right = -180},
}
G.initAngleMap = {
    left = 0,
    up = 90,
    right = 180,
    down = 270
}
G.updateTime = 0.2
G.lowest = 0
G.low = 1
G.middle = 3
G.high = 4
G.highest = 5

function G.setPosition(node, x, y)
    node:setPosition(x * G.cellWidth + G.cellWidth / 2, y * G.cellHeight + G.cellHeight / 2)
end

function G.getPosition(x, y)
    return {x = x * G.cellWidth + G.cellWidth / 2, y = y * G.cellHeight + G.cellHeight / 2}
end

function G.init()
    G.winSize = cc.Director:getInstance():getWinSize()
    G.maxX = math.ceil(G.winSize.width / G.cellWidth)
    G.maxY = math.ceil(G.winSize.height / G.cellHeight)
end
return G