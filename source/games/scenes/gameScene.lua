GameScene = {}
class('GameScene').extends(NobleScene)

player = nil

GameScene.baseColor = Graphics.kColorWhite

function GameScene:init()
    GameScene.super.init(self)
end

function GameScene:enter()
    GameScene.super.enter(self)

    -- Construct Map --
    self.tiles = {}

    for i = 1, 15, 1 do
        self.tiles[i] = {}
        for j = 1, 15, 1 do
            self.tiles[i][j] = {}
        end
    end

    self:addNewElement(Floor, 1, 1)
end

function GameScene:addNewElement(type, i, j, ...)
    local caseTable = self.tiles[i][j]
    caseTable[#caseTable + 1] = type.new(i, j, ...)
end