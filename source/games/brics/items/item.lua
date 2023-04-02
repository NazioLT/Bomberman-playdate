class('Item').extends(GameObject)

function Item:init(i, j)
    Item.super.init(self, i, j, 2, true)

    self:setGroups(collisionGroup.item)
    self:setCollidesWithGroups( { collisionGroup.p1, collisionGroup.p2 } )
end

function Item:createCollider()
    self:setCollideRect(2, 2, 12, 12)
end

function Item:pick(player)
    print("Pick Item")
    self:remove()
end