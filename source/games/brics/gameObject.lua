class('GameObject').extends(AnimatedSprite)

tileSheetImagetable = playdate.graphics.imagetable.new('images/env-table-16-16.png')

collisionGroup = {
    player1 = 2,
    player2 = 3,
    bomb = 4,
    block = 5,
}

function tileToPixel(i, j)
    return (i + 5) * 16 - 8, j * 16 - 8
end

function pixelToTile(x, y)
    return math.floor((x - 8 - 16 * 5) / 16 + 1 + 0.5), math.floor((y - 8) / 16 + 1 + 0.5)
end

function GameObject:fixImage(imageIndex)
    local image = tileSheetImagetable:getImage(imageIndex)
    self:setImage(image)
end

function GameObject:init(i, j, zIndex, hasCollider)
    GameObject.super.init(self, tileSheetImagetable)

    self.i = i
    self.j = j

    local x, y = tileToPixel(i, j)
    self:moveTo(x, y)

    self:setZIndex(zIndex)
    if hasCollider then
        self:setCollideRect(0, 0, 16, 16)
    end
end