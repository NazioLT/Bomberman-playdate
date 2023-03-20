class('Player').extends(AnimatedSprite)

playerImagetable = playdate.graphics.imagetable.new('images/character-table-32-32.png')

P0, P1 = 0, 1

function Player:init(i, j, player)
    Player.super.init(self, playerImagetable)

    -- variables
    self.bombs = {}
    self.nbBombMax = 1
    self.dead = false

    self.velocity = playdate.geometry.vector2D.new(0, 0)

    local playerShift = playerNumber == P1 and 0 or 5
    local speed = 10

    -- Colliders
    self:setCollideRect(10, 18, 12, 12)

    -- Animation
    self:addState('IdleDown', 19 + playerShift, 19 + playerShift, {
        tickStep = speed
    }).asDefault()

    self:playAnimation()

    local x, y = tileToPixel(i, j)
    self:moveTo(x, y - 8)
    self:setZIndex(10)
end

function Player:Move(playerDirection)

end