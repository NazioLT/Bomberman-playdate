class('Bomb').extends(GameObject)

function Bomb.new(i, j)
    return Bomb(i, j)
end

function Bomb:init(i, j)
    Bomb.super.init(self, i, j, 5, true)

    self:fixImage(30)
end