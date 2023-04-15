class('Explosion').extends(GameObject)

explosionAnim =
{
    left = 1,
    horizontal = 2,
    cross = 3,
    right = 4,
    top = 5,
    vertical = 6,
    bot = 7,
}

function Explosion.new(i, j, animationShift)
    return Explosion(i, j, animationShift)
end

function Explosion:init(i, j, animationShift)
    Explosion.super.init(self, i, j, 3, true)

    self:setGroups(collisionGroup.explosion)

    self:setCollidesWithGroups({ collisionGroup.p1, collisionGroup.p2 })

    local animationTickStep = 3

    self:addState('Explosion', 1, 4, {
        tickStep = animationTickStep,
        loop = false,
        -- nextAnimation = 'BombFast',
        frames = { animationShift, 7 + animationShift, 14 + animationShift, 21 + animationShift }
    }).asDefault()

    self:playAnimation()

    self.states.Explosion.onAnimationEndEvent = function(self)
        -- map:removeExplosionGroup(self.i, self.j)
        self:remove()
    end

    local hasItemInCoord, item = gameScene:hasTypeAtCoordinates(self.i, self.j, Item)

    if hasItemInCoord then
        item:remove()
    end
end