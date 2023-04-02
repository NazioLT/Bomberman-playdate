class('BombItem').extends(Item)

function BombItem.new(i, j)
    return BombItem(i, j)
end

function BombItem:init(i, j)
    BombItem.super.init(self, i, j)

    self:fixImage(40)
end