class('SpeedItem').extends(Item)

function SpeedItem.new(i, j)
    return SpeedItem(i, j)
end

function SpeedItem:init(i, j)
    SpeedItem.super.init(self, i, j, 37)
end

function SpeedItem:pick(player)
    player.speed += 1
    print("ddd")
    
    SpeedItem.super.pick(self, player)
end