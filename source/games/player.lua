class('Player').extends(AnimatedSprite)

playerImagetable = playdate.graphics.imagetable.new('images/character-table-32-32.png')

P1, P2 = 0, 1

function Player:init(i, j, player)
    Player.super.init(self, playerImagetable)

    -- variables
    self.bombs = {}
    self.speed = 3
    self.nbBombMax = 2
    self.dead = false

    self.velocity = playdate.geometry.vector2D.new(0, 0)
    self.moveInputs = playdate.geometry.vector2D.new(0, 0)
    self.lastDirection = "Bot"

    local playerShift = player == P1 and 0 or 5
    local tickSpeed = 10

    -- Colliders
    self:setCollideRect(10, 18, 12, 12)

    local playerCollisions = { collisionGroup.block }
    collisionGroup[#collisionGroup+1] = player == P1 and collisionGroup.p1Collide or collisionGroup.p2Collide
    self:setCollidesWithGroups(playerCollisions)

    -- Animation
    self:addState('IdleBot', 19 + playerShift, 19 + playerShift, {
        tickStep = tickSpeed
    }).asDefault()
    self:addState('RunBot', 1, 3, {
        tickStep = tickSpeed,
        yoyo = true,
        frames = { 20 + playerShift, 19 + playerShift, 21 + playerShift }
    })

    self:addState('IdleTop', 1 + playerShift, 1 + playerShift, {
        tickStep = tickSpeed
    })
    self:addState('RunTop', 1, 3, {
        tickStep = tickSpeed,
        yoyo = true,
        frames = { 2 + playerShift, 1 + playerShift, 3 + playerShift }
    })

    self:addState('IdleRight', 10 + playerShift, 10 + playerShift, {
        tickStep = tickSpeed
    })
    self:addState('RunRight', 1, 3, {
        tickStep = tickSpeed,
        yoyo = true,
        frames = { 11 + playerShift, 10 + playerShift, 12 + playerShift }
    })

    self:addState('IdleLeft', 28 + playerShift, 28 + playerShift, {
        tickStep = tickSpeed
    })
    self:addState('RunLeft', 1, 3, {
        tickStep = tickSpeed,
        yoyo = true,
        frames = { 29 + playerShift, 28 + playerShift, 30 + playerShift }
    })

    self:playAnimation()

    -- Finish
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
        self:changeState('RunBot', true)
        self.lastDirection = "Bot"
    elseif velocity.y < 0 then
        self:changeState('RunTop', true)
        self.lastDirection = "Top"
    elseif velocity.x < 0 then
        self:changeState('RunLeft', true)
        self.lastDirection = "Left"
    elseif velocity.x > 0 then
        self:changeState('RunRight', true)
        self.lastDirection = "Right"
    else
        self:changeState('Idle' .. self.lastDirection, true)
    end

    self.moveInputs = playdate.geometry.vector2D.new(0, 0)
end

function Player:dropBomb()
    if self.nbBombMax <= #self.bombs then
        return
    end

    -- Si déja une bombe sur la tile, return
    local sprites = playdate.graphics.sprite.querySpritesAtPoint(self.x, self.y + 8)
    if sprites ~= nil then
        for i = 1, #sprites, 1 do
            if sprites[i]:isa(Bomb) then
                return
            end
        end
    end

    local i, j = pixelToTile(self.x, self.y + 8)
    self.bombs[#self.bombs + 1] = Bomb.new(i, j, self)
end

function Player:removeBomb(bomb)
    local bombtable = self.bombs
    table.remove(bombtable, table.indexOfElement(bombtable , bomb))
end