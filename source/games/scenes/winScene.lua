WinScene = {}
class("WinScene").extends(NobleScene)

WinScene.baseColor = Graphics.kColorWhite

local menu
local sequence

function WinScene:init()
    WinScene.super.init(self)

    menu = Noble.Menu.new(false, Noble.Text.ALIGN_CENTER, false, Graphics.kColorWhite, 4, 6, 0, Noble.Text.FONT_SMALL)

    menu:addItem('Ⓐ Go to menu', function()
        Noble.transition(SimpleScene, 0.5, Noble.TransitionType.SLIDE_OFF_LEFT)
    end)

    WinScene.inputHandler = {
        AButtonDown = function()
            menu:click()
        end
    }
end

function WinScene:enter()
    WinScene.super.enter(self)

    playdate.graphics.setBackgroundColor(playdate.graphics.kColorWhite)

    sequence = Sequence.new():from(0):to(180, 1, Ease.outBounce)

    if sequence then sequence:start() end

    local sound = playdate.sound.sampleplayer
    self.backgroundMusic = sound.new('sounds/Stage Clear.wav')
    self.backgroundMusic:setVolume(0.8)
    self.backgroundMusic:play(1, 1)

    self.background = NobleSprite("images/You Win")

    self.background:add()
    self.background:moveTo(200, 120)
end

function WinScene:start()
    WinScene.super.start(self)

    menu:activate()
end

function WinScene:drawBackground()
    WinScene.super.drawBackground(self)
end

function WinScene:update()
    WinScene.super.update(self)
    menu:draw(200, sequence:get())
end

function WinScene:exit()
    WinScene.super.exit(self)
    sequence = Sequence.new():from(180):to(0, 0.25, Ease.inOutCubic)
    if sequence then sequence:start() end
    self.backgroundMusic:stop()
end

function WinScene:finish()
    WinScene.super.finish(self)
end