gameScene = {}
class('GameScene').extends(NobleScene)

player1 = nil
player2 = nil
aiBehaviour = nil

GameScene.baseColor = Graphics.kColorWhite

function GameScene:init()
    GameScene.super.init(self)

    GameScene.inputHandler = {
        upButtonHold = function()
            player1:setDirection(player1.moveInputs.x, -1)
        end,
        downButtonHold = function()
            player1:setDirection(player1.moveInputs.x, 1)
        end,
        leftButtonHold = function()
            player1:setDirection(-1, player1.moveInputs.y)
        end,
        rightButtonHold = function()
            player1:setDirection(1, player1.moveInputs.y)
        end,
        AButtonDown = function()
            player1:dropBomb()
        end
    }
end

function GameScene:enter()
    GameScene.super.enter(self)

    -- Init map data --
    self.tiles = EmptyTripleTable(15, 15)
    self.walkableTiles = EmptyDoubleTable(15)
    gameScene = self

    -- Build map
    math.randomseed(playdate.getSecondsSinceEpoch())

    self:spawnBorders()

    self:addNewElement(Empty, 2, 2)
    self:addNewElement(Empty, 3, 2)
    self:addNewElement(Empty, 2, 3)

    self:addNewElement(Empty, 14, 14)
    self:addNewElement(Empty, 13, 14)
    self:addNewElement(Empty, 14, 13)

    local bricCoords = self:spawnBrics()

    self:setFloors()

    self:spawnItem(bricCoords, {
        PowerItem, PowerItem, PowerItem, PowerItem,
        BombItem, BombItem, BombItem, BombItem,
        SpeedItem, SpeedItem, SpeedItem })

    -- Add Player
    player1 = Player(2, 2, P1)
    player2 = Player(14, 14, P2)
    aiBehaviour = AIBehaviour(player2)

    -- Sounds
    local sound = playdate.sound.sampleplayer
    self.backgroundMusic = sound.new('sounds/SBomb1-Battle.wav')
    self.backgroundMusic:setVolume(0.6)
    self.backgroundMusic:play(0, 1)
end

function GameScene:addNewElement(type, i, j, ...)
    local caseTable = self.tiles[i][j]
    local object = type.new(i, j, ...)
    caseTable[#caseTable + 1] = object

    return object
end

function GameScene:update()
    GameScene.super.update(self)

    -- Update Walkable array
    for i = 1, 15, 1 do
        for j = 1, 15, 1 do
            self.walkableTiles[i][j] = self:isWalkable(i, j)
        end
    end
end

-- Shortcuts methods --

function GameScene:spawnItem(coordinates, Types)
    for i = 1, #Types, 1 do
        local index = math.random(1, #coordinates)
        local coords = coordinates[index]
        self:addNewElement(Types[i], coords[1], coords[2])
        table.remove(coordinates, index)
    end
end

function GameScene:spawnBorders()
    for i = 1, 15, 1 do
        for j = 1, 15, 1 do
            if
            -- Borders
                i == 1 or i == 15 or j == 1 or j == 15
            then
                self:addNewElement(UnbreakableBlock, i, j, false)

                -- Tiles une fois sur 2
            elseif (j % 2 == 1 and i % 2 == 1) then
                self:addNewElement(UnbreakableBlock, i, j, true)
            end
        end
    end
end

function GameScene:spawnBrics()
    local bricProbability = 0.6
    local coords = {}

    for i = 2, 14, 1 do
        for j = 2, 14, 1 do
            local table = self.tiles[i][j]
            if
                math.random() > (1 - bricProbability)
                and (j % 2 == 1 and i % 2 == 1) == false
                and hasTypeInTable(table, Empty) == false
            then
                self:addNewElement(Bric, i, j)
                local coord = { i, j }
                coords[#coords + 1] = coord
            end
        end
    end

    return coords
end

function GameScene:setFloors()
    -- A completer plus tard pour mettre les ombres

    -- for i = 2, 14, 1 do
    --     for j = 2, 14, 1 do
    --         local caseTable = self.tiles[i][j]

    --         if hasTypeInTable(caseTable, Block) == false then
    --             local floor = self:addNewElement(Floor, i, j)
    --             local upTable = self.tiles[i][j - 1]

    --             if hasTypeInTable(upTable, Block) then
    --                 floor:setShadow(true)
    --             end
    --         end
    --     end
    -- end
end

function GameScene:remove(i, j, object)
    local caseTable = self.tiles[i][j]
    local index = table.indexOfElement(caseTable, object)

    if index ~= nil then
        table.remove(caseTable, index)
    end
end

function GameScene:isWalkable(i, j) --Return if is walkable and breakableblock
    if i <= 1 or i >= 15 then
        return false, nil
    end

    local caseTable = self.tiles[i][j]
    for n = 1, #caseTable, 1 do
        if caseTable[n]:isa(Block) or caseTable[n]:isa(Bomb) then
            return false, caseTable[n]:isa(Bric) and caseTable[n] or nil
        end
    end

    return true, nil
end

function GameScene:hasTypeAtCoordinates(i, j, type)
    local caseTable = self.tiles[i][j]
    return hasTypeInTable(caseTable, type)
end
