LoseScene = {}
class("LoseScene").extends(NobleScene)

LoseScene.baseColor = Graphics.kColorWhite

local menu
local sequence

function LoseScene:init()
    LoseScene.super.init(self)

    menu = Noble.Menu.new(false, Noble.Text.ALIGN_CENTER, false, Graphics.kColorWhite, 4, 6, 0, Noble.Text.FONT_SMALL)

    menu:addItem('Ⓐ Go to menu', function()
        Noble.transition(SimpleScene, 0.5, Noble.TransitionType.SLIDE_OFF_LEFT)
    end)

    LoseScene.inputHandler = {
        AButtonDown = function()
            menu:click()
        end
    }
end

function LoseScene:enter()
    LoseScene.super.enter(self)

    playdate.graphics.setBackgroundColor(playdate.graphics.kColorWhite)

    sequence = Sequence.new():from(0):to(180, 1, Ease.outBounce)

    if sequence then sequence:start() end

    local sound = playdate.sound.sampleplayer
    self.backgroundMusic = sound.new('sounds/Uiteru V Damage.wav')
    self.backgroundMusic:setVolume(0.9)
    self.backgroundMusic:play(1, 1)

    self.background = NobleSprite("images/Game Over")

    self.background:add()
    self.background:moveTo(200, 120)
end

function LoseScene:start()
    LoseScene.super.start(self)

    menu:activate()
end

function LoseScene:drawBackground()
    LoseScene.super.drawBackground(self)
end

function LoseScene:update()
    LoseScene.super.update(self)
    menu:draw(200, sequence:get())
end

function LoseScene:exit()
    LoseScene.super.exit(self)
    sequence = Sequence.new():from(180):to(0, 0.25, Ease.inOutCubic)
    if sequence then sequence:start() end
    self.backgroundMusic:stop()
end

function LoseScene:finish()
    LoseScene.super.finish(self)
end