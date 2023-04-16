class('AIBehaviour').extends(NobleSprite)

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

    self.stateMachine = StateMachine(self)
    self.context = AIContext(player, self.otherPlayer)

    -- local sucess, path = self:pathToPlayer()

    self.horizontalMove = true
    self.normDX = 0
    self.normDY = 0

    map.AI[#map.AI+1] = self
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
        self:updatePath()
        return
    end

    self:followPath()
end

function AIBehaviour:checkIfCanGoToPlayer()
    local sucess, path = self:pathToPlayer()
    self.context.canGoToPlayer = sucess
end

function AIBehaviour:updatePath()

    local success, path = self:pathToNode(self.context.targetNode)

    if path == nil then
        self.context.currentPathTargetID = 1
        self.context.path = path
        return
    end

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