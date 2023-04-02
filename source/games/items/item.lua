class('Item').extends(GameObject)

function Item:init(i, j, imageID)
    Item.super.init(self, i, j, 2, true)

    self:setGroups(collisionGroup.item)
    self:setCollidesWithGroups( { collisionGroup.p1, collisionGroup.p2 } )
    self:fixImage(imageID)
end

function Item:createCollider()
    self:setCollideRect(3, 3, 10, 10)
end

function Item:pick(player)
    print("Pick Item")
    self:remove()
end