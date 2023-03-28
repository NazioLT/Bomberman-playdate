class('Bomb').extends(GameObject)

function Bomb.new(i, j, player)
    return Bomb(i, j, player)
end

function Bomb:init(i, j, player)
    Bomb.super.init(self, i, j, 5, true)

    self.player = player

    local animationTickStep = 50

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

    self:playAnimation()

    self.states.BombFast.onAnimationEndEvent = function(self)
        self:explode()
    end

    self:setCollidesWithGroups({ collisionGroup.p1, collisionGroup.p2, collisionGroup.bomb, collisionGroup.item,
    collisionGroup.block })

    local collisionGroups = { collisionGroup.bomb }

    self.p1CollEnabled = false;
    self.p2CollEnabled = false;

    local overlappingSprites = self:overlappingSprites()

    for i = 1, #overlappingSprites, 1 do
        if (overlappingSprites[i] == player1) then
            collisionGroups[#collisionGroups + 1] = collisionGroup.ignoreP1
            print("1")
        end

        if (overlappingSprites[i] == player2) then
            collisionGroups[#collisionGroups + 1] = collisionGroup.ignoreP2
        end
    end

    self:setGroups(collisionGroups)
end

function Bomb:update()
    Bomb.super.update(self)

    local sprites = self:overlappingSprites()

    local collideWithPlayer1, collideWithPlayer2 = false, false

    for i = 1, #sprites, 1 do
        if (sprites[i] == player1) then
            collideWithPlayer1 = true
            print("ee")
        end
        if (sprites[i] == player2) then
            collideWithPlayer2 = true
        end
    end

    if maskContainsGroup(self:getGroupMask(), collisionGroup.ignoreP1) and collideWithPlayer1 == false then
        self:setGroupMask(self:getGroupMask() - bit(collisionGroup.ignoreP1))
    end

    -- if maskContainsGroup(self:getGroupMask(), collisionGroup.ignoreP2) and collideWithPlayer2 == false then
    --     self:setGroupMask(self:getGroupMask() - bit(collisionGroup.ignoreP2))
    -- end
end

function Bomb:explode()
    self.player:removeBomb(self)
    self:remove()
end
