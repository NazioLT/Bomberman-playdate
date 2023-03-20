class('Empty').extends(GameObject)

function Empty.new(i, j)
    return Empty(i, j)
end

function Empty:init(i, j)
    Empty.super.init(self, i, j, 3, false)
end