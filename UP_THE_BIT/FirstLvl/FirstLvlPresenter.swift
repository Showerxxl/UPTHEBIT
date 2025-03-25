import SpriteKit
import MediaPlayer

class FirstLvlPresenter {
    weak var view: FirstLvlView!
    var interactor: FirstLvlInteractor!
    var router: FirstLvlRouter!
    
    var isMovingRight = false
    var isMovingLeft = false
    let beatDuration: TimeInterval
    
    init(view: FirstLvlView, interactor: FirstLvlInteractor, router: FirstLvlRouter) {
        self.view = view
        self.interactor = interactor
        self.router = router
        let backgroundMusicBPM = 120.0
        self.beatDuration = 60.0 / backgroundMusicBPM
    }
    
    // Функция для ограничения позиции персонажа в пределах сцены
    private func clampPosition(_ node: SKSpriteNode, in frame: CGRect) {
        let halfWidth = node.size.width / 2
        let minX = frame.minX + halfWidth
        let maxX = frame.maxX - halfWidth
        

        if node.position.x < minX {
            node.position.x = minX
            node.physicsBody?.velocity.dx = 0
        } else if node.position.x > maxX {
            node.position.x = maxX
            node.physicsBody?.velocity.dx = 0
        }
    }
    
    func backButtonPressed() {
        MPMusicPlayerController.applicationMusicPlayer.stop()
        router.navigateToMapScene()
    }
    
    func startMovingRight() {
        isMovingRight = true
    }
    
    func stopMovingRight() {
        isMovingRight = false
    }
    
    func startMovingLeft() {
        isMovingLeft = true
    }
    
    func stopMovingLeft() {
        isMovingLeft = false
    }
    
    func jump() {
        view.performJumpAction()
    }
    
    func swordPressed() {
        view.performSwordAttack()
        let dx = view.warrior.position.x - view.troop.position.x
        let dy = view.warrior.position.y - view.troop.position.y
        let distance = sqrt(dx * dx + dy * dy)
        if interactor.handleSwordHit(distance: distance) {
            view.removeTroop()
        } else if distance <= 120 {
            let direction: CGFloat = view.troop.position.x >= view.warrior.position.x ? 1 : -1
            view.bounceTroop(direction: direction)
        }
    }
    
    func update(_ currentTime: TimeInterval) {
        if isMovingRight {
            view.updateWarriorVelocity(dx: 100)
            view.updateWarriorScale(xScale: abs(view.warrior.xScale))
        } else if isMovingLeft {
            view.updateWarriorVelocity(dx: -100)
            view.updateWarriorScale(xScale: -abs(view.warrior.xScale))
        } else {
            view.updateWarriorVelocity(dx: 0)
        }
        
        if isMovingRight || isMovingLeft {
            view.runWarriorRunAnimation()
        } else {
            view.stopWarriorRunAnimation()
        }
        
        let warriorLeft = view.warrior.position.x - view.warrior.size.width / 2 + 25
        let warriorRight = view.warrior.position.x + view.warrior.size.width / 2 - 25
        let troopLeft = view.troop.position.x - view.troop.size.width / 2 + 25
        let troopRight = view.troop.position.x + view.troop.size.width / 2 - 25
        
        var gap: CGFloat = 0
        if warriorRight < troopLeft {
            gap = troopLeft - warriorRight
        } else if troopRight < warriorLeft {
            gap = warriorLeft - troopRight
        }
        
        if gap <= 0 {
            view.troop.removeAction(forKey: "runAnimation")
            if view.troop.action(forKey: "attackAnimation") == nil, !view.troopAttackFrames.isEmpty {
                let attackAction = SKAction.repeatForever(SKAction.animate(with: view.troopAttackFrames, timePerFrame: 0.1))
                view.troop.run(attackAction, withKey: "attackAnimation")
            }
        } else {
            if view.troop.action(forKey: "attackAnimation") != nil {
                view.troop.removeAction(forKey: "attackAnimation")
            }
            let chaseSpeed: CGFloat = 2.0
            if view.troop.position.x < view.warrior.position.x + view.warrior.size.width / 2 {
                view.troop.position.x += chaseSpeed
                view.troop.xScale = abs(view.troop.xScale)
            } else if view.troop.position.x > view.warrior.position.x + view.warrior.size.width / 2 {
                view.troop.position.x -= chaseSpeed
                view.troop.xScale = -abs(view.troop.xScale)
            }
            if !view.troopRunFrames.isEmpty, view.troop.action(forKey: "attackAnimation") == nil, view.troop.action(forKey: "runAnimation") == nil {
                let runAction = SKAction.animate(with: view.troopRunFrames, timePerFrame: 0.1)
                view.troop.run(SKAction.repeatForever(runAction), withKey: "runAnimation")
            }
        }
        
        clampPosition(view.warrior, in: view.frame)
        clampPosition(view.troop, in: view.frame)
    }
    
    func didBeginContact(_ contact: SKPhysicsContact) {
        let warriorCategory = 0x1 << 0
        let troopCategory = 0x1 << 2
        
        if (contact.bodyA.categoryBitMask == warriorCategory && contact.bodyB.categoryBitMask == troopCategory) ||
           (contact.bodyA.categoryBitMask == troopCategory && contact.bodyB.categoryBitMask == warriorCategory) {
            let currentTime = CACurrentMediaTime()
            if interactor.handleCollision(currentTime: currentTime) {
                router.navigateToMapScene()
            } else {
                let direction: CGFloat = view.warrior.position.x >= view.troop.position.x ? 1 : -1
                view.bounceWarrior(direction: direction)
                let newWidth = CGFloat(interactor.warriorLives) * (270.0 / 5.0)
                view.updateHealthBar(width: newWidth)
            }
        }
    }
}
