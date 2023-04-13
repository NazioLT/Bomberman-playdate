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

    self.controlledPlayer = player
    self.otherPlayer = player == player1 and player2 or player1
    self.astar = astar

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

function AIBehaviour:updateBehaviour()
    self.frameToUpdate += 1

    self.lastDirection = self.controlledPlayer.lastDirection

    -- Update path each X frames
    if self.frameToUpdate > frameToUpdatePath then
        self.frameToUpdate = 0

        local success, path = self:pathToPlayer()
        self.currentPathTargetID = #path
        self.path = path
    end

    local target = self.path[self.currentPathTargetID]
    local i, j = self:playerTileCoord()

    if i == target.i and j == target.j then
        if 1 <= self.currentPathTargetID - 1 then
            self.currentPathTargetID -= 1
            print("good")
        end
        return
    end

    local dI, dJ = target.i - i, target.j - j

    print(dI .. " :: " ..dJ)

    local horizontalMove = math.abs(dI) >= math.abs(dJ)
    local normDX, normDY = dI >= 0 and 1 or -1, dJ >= 0 and 1 or -1

    if horizontalMove then
        self.controlledPlayer:setDirection(normDX, self.controlledPlayer.moveInputs.y)
    else
        self.controlledPlayer:setDirection(self.controlledPlayer.moveInputs.x, normDY)
    end

    -- -- if self.horizontalMove then
    -- --     nodeX += self.normDX * 7
    -- -- else 
    -- --     nodeY += self.normDY * 7
    -- -- end

    -- local pX, pY = tileToPixel(self.controlledPlayer:getTile())
    -- local dX, dY = nodeX - pX, nodeY - pY
    -- local horizontalMove = math.abs(dX) >= math.abs(dY)

    -- local changeDirection = horizontalMove == self.horizontalMove

    -- self.horizontalMove = horizontalMove
    -- local normDX, normDY = dX >= 0 and 1 or -1, dY >= 0 and 1 or -1

    -- if changeDirection == false then
    --     dX += self.normDX * 8
    --     dY -= self.normDY * 8
    -- end

    -- print(dX .. " :: " ..dY)

    -- if math.abs(dX) == 0 and math.abs(dY) == 0 then
    --     print(#self.path .. "good" .. self.currentPathTargetID)
    --     if 1 <= self.currentPathTargetID - 1 then
    --         self.currentPathTargetID -= 1
    --         print("good")
    --     end
    --     return
    -- end

    -- if self.horizontalMove then
    --     self.controlledPlayer:setDirection(normDX, self.controlledPlayer.moveInputs.y)
    -- else
    --     self.controlledPlayer:setDirection(self.controlledPlayer.moveInputs.x, normDY)
    -- end

    -- if self:isAtTarget(pI, pJ, moveInputs.x, moveInputs.y) then
    --     self.currentPathTargetID -= 1
    --     print("Is Good")
    --     return
    -- end

    -- if math.abs(dI) > math.abs(dJ) then
    --     self.controlledPlayer:setDirection(dI > 0 and 1 or -1, self.controlledPlayer.moveInputs.y)
    --     else
    --     self.controlledPlayer:setDirection(self.controlledPlayer.moveInputs.x, dJ > 0 and 1 or -1)
    -- end
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
    local path = self.astar:aStarCompute(self.controlledPlayer:node(), self.otherPlayer:node())
    local sucess = path ~= nil 
    return sucess, path
end