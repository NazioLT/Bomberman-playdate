class("Map").extends()

function Map:init(tiles)
    -- self.tiles = tiles;
    self.tiles = EmptyDoubleTable(15, 15)
end

function Map:getNodeAt(i, j)
    print(i .. " " .. j)

    if i > #self.tiles or i < 1 or j < 1 or j > #self.tiles[1] then
        print("fff")
        return nil
    end

    if self.tiles[i][j] == 1 then
        print("vvv")
        return nil
    end

    return AStarNode(i, j)
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
