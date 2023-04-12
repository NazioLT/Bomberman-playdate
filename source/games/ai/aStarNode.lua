class('AStarNode').extends()

-- aStarNodeState
-- {
--     Default = 0,
--     Open = 1,
--     Close = 2,
--     Obstacles = 3,
-- }

function areTheSameNode(nodeA, nodeB)
    return nodeA.i == nodeB.i and nodeA.j == nodeB.j
end

function AStarNode:init(i, j)
    self.i = i
    self.j = j
    self.h = 0
    self.g = 0
    self.f = 0
    self.parent = nil
end

function AStarNode:update()
    
end

function AStarNode:isAtCoordinates(i, j)
    return self.i == i and self.j ==j
end