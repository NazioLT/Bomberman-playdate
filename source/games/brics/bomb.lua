class('Bomb').extends(GameObject)

function Bomb.new(i, j)
    return Bomb(i, j)
end

function Bomb:init(i, j)
    Bomb.super.init(self, i, j, 5, true)

    self:addState('BombSpeed1', 29, 31, {
        tickStep = 5,
        yoyo = true
    }).asDefault()

    self:playAnimation()
end