class("AStar").extends()

function getManhattanDistance(xa, ya, xb, yb)
    local dstX = Mathf.Abs(xa - xb);
    local dstY = Mathf.Abs(ya - yb);

    return dstX + dstY
end

function getManhattanDistance(nodeA, nodeB)
    return getManhattanDistance(nodeA.i, nodeA.j, nodeB.i, nodeB.j)
end

function containsNode(table, node)
    for i = 1, #table, 1 do
        if areTheSameNode(table[i], node) then
            return true
        end
    end

    return false
end

function findLowestCost(openedNodes)
    local result = self

    for i = 2, #self.openedNodes, 1 do
        local node = self.openedNodes[i]

        if node.F < result.F then
            result = node;
        end
    end

    return result
end

function AStar:init(map)
    self.map = map
end

function AStar:aStarCompute(startNode, endNode)
    self.openedNodes = { }
    self.closedNodes = { }

    while true do

        -- Pas de chemins possibles
        if #self.openedNodes == 0 then
            return nil
        end

        local currentNode = findOptimalNode(self.openedNodes)

        if areTheSameNode(currentNode, endNode) then
            break
        end

        local neighbours = self.map:getNeighbours(currentNode)

        for i = 1, #neighbours, 1 do

            -- TODO CHECK SI CLOSED OR OBSTACLE
            if containsNode(self.closedNodes, neighbours[i]) then
                goto continue
            end

            local newCost = currentNode.g + getManhattanDistance(currentNode, neighbours[i])
            local isNeighbourOpened = containsNode(self.openedNodes, neighbours[i])

            if newCost < neighbours[i].g or isNeighbourOpened == false then
                neighbours[i].g = newCost;
                neighbours[i].h = getManhattanDistance(neighbours[i], endNode)
                neighbours[i].parent = currentNode

                if isNeighbourOpened == false then
                    table.insert(self.openedNodes, node)
                    print("opened : ", node.i, node.j)
                end
            end

            ::continue::
        end

        table.remove(self.openNodes, table.indexOfElement(self.openNodes, currentNode))
        table.insert(self.closedNodes, currentNode)
    end

    local path = { }
    local currentNode = self.closedNodes[#self.closedNodes]

    while areTheSameNode(startNode, currentNode) == false or currentNode.parent == nil do
        table.insert(path, currentNode)
        currentNode = currentNode.parent
    end

    return path
end