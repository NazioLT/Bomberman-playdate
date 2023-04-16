class('Player').extends(AnimatedSprite)

playerImagetable = playdate.graphics.imagetable.new('images/character-table-32-32.png')

P1, P2 = 1, 2

function Player:init(i, j, player)
    Player.super.init(self, playerImagetable)

    self.invincible = false

    -- variables
    self.bombs = {}
    self.speed = 2
    self.explosionRange = 1
    self.nbBombMax = 1
    self.dead = false
    self.playerNumber = player

    self.velocity = playdate.geometry.vector2D.new(0, 0)
    self.moveInputs = playdate.geometry.vector2D.new(0, 0)
    self.lastDirection = "Bot"

    local playerShift = player == P1 and 0 or 5
    local tickSpeed = 10

    -- Colliders
    self:setCollideRect(12, 20, 8, 8)

    local playerCollisionGroup = player == P1 and collisionGroup.p1 or collisionGroup.p2
    self:setGroups(playerCollisionGroup)

    local playerCollisions = { collisionGroup.block, collisionGroup.bomb, collisionGroup.explosion, collisionGroup.item }
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
    self:addState('Die', 1, 4, {
        tickStep = tickSpeed,
        loop = false,
        frames = { 64 + playerShift, 65 + playerShift, 66 + playerShift, 67 + playerShift }
    })

    self:playAnimation()

    -- Sound
    local sound = playdate.sound.sampleplayer
    self.walkSound = sound.new('sounds/Walking 1.wav')
    self.walkSound:setVolume(0.6)

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

function Player:collisionResponse(other)
    if maskContainsGroup(other:getGroupMask(), collisionGroup.explosion) then
        self:kill()
        return playdate.graphics.sprite.kCollisionTypeOverlap
    end

    if maskContainsGroup(other:getGroupMask(), collisionGroup.item) then
        other:pick(self)
        return playdate.graphics.sprite.kCollisionTypeOverlap
    end

    if self.playerNumber == P1 and maskContainsGroup(other:getGroupMask(), collisionGroup.ignoreP1) then
        return playdate.graphics.sprite.kCollisionTypeOverlap
    end

    if self.playerNumber == P2 and maskContainsGroup(other:getGroupMask(), collisionGroup.ignoreP2) then
        return playdate.graphics.sprite.kCollisionTypeOverlap
    end

    return playdate.graphics.sprite.kCollisionTypeSlide
end

function Player:update()
    Player.super.update(self)

    if self.dead then
        self:changeState('Die', true)
        return
    end

    local velocity = self.moveInputs * self.speed

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

    if velocity.x ~= 0 and velocity.y ~= 0 and self.walkSound:isPlaying() == false then
        self.walkSound:play(1, 1)
    end

    -- Code By François Dervaux
    if (self.moveInputs.x ~= 0 and self.moveInputs.y == 0)
        or (self.moveInputs.y ~= 0 and self.moveInputs.x == 0) then
        -- on crée un rect avec la position du player,
        -- et la position du player +  un offset en fonction de playerInput
        -- !!! pour l'instant notre rect à une aire de zéro,
        -- car les deux points sont soit tous les deux sur l'axe x, ou sur l'axe y
        local rect = getRect(
            self.x,
            self.y + 8,
            self.x + self.moveInputs.x * 16,
            self.y + 8 + self.moveInputs.y * 16
        )

        -- on ajoute ici 2 pixels de largeur et de hauteur à notre rect
        -- pour prendre en compte une zone plus large
        rect.x = rect.x - 1
        rect.y = rect.y - 1
        rect.w = rect.w + 2
        rect.h = rect.h + 2


        -- On detecte les sprite en collision avec notre rect
        local collisions = playdate.graphics.sprite.querySpritesInRect(rect)

        -- Si un des sprite en collision avec le player et du type Block
        -- On set la variable isObstacleFront à true
        local isObstacleFront = false
        if collisions then
            for i = 1, #collisions, 1 do
                if collisions[i]:isa(Block) then
                    isObstacleFront = true
                    break
                end
            end
        end


        --si on n'a pas d'obstacle
        if not isObstacleFront then
            -- en fonction de si on se déplace horizontalement ou verticalement,
            -- on force la position en y ou en x à notre grid
            if self.lastDirection == "Left" or self.lastDirection == "Right" then
                local i, j = self:getTile()
                local _, y = tileToPixel(i, j)
                self:moveTo(self.x, y - 8)
            end
            if self.lastDirection == "Top" or self.lastDirection == "Bot" then
                local i, j = self:getTile()
                local x, _ = tileToPixel(i, j)
                self:moveTo(x, self.y)
            end
        end
    end
    -- Code End


    self:moveWithCollisions(self.x + velocity.x, self.y + velocity.y)
    self.moveInputs = playdate.geometry.vector2D.new(0, 0)
end

function Player:hasBombInReserve()
    return self.nbBombMax > #self.bombs
end

function Player:dropBomb()
    if self.dead then
        self:changeState('Die', true)
        return
    end

    if self:hasBombInReserve() == false then
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

    local i, j = self:getTile()
    self.bombs[#self.bombs + 1] = Bomb.new(i, j, self)
end

function Player:removeBomb(bomb)
    local bombtable = self.bombs
    table.remove(bombtable, table.indexOfElement(bombtable, bomb))
end

function Player:kill()
    if self.invincible then
        return
    end

    self.dead = true

    self.states.Die.onAnimationEndEvent = function(self)
        self:remove()
    end
end

function Player:getTile()
    return pixelToTile(self.x, self.y + 8)
end

function Player:getTileWithDelta(dX, dY)
    return pixelToTile(self.x + dX, self.y + dY)
end

function Player:node()
    return AStarNode(self:getTile())
end
