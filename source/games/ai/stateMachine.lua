class('AIContext').extends()

function AIContext:init(controlledPlayer)
    -- STATE MACHINE INPUTS
    self.isTargetSafe = true
    self.targetNode = nil
    self.controlledPlayer = controlledPlayer
    self.controlledPlayerNode = controlledPlayer:node()
    self.lastDirection = "BOT"
    self.isTargetSafe = true
    self.isCurrentCaseSafe = true

    -- STATE MACHINE OUTPUTS
    self.path = nil
    self.currentPathNodeID = 1
    self.isChangingState = false
end

function AIContext:update()
    self.lastDirection = self.controlledPlayer.lastDirection
    self.controlledPlayerNode = AStarNode(self:playerTileCoord())

    self.isCurrentCaseSafe = map:hasBombAt(self.controlledPlayerNode.i, self.controlledPlayerNode.j) == false
end

-- Gauche 4, 0 : ok / droite -4, 0 : ok / Haut 0, 12 : ok / Bas 0, 4 : ok
function AIContext:playerTileCoord()
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

class('StateMachine').extends()

function StateMachine:init()
    self.state = "IDLE"
end

function StateMachine:update(context)
    print(self:getState(context))
end

function StateMachine:getState(context)
    if context.isCurrentCaseSafe == false then
        return "DODGE"
    end

    return "IDLE"
end