GameScene = {}
class('GameScene').extends(NobleScene)

player = nil

GameScene.baseColor = Graphics.kColorWhite

function GameScene:init()
    GameScene.super.init(self)
end

function GameScene:enter()
    GameScene.super.enter(self)

    -- player = Player()
    player = Tile(1,1,1)
end