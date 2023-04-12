class("Map").extends()

function Map:init(tiles)
    self.tiles = tiles;
end

function Map:getNodeAt(i, j)
    if i > #self.tiles[1] or i < 1 or j < 1 or j > #self.tile then
        return nil
    end

    if self.tiles[i][j] == 1 then
        return nil
    end

    return AStarNode(i, j)
end

function Map:getNeighbours(node)
    local neighbours = { }

    for i = -1, 1, 1 do
        for j = -1, 1, 1 do
            if math.abs(i) ~= math.abs(j) then
                local node = getNodeAt(i + node.i, j + node.j);

                if node ~= nil then
                    neighbours[#neighbours+1] = node
                end
            end
        end
    end

    return neighbours
end