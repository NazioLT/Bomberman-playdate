class('Tile').extends(AnimatedSprite)

tileSheetImagetable = playdate.graphics.imagetable.new('images/env-table-16-16.png')

function Tile:fixImage(imageIndex)
    local image = tileSheetImagetable:getImage(imageIndex)
    self:setImage(image)
end

function Tile:init(i, j)
    Tile.super.init(self, tileSheetImagetable)

    self.i = i
    self.j = j

    self:moveTo(j * 16, i * 16)
end