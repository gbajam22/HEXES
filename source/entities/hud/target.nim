import natu/[math, graphics, video, tte, posprintf]
import utils/objs
import types/[hud, scenes]

proc initTarget*(target: int): Target =
  result.initialised = true
  result.target = target

  result.label.init(vec2i(ScreenWidth div 12, ScreenHeight - 16), s8x16, count = 16)
  result.label.obj.pal = acquireObjPal(gfxShipPlayer)
  result.label.ink = 2 # set the ink colour index to use from the palette
  result.label.shadow = 0 # set the shadow colour (only relevant if the font actually has more than 1 colour)


proc draw*(self: var Target, gameState: GameState) =
  if gameState == Play or gameState == Intro:
    self.label.draw()

    let size = tte.getTextSize(addr self.labelBuffer)
    self.label.pos = vec2i(ScreenWidth div 12 - size.x div 2,
      ScreenHeight - 16 - size.y div 2)

    if gameState != Intro:
      posprintf(addr self.labelBuffer, "$%X", self.target)
      self.label.put(addr self.labelBuffer)
