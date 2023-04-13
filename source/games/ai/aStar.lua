class("AStar").extends()

function getManhattanDistance(xa, ya, xb, yb)
    local dstX = math.abs(xa - xb);
    local dstY = math.abs(ya - yb);

    return dstX + dstY
end

function getNodeManhattanDistance(nodeA, nodeB)
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
    local result = openedNodes[1]

    if #openedNodes == 1 then
        return result
    end

    for i = 2, #openedNodes, 1 do
        local node = openedNodes[i]

        if node.f < result.f then
            result = node;
        end

        ::continue::
    end

    return result
end

function AStar:init(map)
    self.map = map
end

function AStar:aStarCompute(startNode, endNode)
    self.openedNodes = { }
    self.closedNodes = { }

    self.openedNodes[#self.openedNodes + 1] = startNode

    while true do

        -- Pas de chemins possibles
        if #self.openedNodes == 0 then
            return nil
        end

        local currentNode = findLowestCost(self.openedNodes)
        table.remove(self.openedNodes, table.indexOfElement(self.openedNodes, currentNode))
        table.insert(self.closedNodes, currentNode)

        -- print("Check Node :" .. currentNode.i .. " / " .. currentNode.j)

        if areTheSameNode(currentNode, endNode) then
            break
        end

        local neighbours = self.map:getNeighbours(currentNode)
        -- print("Neighbour count : " .. #neighbours)

        for i = 1, #neighbours, 1 do

            -- print("Check neighbour : " .. neighbours[i].i .. " : " .. neighbours[i].j)
            -- TODO CHECK SI CLOSED OR OBSTACLE
            if containsNode(self.closedNodes, neighbours[i]) or neighbours[i].isObstacle == true then -- or neighbours[i].isObstacle == true
                -- print("skip : " .. neighbours[i].i .. " : " .. neighbours[i].j)
                goto continue
            end

            local newCost = currentNode.g + getNodeManhattanDistance(currentNode, neighbours[i])
            local isNeighbourOpened = containsNode(self.openedNodes, neighbours[i])

            if newCost < neighbours[i].g or isNeighbourOpened == false then
                neighbours[i]:update(newCost, getNodeManhattanDistance(neighbours[i], endNode), currentNode)

                if isNeighbourOpened == false then
                    table.insert(self.openedNodes, neighbours[i])
                    -- print("opened : ", neighbours[i].i, neighbours[i].j)
                end
            end

            ::continue::
        end
    end

    local path = { }
    local currentNode = self.closedNodes[#self.closedNodes]

    -- print("Finished computing : " .. currentNode.i)

    while areTheSameNode(startNode, currentNode) == false and currentNode.parent ~= nil do
        table.insert(path, currentNode)
        currentNode = currentNode.parent
    end

    return path
end