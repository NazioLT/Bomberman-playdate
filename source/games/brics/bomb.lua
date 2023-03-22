class('Bomb').extends(GameObject)

function Bomb.new(i, j)
    return Bomb(i, j)
end

function Bomb:init(i, j)
    Bomb.super.init(self, i, j, 5, true)

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

    self.states.BombFast.onAnimationEndEvent = function (self)
        self:explode()
    end
end

function Bomb:explode()
    self:remove()
end