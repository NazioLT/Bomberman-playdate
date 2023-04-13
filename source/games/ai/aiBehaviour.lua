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

    -- self.controlledPlayer:setCollideRect(13, 21, 6, 6)

    local sucess, path = self:pathToPlayer()

    self.path = path
    self.currentPathTargetID = #path

    if sucess then
        print("Success " .. #path)
    else 
        print("Failure")
    end
end

function AIBehaviour:updateBehaviour()
    local pI, pJ = self.controlledPlayer:getTile()

    self.frameToUpdate += 1

    -- Update path each X frames
    if self.frameToUpdate > frameToUpdatePath then
        self.frameToUpdate = 0

        local success, path = self:pathToPlayer()
        self.currentPathTargetID = #path
        self.path = path
    end


    if self:isAtTarget(pI, pJ) then
        self.currentPathTargetID -= 1
        print("Is Good")
        return
    end

    local dI, dJ = self.path[self.currentPathTargetID].i - pI, self.path[self.currentPathTargetID].j - pJ

    print(dI .. " :: " .. dJ)

    if math.abs(dI) > math.abs(dJ) then
        self.controlledPlayer:setDirection(dI > 0 and 1 or -1, self.controlledPlayer.moveInputs.y)
        else
        self.controlledPlayer:setDirection(self.controlledPlayer.moveInputs.x, dJ > 0 and 1 or -1)
    end
end

function AIBehaviour:isAtTarget(i, j)
    return i == self.path[self.currentPathTargetID].i and j == self.path[self.currentPathTargetID].j
end

function AIBehaviour:pathToPlayer()
    local path = self.astar:aStarCompute(self.controlledPlayer:node(), self.otherPlayer:node())
    local sucess = path ~= nil 
    return sucess, path
end