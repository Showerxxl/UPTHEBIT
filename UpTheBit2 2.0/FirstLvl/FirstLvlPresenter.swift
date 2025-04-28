import SpriteKit
import MediaPlayer


class FirstLvlPresenter {
    weak var view: FirstLvlView!
    var interactor: FirstLvlInteractor!
    var router: FirstLvlRouter!
    

    var beatDuration: TimeInterval
    

    private var activeEnemyIndex: Int = 0
    

    private var lastTroopSpawnTime: TimeInterval = 0
    private let troopSpawnInterval: TimeInterval = 3.0
    private var troopSpawnCounter: Int = 0
    private var initialSpawnComplete: Bool = false
    private let maxTroopSpawns: Int = 5
    
    private var lastSwordPressTime: TimeInterval = 0
    
    var currentBpm: Int {
        guard beatDuration > 0 else { return 0 }
        return Int(60.0 / beatDuration)
    }
    
    init(view: FirstLvlView, interactor: FirstLvlInteractor, router: FirstLvlRouter) {
        
        self.view = view
        self.interactor = interactor
        self.router = router
        self.interactor.view = view

        self.beatDuration = 0.5

        interactor.updateBPM { [weak self] duration in
            self?.beatDuration = duration
            print("Presenter: beatDuration updated to \(duration)")
        }
        lastTroopSpawnTime = CACurrentMediaTime()
        print("Initial spawn time set: \(lastTroopSpawnTime)")
        self.interactor.presenter = self
    }


    
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
    
   
    
    func runWarriorRunAnimation() {

        if view.warrior.action(forKey: "runAnimation") == nil, !view.warriorRunFrames.isEmpty {
            let runAction = SKAction.animate(with: view.warriorRunFrames, timePerFrame: 0.1)
            view.warrior.run(SKAction.repeatForever(runAction), withKey: "runAnimation")
        }
    }

    func stopWarriorRunAnimation() {
        view.warrior.removeAction(forKey: "runAnimation")

        if let staticTexture = view.warriorRunFrames.first {
            view.warrior.texture = staticTexture
        }
    }
    
    func performJumpAction() {

        guard view.isWarriorOnGround else {
            print("[JUMP] Прыжок недоступен — воин не на платформе")
            return
        }
        if !view.warriorJumpFrames.isEmpty {
            let jumpAnimation = SKAction.animate(with: view.warriorJumpFrames, timePerFrame: 0.15)
            let restoreRunTexture = SKAction.run { [weak self] in
                if FirstLvlInteractor.isMovingLeft || FirstLvlInteractor.isMovingRight {
      
                } else if let staticTexture = self?.view.warriorRunFrames.first {
                    self?.view.warrior.texture = staticTexture
                }
            }
            view.warrior.run(SKAction.sequence([jumpAnimation, restoreRunTexture]), withKey: "jumpAnimation")
        }
        view.warrior.physicsBody?.applyImpulse(CGVector(dx: 0, dy: view.frame.height * 0.9))
    }
    
    func performSwordAttack() {

        if !view.warriorAttackFrames.isEmpty {
            let attackAction = SKAction.animate(with: view.warriorAttackFrames, timePerFrame: 0.1)
            let restoreRunTexture = SKAction.run { [weak self] in
                if FirstLvlInteractor.isMovingLeft || FirstLvlInteractor.isMovingRight {
          
                } else if let staticTexture = self?.view.warriorRunFrames.first {
                    self?.view.warrior.texture = staticTexture
                }
            }
            view.warrior.run(SKAction.sequence([attackAction, restoreRunTexture]), withKey: "attackAnimation")
        }
    }

    
    func bounceWarrior(from attackSourceX: CGFloat) {
        guard let warriorBody = view.warrior.physicsBody else { return }
        let warriorX = view.warrior.position.x


        let dx = warriorX - attackSourceX
        let bounceDirection: CGFloat
        if abs(dx) < 2.0 {
         
            bounceDirection = (view.warrior.xScale >= 0) ? 1 : -1
        } else {
            bounceDirection = dx > 0 ? 1 : -1
        }

        let impulseX: CGFloat = 50.0 * bounceDirection
        let impulseY: CGFloat = 50.0

 
        warriorBody.velocity = .zero
        warriorBody.applyImpulse(CGVector(dx: impulseX * 10, dy: impulseY))
        print("[BOUNCE] Warrior отскочил от трупа (отскок по X: \(impulseX), Y: \(impulseY))")
    }

    
    
    
    
    func jump() {
        performJumpAction()
    }
    
    func swordPressed() {
        let currentTime = CACurrentMediaTime()
        if currentTime - lastSwordPressTime < 1.0 {

            print("[COOLDOWN] Sword is on cooldown, wait a moment.")
            return
        }
        lastSwordPressTime = currentTime
        performSwordAttack()
        let attackAnimationDuration = 0.1 * Double(view.warriorAttackFrames.count)
        DispatchQueue.main.asyncAfter(deadline: .now() + attackAnimationDuration) { [weak self] in
            guard let self = self else { return }
            self.interactor.handleSwordHitAndBounce(presenter: self)
        }
    }



    

    
    func removeTroopSprite(at index: Int) {
        guard let troopNode = view.children.first(where: { $0.name == "troop_\(index)" }) as? SKSpriteNode else {
            print("[REMOVE PRESENTER] Не удалось найти troop_\(index) для удаления")
            return
        }
        troopNode.removeFromParent()
        print("[REMOVE PRESENTER] troop_\(index) удалён со сцены (SpriteNode). Данные Troop.troopsData не изменены.")
        let hasTroops = view.children.contains { $0.name?.starts(with: "troop_") ?? false }
       
        let allTroopsSpawned = (troopSpawnCounter >= maxTroopSpawns)
        if allTroopsSpawned && !hasTroops {
            incrementPlayerCoinsOnLevelComplete()
            UserDefaults.standard.set(true, forKey: "firstLevelComplete")
            MPMusicPlayerController.applicationMusicPlayer.stop()
           
            view.showYouWinAndTransition()

        }
    }
    private func incrementPlayerCoinsOnLevelComplete() {
        let coinKey = "coinCount"
        let currentCoins = UserDefaults.standard.integer(forKey: coinKey)
        let newCoins = currentCoins + 5000
        UserDefaults.standard.set(newCoins, forKey: coinKey)
        print("[LEVEL COMPLETE] Монеты игрока увеличены на 5000, теперь: \(newCoins)")
    }
    
    private func spawnTroopAtIndex(_ index: Int) {
        guard Troop.troopsData.indices.contains(index) else { return }
        view.addTroopToScene(troopData: Troop.troopsData, index: index)
    }
    
    
    func update(_ currentTime: TimeInterval) {
        if troopSpawnCounter < maxTroopSpawns {
            let elapsedTime = currentTime - lastTroopSpawnTime
            if elapsedTime >= troopSpawnInterval {
                lastTroopSpawnTime = currentTime
           
                spawnTroopAtIndex(troopSpawnCounter)
                troopSpawnCounter += 1
            }
        }
        
        if FirstLvlInteractor.isMovingRight {
            interactor.updateWarriorVelocity(dx: 100)
            interactor.updateWarriorScale(xScale: abs(view.warrior.xScale))
        } else if FirstLvlInteractor.isMovingLeft {
            interactor.updateWarriorVelocity(dx: -100)
            interactor.updateWarriorScale(xScale: -abs(view.warrior.xScale))
        } else {
            interactor.updateWarriorVelocity(dx: 0)
        }
        
        if FirstLvlInteractor.isMovingRight || FirstLvlInteractor.isMovingLeft {
            runWarriorRunAnimation()
        } else {
            stopWarriorRunAnimation()
        }
        
        

        clampPosition(view.warrior, in: view.frame)
        
        
     
        if !initialSpawnComplete && currentTime > lastTroopSpawnTime + 1.0 {
            lastTroopSpawnTime = currentTime
            initialSpawnComplete = true
        }
    }

}
