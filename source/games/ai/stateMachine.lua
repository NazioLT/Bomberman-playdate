class('AIContext').extends()

function AIContext:init(controlledPlayer, otherPlayer)
    -- STATE MACHINE INPUTS
    self.otherPlayer = otherPlayer
    self.targetNode = controlledPlayer:node()
    self.controlledPlayer = controlledPlayer
    self.controlledPlayerNode = controlledPlayer:node()
    self.lastDirection = "BOT"
    self.isTargetSafe = true
    self.isCurrentCaseSafe = true
    self.timeToUpdate = 0

    -- STATE MACHINE OUTPUTS
    self.path = nil
    self.currentPathNodeID = 1
    self.isChangingState = false
    self.mustUpdatePath = false
    self.currentItemTarget = nil
    self.goingToPlayer = false
end

function AIContext:update()
    self.mustUpdatePath = false

    self.lastDirection = self.controlledPlayer.lastDirection
    self.controlledPlayerNode = AStarNode(self:playerTileCoord())

    self.isCurrentCaseSafe = map:getDanger(self.controlledPlayerNode.i, self.controlledPlayerNode.j) <= 1

    self.timeToUpdate += 1
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

local frameToUpdatePath = 20

function StateMachine:init()
    self.state = "IDLE"
end

function StateMachine:update(context)
    local newState = self:getState(context)
    context.isChangingState = newState ~= self.state
    self.state = newState

    local wantChangeDirection = context.isChangingState and newState ~= "IDLE"
    local pathIsValid = context.path ~= nil and #context.path >= 1
    local pathIsCompleted = false
    if pathIsValid then
        pathIsCompleted = 0 == context.currentPathNodeID
    end 

    print(newState)

    if wantChangeDirection or pathIsValid == false or pathIsCompleted or context.timeToUpdate > frameToUpdatePath then
        local success, newTarget = self:getNewTarget(context)

        if success then
            context.targetNode = newTarget
            context.mustUpdatePath = true
            context.timeToUpdate = 0
        end
    end

    self:updateState(context)
end

function StateMachine:updateState(context)
    if self.state == "DODGE" then
        return
    end

    if self.state == "GOTOITEM" then
        return
    end

    if self.state == "GOTOPLAYER" then
        local distToPlayer = getNodeManhattanDistance(context.otherPlayer:node(), context.controlledPlayerNode)
        if distToPlayer < 5 then
            context.controlledPlayer:dropBomb()
        end

        return
    end
end

function StateMachine:getNewTarget(context)
    if self.state == "DODGE" then
        context.goingToPlayer = false

        local newTarget = AStarNode(map:searchFirstSafeCase(context.controlledPlayerNode.i,context.controlledPlayerNode.j))
        return newTarget ~= context.targetNode, newTarget
    end

    if self.state == "GOTOITEM" then
        context.goingToPlayer = false

        local rndm = math.ceil(math.random() * #map.freeItems)
        local randomItem = map.freeItems[rndm]
        context.currentItemTarget = randomItem
        return true, AStarNode(randomItem.i, randomItem.j)
    end

    if self.state == "GOTOPLAYER" then
        return true, context.otherPlayer:node()
    end

    if self.state == "BREAKBLOCK" then
        local success, bricI, bricJ = gameScene:randomBric()
        return success, AStarNode(bricI, bricJ)
    end

    return false, context.targetNode
end

function StateMachine:getState(context)
    if context.isCurrentCaseSafe == false then
        return "DODGE"
    end

    if #map.freeItems > 0 then
        return "GOTOITEM"
    end

    local distToPlayer = getNodeManhattanDistance(context.otherPlayer:node(), context.controlledPlayerNode)

    if distToPlayer <  10 then
        return "GOTOPLAYER"
    end

    return "BREAKBLOCK"

    -- return "IDLE"
end
