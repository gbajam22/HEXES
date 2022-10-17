import natu/[math, graphics, video, utils, mgba]
import components/projectile/[bulletplayer, bulletenemy, enemy, modifier]
import components/shared
import utils/body

export bulletplayer, bulletenemy, enemy, modifier

var valueNumberStored*: int
var valueOperatorStored*: OperatorKind

proc destroy*() =
  bulletPlayerEntitiesInstances.clear()
  bulletEnemyEntitiesInstances.clear()
  enemyEntitiesInstances.clear()
  modifierEntitiesInstances.clear()

proc update*() =
  for modifier in mitems(modifierEntitiesInstances):
    if modifier.status == Active:
      modifier.update()

  for enemy in mitems(enemyEntitiesInstances):
    if enemy.status == Active:
      enemy.update()

  for bulletPlayer in mitems(bulletPlayerEntitiesInstances):
    if bulletPlayer.status == Active:
      bulletPlayer.update(speed = 2)
      for modifierBullet in mitems(modifierEntitiesInstances):
        if modifierBullet.status == Active:
          if collide(modifierBullet.body, bulletPlayer.body):
            if modifierBullet.kind == mkNumber:
              valueNumberStored = modifierBullet.valueNumber
            if modifierBullet.kind == mkOperator:
              valueOperatorStored = modifierBullet.valueOperator
            bulletPlayer.status = Finished
            modifierBullet.status = Finished

  for bulletEnemy in mitems(bulletEnemyEntitiesInstances):
    if bulletEnemy.status == Active:
      bulletEnemy.update(speed = 2)

  var indexFinishedMD = 0
  var indexFinishedEN = 0
  var indexFinishedBP = 0
  var indexFinishedBE = 0

  while indexFinishedMD < modifierEntitiesInstances.len:
    if modifierEntitiesInstances[indexFinishedMD].status == Finished:
      modifierEntitiesInstances.delete(indexFinishedMD)
    else:
      inc indexFinishedMD

  while indexFinishedEN < enemyEntitiesInstances.len:
    if enemyEntitiesInstances[indexFinishedEN].status == Finished:
      enemyEntitiesInstances.delete(indexFinishedEN)
    else:
      inc indexFinishedEN

  while indexFinishedBP < bulletPlayerEntitiesInstances.len:
    if bulletPlayerEntitiesInstances[indexFinishedBP].status == Finished:
      bulletPlayerEntitiesInstances.del(indexFinishedBP)
    else:
      inc indexFinishedBP

  while indexFinishedBE < bulletEnemyEntitiesInstances.len:
    if bulletEnemyEntitiesInstances[indexFinishedBE].status == Finished:
      bulletEnemyEntitiesInstances.del(indexFinishedBE)
    else:
      inc indexFinishedBE


proc draw*() =
  for bulletPlayer in mitems(bulletPlayerEntitiesInstances):
    bulletPlayer.draw()
  for bulletEnemy in mitems(bulletEnemyEntitiesInstances):
    bulletEnemy.draw()
  for enemy in mitems(enemyEntitiesInstances):
    enemy.draw()
  for modifier in mitems(modifierEntitiesInstances):
    modifier.draw()
