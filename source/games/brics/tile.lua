class('Tile').extends(AnimatedSprite)

tileSheetImagetable = playdate.graphics.imagetable.new('images/env-table-16-16.png')

function tileToPixel(i, j)
    return (i + 5) * 16 - 8, j * 16 - 8
end

function Tile:fixImage(imageIndex)
    local image = tileSheetImagetable:getImage(imageIndex)
    self:setImage(image)
end

function Tile:init(i, j)
    Tile.super.init(self, tileSheetImagetable)

    self.i = i
    self.j = j

    local x, y = tileToPixel(i, j)
    self:moveTo(x, y)
end