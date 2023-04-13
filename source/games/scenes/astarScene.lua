class("AStarScene").extends(NobleScene)

AStarScene.baseColor = Graphics.kColorWhite

function AStarScene:init()
    AStarScene.super.init(self)
end

function AStarScene:enter()
    AStarScene.super.enter(self)

    self.startNode = AStarNode(2,2)
    self.endNode = AStarNode(8,5)

    self.tiles = EmptyDoubleTable(15, 15)

    self:spawnBorders()

    local map = Map(self.tiles)

    local astar = AStar(map)

    local path = astar:aStarCompute(self.startNode, self.endNode)

    if path ~= nil then
        print("Success " .. #path)

        for i = 1, #path, 1 do
            print(path[i].i .. " : " .. path[i].j)
            Bric(path[i].i, path[i].j)
        end
    else 
        print("Failure")
    end
end

function AStarScene:spawnBorders()
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

function AStarScene:addNewElement(type, i, j, ...)
    local caseTable = self.tiles[i][j]
    local object = type.new(i, j, ...)
    caseTable[#caseTable + 1] = object

    return object
end

function isWalkable(caseTable) --Return if is walkable and breakableblock
    for n = 1, #caseTable, 1 do
        if caseTable[n]:isa(Block) or caseTable[n]:isa(Bomb) then
            return false, caseTable[n]:isa(Bric) and caseTable[n] or nil
        end
    end

    return true, nil
end