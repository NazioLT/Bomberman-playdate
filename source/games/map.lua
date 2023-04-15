class("Map").extends()

function Map:init(tiles)
    self.tiles = tiles;
    self.explosionsTiles = { }
    self.freeItems = { }

    for i = 1, 15, 1 do
        self.explosionsTiles[i] = { }
        for j = 1, 15, 1 do
            self.explosionsTiles[i][j] = 0
        end
    end
end

function Map:addExplosionGroup(i, j)
    for x = -1, 1, 1 do
        for y = -1, 1, 1 do
           if math.abs(x) ~= math.abs(y) then
                self:addDanger(i + x, j + y, 1)
           end 
        end
    end

    self:addDanger(i, j, 2)
end

function Map:removeExplosionGroup(i, j)
    for x = -1, 1, 1 do
        for y = -1, 1, 1 do
           if math.abs(x) ~= math.abs(y) then
                self:removeDanger(i + x, j + y, 1)
           end 
        end
    end

    self:removeDanger(i, j, 2)
end

function Map:getDanger(i, j)
    if self:isInMap(i, j) == false then
        return 0
    end
    return self.explosionsTiles[i][j]
end

function Map:addDanger(i, j, danger)
    if self:isInMap(i, j) == false then
        return
    end
    self.explosionsTiles[i][j] += danger
end

function Map:removeDanger(i, j, danger)
    if self:isInMap(i, j) == false then
        return
    end
    self.explosionsTiles[i][j] -= danger
end

function Map:hasBombAt(i, j)
    if self:isInMap(i, j) == false then
        return true
    end

    return self.explosionsTiles[i][j] > 0
end

function Map:searchFirstSafeCase(i, j)
    if self:isInMap(i, j) == false then
        return i, j
    end

    for n = 1, 15, 1 do
        for x = -n, n, 1 do
            for y = -n, n, 1 do
                local cI, cJ = i + x, j + y

                if self:isInMap(cI, cJ) then
                    if self:hasBombAt(cI, cJ) == false and isWalkable(self.tiles[cI][cJ]) then
                        return cI, cJ
                    end
                end
            end
        end
    end

    return i, j
end

function Map:isInMap(i, j)
    if i < 1 or j < 1 then
        return false
    end

    return i < #self.explosionsTiles and j < #self.explosionsTiles[i]
end

function Map:getNodeAt(i, j)
    -- print(i .. " " .. j)

    if i > #self.tiles or i < 1 or j < 1 or j > #self.tiles[1] then
        -- print("fff")
        return nil
    end

    if self.tiles[i][j] == 1 then
        -- print("vvv")
        return nil
    end

    local node = AStarNode(i, j)
    local caseTable = self.tiles[i][j]

    if isWalkable(caseTable) == false then
        node.isObstacle = true
    end

    return node
end

function Map:getNeighbours(node)
    local neighbours = {}

    for i = -1, 1, 1 do
        for j = -1, 1, 1 do
            if math.abs(i) ~= math.abs(j) then
                local node = self:getNodeAt(i + node.i, j + node.j);

                if node ~= nil then
                    neighbours[#neighbours + 1] = node
                end
            end
        end
    end

    return neighbours
end

function pickItem(item)
    
end

function Map:checkIfHasItem(i, j)
    local hasItem, item = gameScene:hasItem(i, j)

    if hasItem == false then
        return
    end

    self.freeItems[#self.freeItems+1] = item
end