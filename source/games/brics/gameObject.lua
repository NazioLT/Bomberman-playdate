class('GameObject').extends(AnimatedSprite)

tileSheetImagetable = playdate.graphics.imagetable.new('images/env-table-16-16.png')

collisionGroup = {
    p1 = 1,
    p2 = 2,
    bomb = 3,
    block = 4,
    item = 5,
    ignoreP1 = 6,
}

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
        self:createCollider()
    end
end

function GameObject:createCollider()
    self:setCollideRect(0, 0, 16, 16)
end