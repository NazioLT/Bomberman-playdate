class('UnbreakableBlock').extends(Block)

function UnbreakableBlock.new(i, j, isShiftBlock)
    return UnbreakableBlock(i, j, isShiftBlock)
end

function UnbreakableBlock:init(i, j)
    UnbreakableBlock.super.init(self, i, j)

    self:setGroups({ collisionGroup.block })
    self:fixImage(43)
end