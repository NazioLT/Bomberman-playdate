class('Bomb').extends(GameObject)

function Bomb.new(i, j, player)
    return Bomb(i, j, player)
end

function Bomb:init(i, j, player)
    Bomb.super.init(self, i, j, 5, true)

    self.player = player

    self.explosionRange = player.explosionRange

    local animationTickStep = 5

    self:addState('BombSlow', 1, 3, {
        tickStep = animationTickStep,
        yoyo = true,
        loop = 4,
        nextAnimation = 'BombFast',
        frames = { 29, 30, 31 }
    }).asDefault()

    self:addState('BombFast', 1, 3, {
        tickStep = animationTickStep / 2,
        yoyo = true,
        loop = 4,
        frames = { 29, 30, 31 }
    })

    -- PLACING BOMB EXPLOSION ON MAP

    map:addExplosionGroup(i, j)
    print("Bomb " .. i .. "" .. j)
    for n = -self.explosionRange, self.explosionRange, 1 do
        if n ~= 0 then
            map:addExplosionGroup(i + n, j)
            map:addExplosionGroup(i, j + n)
        end
    end

    self:playAnimation()

    self.states.BombFast.onAnimationEndEvent = function(self)
        self:explode()
    end

    self:setCollidesWithGroups({ collisionGroup.p1, collisionGroup.p2, collisionGroup.bomb, collisionGroup.item,
        collisionGroup.block })

    local collisionGroups = { collisionGroup.bomb }

    self.p1CollEnabled = false
    self.p2CollEnabled = false

    local overlappingSprites = self:overlappingSprites()

    for i = 1, #overlappingSprites, 1 do
        if (overlappingSprites[i] == player1) then
            collisionGroups[#collisionGroups + 1] = collisionGroup.ignoreP1
        end

        if (overlappingSprites[i] == player2) then
            collisionGroups[#collisionGroups + 1] = collisionGroup.ignoreP2
        end
    end

    self:setGroups(collisionGroups)

    -- Sound
    local sound = playdate.sound.sampleplayer
    self.poseSound = sound.new('sounds/Place Bomb.wav')
    self.poseSound:setVolume(0.8)

    self.explodeSound = sound.new('sounds/Bomb Explodes.wav')
    self.explodeSound:setVolume(1)

    self.poseSound:play(1, 1)
end

function Bomb:update()
    Bomb.super.update(self)

    local sprites = self:overlappingSprites()

    local collideWithPlayer1, collideWithPlayer2 = false, false

    for i = 1, #sprites, 1 do
        if (sprites[i] == player1) then
            collideWithPlayer1 = true
        end
        if (sprites[i] == player2) then
            collideWithPlayer2 = true
        end
    end

    if maskContainsGroup(self:getGroupMask(), collisionGroup.ignoreP1) and collideWithPlayer1 == false then
        self:setGroupMask(self:getGroupMask() - bit(collisionGroup.ignoreP1))
    end

    if maskContainsGroup(self:getGroupMask(), collisionGroup.ignoreP2) and collideWithPlayer2 == false then
        self:setGroupMask(self:getGroupMask() - bit(collisionGroup.ignoreP2))
    end
end

function Bomb:explode()
    local canRight, canTop, canBot, canLeft = true, true, true, true

    print("Explode " .. self.i .. " : " .. self.j)
    self.explodeSound:play(1, 1)

    Explosion(self.i, self.j, explosionAnim.cross)

    for n = 1, self.explosionRange, 1 do
        local endAnim = n == self.explosionRange

        canBot = self:tryPoseExplosion(canBot, self.i, self.j + n, 0, 1, endAnim)
        canTop = self:tryPoseExplosion(canTop, self.i, self.j - n, 0, -1, endAnim)
        canRight = self:tryPoseExplosion(canRight, self.i + n, self.j, 1, 0, endAnim)
        canLeft = self:tryPoseExplosion(canLeft, self.i - n, self.j, -1, 0, endAnim)
    end

    self.player:removeBomb(self)
    self:remove()
end

function Bomb:tryPoseExplosion(canPose, i, j, iDir, jDir, endAnim)
    local breakableBlock = false

    -- Si peut poser, regarde si peu poser le suivant
    if canPose then
        canPose, breakableBlock = gameScene:isWalkable(i, j)
        if breakableBlock ~= nil then
            breakableBlock:breakBlock()
        end
    end

    if canPose == false then
        return false
    end

    local anim = explosionAnim.cross

    -- Fin a la case d'après
    if endAnim or gameScene:hasTypeAtCoordinates(i + iDir, j + jDir, Block) then
        anim = self:endExplosion(iDir, jDir)
    else
        -- Sinon
        anim = math.abs(iDir) > math.abs(jDir) and explosionAnim.horizontal or explosionAnim.vertical
    end

    Explosion(i, j, anim)
    return true
end

function Bomb:endExplosion(iDir, jDir)
    if iDir == 1 then
        return explosionAnim.right
    end
    if iDir == -1 then
        return explosionAnim.left
    end
    if jDir == 1 then
        return explosionAnim.bot
    end
    if jDir == -1 then
        return explosionAnim.top
    end

    return explosionAnim.cross
end
