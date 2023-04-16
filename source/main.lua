import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "libraries/noble/Noble"
import "libraries/animatedSprite/AnimatedSprite.lua"

import "games/library.lua"

import "games/scenes/simpleScene.lua"
import "games/scenes/gameScene.lua"
import "games/scenes/astarScene.lua"
import "games/scenes/winScene.lua"
import "games/scenes/loseScene.lua"

import "games/feedbacks/invertedCircle.lua"
import "games/feedbacks/shaker.lua"

import "games/player.lua"
import "games/map.lua"

import "games/brics/gameObject.lua"
import "games/brics/block.lua"
import "games/brics/unbreakableBlock.lua"
import "games/brics/bric.lua"
import "games/brics/empty.lua"
import "games/brics/floor.lua"
import "games/brics/bomb.lua"
import "games/brics/explosion.lua"

import "games/items/item.lua"
import "games/items/bombItem.lua"
import "games/items/powerItem.lua"
import "games/items/speedItem.lua"

import "games/ai/aiBehaviour.lua"
import "games/ai/aStar.lua"
import "games/ai/aStarNode.lua"
import "games/ai/stateMachine.lua"

Noble.new(SimpleScene)