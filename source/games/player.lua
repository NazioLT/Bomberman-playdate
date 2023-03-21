class('Player').extends(AnimatedSprite)

playerImagetable = playdate.graphics.imagetable.new('images/character-table-32-32.png')

P0, P1 = 0, 1

function Player:init(i, j, player)
    Player.super.init(self, playerImagetable)

    -- variables
    self.bombs = {}
    self.speed = 3
    self.nbBombMax = 1
    self.dead = false

    self.velocity = playdate.geometry.vector2D.new(0, 0)
    self.moveInputs = playdate.geometry.vector2D.new(0, 0)
    self.lastDirection = "Bot"

    local playerShift = playerNumber == P1 and 0 or 5
    local tickSpeed = 10

    -- Colliders
    self:setCollideRect(10, 18, 12, 12)
    self:setCollidesWithGroups({ collisionGroup.block, collisionGroup.shiftBlock })

    -- Animation
    self:addState('IdleBot', 19 + playerShift, 19 + playerShift, {
        tickStep = tickSpeed
    }).asDefault()
    self:addState('IdleTop', 1 + playerShift, 1 + playerShift, {
        tickStep = tickSpeed
    })
    self:addState('IdleRight', 10 + playerShift, 10 + playerShift, {
        tickStep = tickSpeed
    })
    self:addState('IdleLeft', 28 + playerShift, 28 + playerShift, {
        tickStep = tickSpeed
    })

    self:playAnimation()

    local x, y = tileToPixel(i, j)
    self:moveTo(x, y - 8)
    self:setZIndex(10)
end

function Player:setDirection(x, y)
    local moveInputs = playdate.geometry.vector2D.new(x, y)
    moveInputs:normalize()
    self.moveInputs = moveInputs;
end

function Player:update()
    Player.super.update(self)

    local velocity = self.moveInputs * self.speed
    self:moveWithCollisions(self.x + velocity.x, self.y + velocity.y)

    if velocity.y > 0 then
        self:changeState('IdleBot', true)
        self.lastDirection = "Bot"
    elseif velocity.y < 0 then
        self:changeState('IdleTop', true)
        self.lastDirection = "Top"
    elseif velocity.x < 0 then
        self:changeState('IdleLeft', true)
        self.lastDirection = "Left"
    elseif velocity.x > 0 then
        self:changeState('IdleRight', true)
        self.lastDirection = "Right"
    else 
        self:changeState('Idle' .. self.lastDirection, true)
    end

    self.moveInputs = playdate.geometry.vector2D.new(0, 0)
end
