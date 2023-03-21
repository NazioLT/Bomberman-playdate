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

    local playerShift = playerNumber == P1 and 0 or 5
    local speed = 10

    -- Colliders
    self:setCollideRect(10, 18, 12, 12)
    self:setCollidesWithGroups({ collisionGroup.block, collisionGroup.shiftBlock })

    -- Animation
    self:addState('IdleDown', 19 + playerShift, 19 + playerShift, {
        tickStep = speed
    }).asDefault()

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

    print(self.moveInputs)

    self.moveInputs = playdate.geometry.vector2D.new(0, 0)
end