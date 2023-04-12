class("AStarScene").extends(NobleScene)

AStarScene.baseColor = Graphics.kColorWhite

function AStarScene:init()
    AStarScene.super.init(self)
end

function AStarScene:enter()
    AStarScene.super.enter(self)

    self.startNode = AStarNode(2,2)
    self.endNode = AStarNode(7,5)

    self.tiles = EmptyDoubleTable(15)
    local map = Map(tiles)

    local astar = AStar(map)

    local path = astar:aStarCompute(self.startNode, self.endNode)

    if path ~= nil then
        print("Success " .. #path)
    else 
        print("Failure")
    end

    
end