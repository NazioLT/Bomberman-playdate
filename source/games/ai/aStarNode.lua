class('AStarNode').extends()

function areTheSameNode(nodeA, nodeB)
    print(nodeA == nil)
    print(nodeB == nil)
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

function AStarNode:update(h, g, parent)
    self.h = h
    self.g = g
    self.f = g + h
    self.parent = parent
end

function AStarNode:isAtCoordinates(i, j)
    return self.i == i and self.j ==j
end