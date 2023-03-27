class('Bomb').extends(GameObject)

function Bomb.new(i, j, player)
    return Bomb(i, j, player)
end

function Bomb:init(i, j, player)
    Bomb.super.init(self, i, j, 5, true)

    self.player = player

    local animationTickStep = 10

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

    local collideP1, collideP2 = false, false

    if player1 ~= nil then
        local pi, pj = pixelToTile(player1.x, player1.y)
        if pi == i and pj == j then
            collideP1 = true
        end
    end

    if player2 ~= nil then
        local pi, pj = pixelToTile(player2.x, player2.y)
        if pi == i and pj == j then
            collideP2 = true
        end
    end

    local collisionGroups = { collisionGroup.bomb }

    if collideP1 == false then
        collisionGroups[#collisionGroups + 1] = collisionGroup.p1Collide
    end

    if collideP2 == false then
        collisionGroups[#collisionGroups + 1] = collisionGroup.p2Collide
    end

    self:setGroups(collisionGroups)
end

function Bomb:update()
    Bomb.super.update(self)

    
end

function Bomb:explode()
    self.player:removeBomb(self)
    self:remove()
end
