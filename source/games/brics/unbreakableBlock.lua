class('UnbreakableBlock').extends(Block)

function UnbreakableBlock.new(i, j)
    return UnbreakableBlock(i, j)
end

function UnbreakableBlock:init(i, j)
    UnbreakableBlock.super.init(self, i, j)

    self:setGroups({ collisionGroup.block })
    self:fixImage(43)
end