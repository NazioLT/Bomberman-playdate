class('Player').extends(AnimatedSprite)

playerImagetable = playdate.graphics.imagetable.new('images/character-table-32-32.png')

function Player:init()
    Player.super.init(self, playerImagetable, nil, nil)
end