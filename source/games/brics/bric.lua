class('Bric').extends(Block)

function Bric.new(i, j)
    return Bric(i, j)
end

function Bric:init(i, j)
    Bric.super.init(self, i, j, true)

    self:fixImage(44)
end

function Bric:breakBlock()
    local animationTickStep = 7

    self:addState('Destroy', 1, 3, {
        tickStep = animationTickStep,
        loop = false,
        frames = { 45, 46, 47 }
    }).asDefault()

    self:playAnimation()

    self.states.Destroy.onAnimationEndEvent = function(self)
        gameScene:remove(self.i, self.j, self)
        gameScene:breakBric(self.i, self.j)
        map:checkIfHasItem(self.i, self.j)
        map:checkAIPlayerPath()

        self:remove()
    end
end