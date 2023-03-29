class('Bric').extends(Block)

function Bric.new(i, j)
    return Bric(i, j)
end

function Bric:init(i, j)
    Bric.super.init(self, i, j, true)

    self:fixImage(44)
end

function Bric:breakBlock()
    gameScene:remove(self.i, self.j, self)
    self:remove()
end