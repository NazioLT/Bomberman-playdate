class('Floor').extends(Tile)

function Floor.new(i, j)
    return Floor(i, j)
end

function Floor:init(i, j)
    Floor.super.init(self, i,j)

    self:fixImage(44)
end