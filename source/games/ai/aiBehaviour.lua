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

-- Gauche 4, 0 : ok / droite -4, 0 : ok / Haut 0, 12 : ok / Bas 0, 4 : ok
function AIBehaviour:playerTileCoord()
    if self.lastDirection == "Left" then
        return self.controlledPlayer:getTileWithDelta(4, 0)
    end

    if self.lastDirection == "Right" then
        return self.controlledPlayer:getTileWithDelta(-4, 0)  
    end

    if self.lastDirection == "Top" then
        return self.controlledPlayer:getTileWithDelta(0, 12) 
    end

    return self.controlledPlayer:getTileWithDelta(0, 4)
end

function AIBehaviour:newState(i, j)

    -- SE MET A L'ABRIS

    if map:hasBombAt(i, j) then
        return "DODGE"
    end

    return "IDLE"
end

function AIBehaviour:updateBehaviour()
    self.frameToUpdate += 1
    self.lastDirection = self.controlledPlayer.lastDirection

    local i, j = self:playerTileCoord()

    local newState = self:newState(i, j)
    local isChangingState = self.currentState ~= newState
    self.currentState = newState

    if self.currentState == "IDLE" then
        return
    end


    if isChangingState == false and self.frameToUpdate < frameToUpdatePath then
        self:followPath()
        return;
    end

    self:updatePath(i, j)

    -- if self.pathIsValid and self.pathFinished == false and self.path ~= nil and #self.path > 0 then
    --     local targetSafe = map:hasBombAt(self.path[1].i, self.path[1].j) == false
    --     if targetSafe then
    --         self:followPath()
    --     end
    -- end

        -- -- Update path each X frames
        -- if self.frameToUpdate > frameToUpdatePath then
        --     self.frameToUpdate = 0
    
        --     local success, path = self:pathToPlayer()
        --     self.currentPathTargetID = #path
        --     self.path = path
        --     self.canGoToPlayer = success
        -- end
    
        -- if self.canGoToPlayer then
        --     self:goToPlayer()
        --    return 
        -- end
end

function AIBehaviour:updatePath(i, j)
    local destI, destJ = self:newCurrentStateDestination(i, j)

    local success, path = self:pathTo(destI, destJ)
    self.currentPathTargetID = #path
    self.path = path
    self.canGoToPlayer = success

    if success then
        self.frameToUpdate = 0
    end
end

function AIBehaviour:newCurrentStateDestination(i, j)
    if self.currentState == "DODGE" then
        return map:searchFirstSafeCase(i, j)
    end

    return i, j
end

function AIBehaviour:followPath()
    local target = self.path[self.currentPathTargetID]
    local i, j = self:playerTileCoord()

    if i == target.i and j == target.j then
        if 1 <= self.currentPathTargetID - 1 then
            self.currentPathTargetID -= 1
        else
            self.pathFinished = true
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