GameScene = {}
class("GameScene").extends(NobleScene)

GameScene.baseColor = Graphics.kColorWhite

function GameScene:init()
    GameScene.super.init(self)
end

function GameScene:enter()
    GameScene.super.enter(self)
end

function GameScene:start()
    GameScene.super.start(self)
end

function GameScene:drawBackground()
    GameScene.super.drawBackground(self)
end

function GameScene:update()
    GameScene.super.update(self)
end

function GameScene:exit()
    GameScene.super.exit(self)
end

function GameScene:finish()
    GameScene.super.finish(self)
end