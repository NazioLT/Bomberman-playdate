class('BombItem').extends(Item)

function BombItem.new(i, j)
    return BombItem(i, j)
end

function BombItem:init(i, j)
    BombItem.super.init(self, i, j, 40)
end

function BombItem:pick(player)
    player.nbBombMax += 1
    
    BombItem.super.pick(self, player)
end