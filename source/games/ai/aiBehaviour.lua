class('AIBehaviour').extends(NobleSprite)

local frameToUpdatePath = 20

states = 
{
    Idle = 1,
    Esquive = 2,
    GoToPlayer = 4,
    PoseBomb = 3,
}

function AIBehaviour:init(player, astar)
    AIBehaviour.super.init(self)

    self.frameToUpdate = 0
    self.pathFinished = true

    self.controlledPlayer = player
    self.otherPlayer = player == player1 and player2 or player1
    self.astar = astar
    self.currentState = ""

    self.stateMachine = StateMachine()
    self.context = AIContext(player)

    local sucess, path = self:pathToPlayer()

    self.path = path
    self.currentPathTargetID = #path

    self.horizontalMove = true
    self.normDX = 0
    self.normDY = 0

    if sucess then
        print("Success " .. #path)
    else 
        print("Failure")
    end
end

function AIBehaviour:newState(i, j)

    -- SE MET A L'ABRIS

    if map:hasBombAt(i, j) then
        return "DODGE"
    end

    if #map.freeItems > 1 then
        local randomIndex = math.ceil((math.random() * #map.freeItems))

        local success, path = self:pathTo(map.freeItems[randomIndex].i, map.freeItems[randomIndex].j)

        if success then
            self.path = path
            return "GOTOITEM"
        end
    end

    return "IDLE"
end

function AIBehaviour:updateBehaviour()
    self.context:update()
    self.stateMachine:update(self.context)

    if self.context.mustUpdatePath then
        print("update")
        self:updatePath()
        return
    end

    print("follow")
    self:followPath()

    -- self.frameToUpdate += 1
    -- local target = self.path[#self.path]

    -- local i, j = self:playerTileCoord()

    -- local newState = self:newState(i, j)
    -- local isChangingState = self.currentState ~= newState
    -- self.currentState = newState

    -- print(newState)
    -- print(target.i .. " " .. target.j)

    -- if self.currentState == "IDLE" then
    --     return
    -- end

    -- local isTargetSafe = map:getDanger(target.i, target.j) <= 1 -- 1 CAR 1 CEST BOMB A COTE

    -- if isChangingState == false and self.frameToUpdate < frameToUpdatePath and isTargetSafe then
    --     print("follow")
    --     self:followPath()
    --     return;
    -- end

    -- print("update")
    -- self:updatePath(i, j)
end

function AIBehaviour:updatePath()

    local success, path = self:pathToNode(self.context.targetNode)
    self.context.currentPathTargetID = #path
    self.context.path = path

    if success then
        self.frameToUpdate = 0
    end
end

function AIBehaviour:newCurrentStateDestination(i, j)
    if self.currentState == "DODGE" then
        return map:searchFirstSafeCase(i, j)
    end

    -- if self.currentState == "GOTOITEM" then
    --     return map:searchFirstSafeCase(i, j)
    -- end

    return i, j
end

function AIBehaviour:followPath()
    if self.context.path == nil or #self.context.path < 1 then
        return
    end

    local target = self.context.path[self.context.currentPathTargetID]
    local i, j = self.context.controlledPlayerNode.i, self.context.controlledPlayerNode.j

    if i == target.i and j == target.j then
        if 1 <= self.context.currentPathTargetID - 1 then
            self.context.currentPathTargetID -= 1
        -- else
        --     self.context.pathFinished = true
        end
        return
    end

    local dI, dJ = target.i - i, target.j - j

    local horizontalMove = math.abs(dI) >= math.abs(dJ)
    local normDX, normDY = dI >= 0 and 1 or -1, dJ >= 0 and 1 or -1

    if horizontalMove then
        self.controlledPlayer:setDirection(normDX, self.controlledPlayer.moveInputs.y)
    else
        self.controlledPlayer:setDirection(self.controlledPlayer.moveInputs.x, normDY)
    end
end

function AIBehaviour:isAtTarget(x, y, inputX, inputY)
    local pI, pJ

    if math.abs(inputX) >= math.abs(inputY) then
        -- local delta = 
        
        if inputX <= 0 then--Va vers la droite
            pI, pJ = pixelToTile(x - 8, y)


        else--Gauche
            pI, pJ = pixelToTile(x + 8, y)

        end

    else

        if inputY <= 0 then--Va vers le bas
            pI, pJ = pixelToTile(x, y + 8)
    
    
        else--Haut
            pI, pJ = pixelToTile(x, y - 8)
    
        end

    end

    return pI == self.path[self.currentPathTargetID].i and pJ == self.path[self.currentPathTargetID].j, pI, pJ
end

function AIBehaviour:pathToPlayer()
    return self:pathToNode(self.otherPlayer:node())
end

function AIBehaviour:pathTo(i, j)
    return self:pathToNode(AStarNode(i, j))
end

function AIBehaviour:pathToNode(node)
    local path = self.astar:aStarCompute(self.controlledPlayer:node(), node)
    local sucess = path ~= nil 
    return sucess, path
end