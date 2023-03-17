class('Tile').extends(AnimatedSprite)

tileSheetImagetable = playdate.graphics.imagetable.new('images/env-table-16-16.png')

function Tile:init(i, j, imageIndex)
    Tile.super.init(self, tileSheetImagetable)

    self.i = i
    self.j = j

    local image = tileSheetImagetable:getImage(imageIndex)
    self:setImage(image)

    self:moveTo(100,020)
end