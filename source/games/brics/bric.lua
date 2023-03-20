class('Bric').extends(Block)

function Bric.new(i, j)
    return Bric(i, j)
end

function Bric:init(i, j)
    Bric.super.init(self, i, j)

    self:fixImage(44)
end