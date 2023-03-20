class('Block').extends(GameObject)

function Block:init(i, j, isShiftBlock)
    Block.super.init(self, i, j, 3, true)

    if isShiftBlock == true then
        self:setGroups(collisionGroup.shiftBlock)
    else
        self:setGroups(collisionGroup.block)
    end

end