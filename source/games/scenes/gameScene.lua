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

    -- Build map
    math.randomseed(playdate.getSecondsSinceEpoch())

    self:spawnBorders()


    self:addNewElement(Empty, 2, 2)
    self:addNewElement(Empty, 3, 2)
    self:addNewElement(Empty, 2, 3)

    self:addNewElement(Empty, 14, 14)
    self:addNewElement(Empty, 13, 14)
    self:addNewElement(Empty, 14, 13)

    self:spawnBrics()
end

function GameScene:addNewElement(type, i, j, ...)
    local caseTable = self.tiles[i][j]
    caseTable[#caseTable + 1] = type.new(i, j, ...)
end

-- Shortcuts methods --

function GameScene:spawnBorders()
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
end

function GameScene:spawnBrics()
    local bricProbability = 0.9

    for i = 2, 14, 1 do
        for j = 2, 14, 1 do
            local table = self.tiles[i][j]
            if
                math.random() > (1 - bricProbability)
                and (j % 2 == 1 and i % 2 == 1) == false
                and hasTypeInTable(table, Empty) == false
            then
                self:addNewElement(Bric, i, j)
            end
        end
    end
end

function GameScene:remove(i, j, object)
    local caseTable = self.tiles[i][j]
    local index = getIndexOfObject(caseTable, object)

    if index then
        caseTable.remove(caseTable, object)
    end
end
