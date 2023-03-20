class('Block').extends(GameObject)

function Block:init(i, j)
    Block.super.init(self, i, j, 3, true)
end