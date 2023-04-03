class('AIBehaviour').extends(NobleSprite)

states = 
{
    Idle = 1,
    Esquive = 2,
    GoToPlayer = 4,
    PoseBomb = 3,
}

function AIBehaviour:init(player)
    AIBehaviour.super.init(self)

    self.player = player
end