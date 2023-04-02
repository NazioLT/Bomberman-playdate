class('PowerItem').extends(Item)

function PowerItem.new(i, j)
    return PowerItem(i, j)
end

function PowerItem:init(i, j)
    PowerItem.super.init(self, i, j, 41)
end

function PowerItem:pick(player)
    player.explosionRange += 1
    
    PowerItem.super.pick(self, player)
end