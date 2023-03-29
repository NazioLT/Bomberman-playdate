class('Explosion').extends(GameObject)

function Explosion.new(i, j)
    return Explosion(i, j)
end

function Explosion:init(i, j)
    Explosion.super.init(self, i, j, 3, true)

    local animationTickStep = 5

    self:addState('Explosion', 1, 4, {
        tickStep = animationTickStep,
        loop = false,
        -- nextAnimation = 'BombFast',
        frames = { 3, 10, 17, 24 }
    }).asDefault()

    self:playAnimation()

    self.states.Explosion.onAnimationEndEvent = function(self)
        self:remove()
    end
end