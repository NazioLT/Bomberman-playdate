class('Floor').extends(Empty)

function Floor.new(i, j)
    return Floor(i, j)
end

function Floor:setShadow(hasShadow)
    local index = hasShadow and 48 or 49
    self:fixImage(index)
end

function Floor:init(i, j)
    Floor.super.init(self, i, j)
    self:fixImage(49)
end