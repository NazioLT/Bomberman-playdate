GameScene = {}
class('GameScene').extends(NobleScene)

player = nil

GameScene.baseColor = Graphics.kColorWhite

function GameScene:init()
    GameScene.super.init(self)
end

function GameScene:enter()
    GameScene.super.enter(self)

    -- Init map data --
    self.tiles = {}

    for i = 1, 15, 1 do
        self.tiles[i] = {}
        for j = 1, 15, 1 do
            self.tiles[i][j] = {}
        end
    end

    -- Generate base of the Map --
    for i = 1, 15, 1 do
        for j = 1, 15, 1 do
            if 
            -- Borders
            i == 1 or i == 15 or j == 1 or j == 15 
            -- Tiles une fois sur 2
            or (j % 2 == 1 and i % 2 == 1)
            then
                self:addNewElement(UnbreakableBlock, i, j)
            end
        end
    end

    local bricProbability = 0.9

    for i = 2, 14, 1 do
        for j = 2, 14, 1 do
            if math.random() > (1 - bricProbability)
            and (j % 2 == 1 and i % 2 == 1) == false then
                self:addNewElement(Bric, i, j)
            end
        end
    end
end

function GameScene:addNewElement(type, i, j, ...)
    local caseTable = self.tiles[i][j]
    caseTable[#caseTable + 1] = type.new(i, j, ...)
end