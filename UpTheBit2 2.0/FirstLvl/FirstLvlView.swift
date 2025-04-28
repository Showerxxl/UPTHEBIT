
import SpriteKit
import GameplayKit
import AVFoundation
import MediaPlayer

class FirstLvlView: SKScene, SKPhysicsContactDelegate {
    
    var backButton: SKSpriteNode!
    var background: SKSpriteNode!
    var warrior: SKSpriteNode!
    
    
    
    
    
    var rightbutton: SKSpriteNode!
    var leftbutton: SKSpriteNode!
    var jump: SKSpriteNode!
    var ground: SKSpriteNode!
    var ground1: SKSpriteNode!
    var ground2: SKSpriteNode!
    var ground3: SKSpriteNode!
    var barHealth1: SKSpriteNode!
    var barHealth: SKSpriteNode!
    var health: SKSpriteNode!
    var sword: SKSpriteNode!
    var healthScale: SKSpriteNode!
    
    var isWarriorOnGround: Bool = false
    
    var healthBarWidth: CGFloat = 100.0
    var healthLabel: SKLabelNode!
    
   
    var warriorRunFrames: [SKTexture] = []
    var warriorAttackFrames: [SKTexture] = []
    var warriorJumpFrames: [SKTexture] = []
    var troopRunFrames: [SKTexture] = []
    var troopAttackFrames: [SKTexture] = []
    
 
    var presenter: FirstLvlPresenter!
    var interactor: FirstLvlInteractor!
    var router: FirstLvlRouter!
    
    var bpmLabel: SKLabelNode!
    
    override func didMove(to view: SKView) {
        self.view?.showsPhysics = false
        self.view?.isMultipleTouchEnabled = true
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -2)
        self.physicsWorld.contactDelegate = self
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody?.categoryBitMask = 0x1 << 1

        
        setupScene()
        setupControls()
        setupPlatforms()
        setupHealthBar()
        setupBpmLabel()
        setupAnimations()
        configurePlatform(ground1)
        configurePlatform(ground2)
        configurePlatform(ground3)
        interactor.setUpTroopsData()
    }
    private func setupBpmLabel() {
        bpmLabel = SKLabelNode(fontNamed: UIFont.pixelFontName)
        bpmLabel.fontSize = 14
        bpmLabel.fontColor = SKColor(red: 0.96, green: 0.96, blue: 0.86, alpha: 1.0)
        bpmLabel.horizontalAlignmentMode = .center
        bpmLabel.verticalAlignmentMode = .center
        bpmLabel.zPosition = 22
        
    
        let offsetY: CGFloat = -28
        bpmLabel.position = CGPoint(x: barHealth1.position.x,
                                    y: barHealth1.position.y + offsetY)
        

        let bpmValue = presenter?.currentBpm ?? 0
        bpmLabel.text = "BPM: \(bpmValue)"
        
        addChild(bpmLabel)
    }
    
    func addTroopToScene(troopData: [TroopData], index: Int) {
        let troop = SKSpriteNode(imageNamed: "troop")
        troop.position = troopData[index].position
        troop.size = troopData[index].size
        troop.zPosition = 15
        troop.name = troopData[index].name
        troop.physicsBody = SKPhysicsBody(texture: troop.texture!, size: troop.size)
        troop.physicsBody?.affectedByGravity = true
        troop.physicsBody?.isDynamic = true
        troop.physicsBody?.allowsRotation = false
        troop.physicsBody?.categoryBitMask = 0x1 << 2

        troop.physicsBody?.collisionBitMask = (0x1 << 1) | (0x1 << 2)
        troop.physicsBody?.contactTestBitMask = 0x1 << 0

        
        addChild(troop)
    }
    

    private func setupScene() {
        background = SKSpriteNode(imageNamed: "firstLvlBg")
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.size = CGSize(width: frame.width, height: frame.height)
        background.zPosition = -1
        addChild(background)
        
        let backButtonSize = frame.width * 0.07
        backButton = SKSpriteNode(imageNamed: "QuitIcon")
        backButton.size = CGSize(width: backButtonSize, height: backButtonSize)
        backButton.position = CGPoint(x: frame.maxX - backButton.size.width / 2 - 50, y: frame.maxY - backButton.size.height / 2 - 20)
        backButton.zPosition = 20
        addChild(backButton)
        
        warrior = SKSpriteNode(imageNamed: "warrior")
        warrior.position = CGPoint(x: frame.midX - 150, y: frame.midY)
        warrior.size = CGSize(width: 118, height: 115)
        warrior.zPosition = 15 // Above platforms
        warrior.physicsBody = SKPhysicsBody(texture: warrior.texture!, size: warrior.size)
        warrior.physicsBody?.affectedByGravity = true
        warrior.physicsBody?.isDynamic = true
        warrior.physicsBody?.allowsRotation = false
        warrior.physicsBody?.categoryBitMask = 0x1 << 0
        warrior.physicsBody?.collisionBitMask = (0x1 << 1)
        warrior.physicsBody?.contactTestBitMask = 0x1 << 2
        warrior.physicsBody?.contactTestBitMask = 0x1 << 1
        warrior.physicsBody?.linearDamping = 1.8
        Warrior.xPosition = frame.midX - 150
        Warrior.yPosition = frame.midY
        Warrior.reloadHealthFromDefaults()
        addChild(warrior)
    }
    
    
    
    
    private func setupControls() {
        leftbutton = SKSpriteNode(imageNamed: "leftMove")
        leftbutton.position = CGPoint(x: frame.midX * 0.2, y: frame.midY * 0.3)
        leftbutton.size = CGSize(width: frame.height * 0.2, height: frame.height * 0.2)
        leftbutton.zPosition = 2
        leftbutton.alpha = 0.5
        addChild(leftbutton)
        
        rightbutton = SKSpriteNode(imageNamed: "rightMove")
        rightbutton.position = CGPoint(x: frame.midX * 0.65, y: frame.midY * 0.3)
        rightbutton.size = CGSize(width: frame.height * 0.2, height: frame.height * 0.2)
        rightbutton.zPosition = 2
        rightbutton.alpha = 0.5
        addChild(rightbutton)
        
        sword = SKSpriteNode(imageNamed: "sword")
        sword.position = CGPoint(x: frame.midX * 1.4, y: frame.midY * 0.35)
        sword.size = CGSize(width: frame.height * 0.2, height: frame.height * 0.2)
        sword.zPosition = 2
        sword.alpha = 0.5
        addChild(sword)
        
        jump = SKSpriteNode(imageNamed: "jump")
        jump.position = CGPoint(x: frame.midX * 1.7, y: frame.midY * 0.35)
        jump.size = CGSize(width: frame.height * 0.175, height: frame.height * 0.25)
        jump.zRotation = CGFloat.pi / 2
        jump.zPosition = 2
        jump.alpha = 0.5
        addChild(jump)
    }
    
    
    
    
    
    
    private func setupPlatforms() {
        ground = SKSpriteNode(imageNamed: "ground")
        ground.size = CGSize(width: frame.width, height: 70)
        ground.position = CGPoint(x: frame.midX, y: frame.minY + ground.size.height / 2 + 10)
        ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.categoryBitMask = 0x1 << 1
        ground.zPosition = 1
        addChild(ground)
        
        func setupPlatformPhysics(_ platform: SKSpriteNode) {
            platform.physicsBody = SKPhysicsBody(rectangleOf: platform.size)
            platform.physicsBody?.isDynamic = false
            platform.physicsBody?.categoryBitMask = 0x1 << 1
        }
        
        ground1 = SKSpriteNode(imageNamed: "ground1")
        ground1.position = CGPoint(x: frame.midX + 50, y: frame.midY)
        ground1.size = CGSize(width: 1000, height: 800)
        ground1.zPosition = 1
        addChild(ground1)
        setupPlatformPhysics(ground1)
        
        ground2 = SKSpriteNode(imageNamed: "ground2")
        ground2.position = CGPoint(x: frame.midX + 250, y: frame.midY - 20)
        ground2.size = CGSize(width: 1000, height: 800)
        ground2.zPosition = 1
        addChild(ground2)
        setupPlatformPhysics(ground2)
        
        ground3 = SKSpriteNode(imageNamed: "ground3")
        ground3.position = CGPoint(x: frame.midX - 300, y: frame.midY + 20)
        ground3.size = CGSize(width: 1000, height: 800)
        ground3.zPosition = 1
        addChild(ground3)
        setupPlatformPhysics(ground3)
    }
    
    private func setupHealthBar() {
        let topPadding: CGFloat = 20
        let leftPadding: CGFloat = 50
        let spacing: CGFloat = 10
        let barWidth = frame.width * 0.3
        let barHeight = barWidth * 0.1
        let iconSize = CGSize(width: barHeight, height: barHeight)
        
        barHealth1 = SKSpriteNode(imageNamed: "barHealth")
        barHealth1.size = CGSize(width: barWidth, height: barHeight)
        barHealth1.position = CGPoint(x: frame.minX + leftPadding + barHealth1.size.width / 2, y: frame.maxY - topPadding - barHealth1.size.height / 2)
        barHealth1.zPosition = 20
        addChild(barHealth1)
        

        healthBarWidth = barHealth1.size.width
        
        health = SKSpriteNode(imageNamed: "health")
        health.size = iconSize
        health.position = CGPoint(x: barHealth1.position.x - barHealth1.size.width / 2 - iconSize.width / 2 - spacing, y: barHealth1.position.y)
        health.zPosition = 20
        addChild(health)
        
        healthScale = SKSpriteNode(imageNamed: "healthScale")
        healthScale.anchorPoint = CGPoint(x: 0, y: 0.5)
        healthScale.position = CGPoint(x: -barHealth1.size.width/2 + 5, y: 0)
        healthScale.size = CGSize(width: barHealth1.size.width * 0.97, height: barHealth1.size.height * 0.55)
        healthScale.zPosition = 21
        barHealth1.addChild(healthScale)
        healthLabel = SKLabelNode(fontNamed: UIFont.pixelFontName)
    
        healthLabel.fontSize = 14
        healthLabel.fontColor = SKColor(red: 0.96, green: 0.96, blue: 0.86, alpha: 1.0)
        let currentHealth = UserDefaults.standard.integer(forKey: "playerHealth")
        healthLabel.text = "\(currentHealth)"
        healthLabel.horizontalAlignmentMode = .center
        healthLabel.verticalAlignmentMode = .center
        healthLabel.zPosition = 22
     
        healthLabel.position = CGPoint(x: 0, y: 0)
        barHealth1.addChild(healthLabel)
    }
    
    private func setupAnimations() {
        let warriorAtlas = SKTextureAtlas(named: "Warrior")
        warriorRunFrames = warriorAtlas.textureNames.filter { $0.contains("runs") }.sorted().map { warriorAtlas.textureNamed($0) }
        warriorAttackFrames = warriorAtlas.textureNames.filter { $0.contains("hit") }.sorted().map { warriorAtlas.textureNamed($0) }
        warriorJumpFrames = warriorAtlas.textureNames.filter { $0.contains("jump") }.sorted().map { warriorAtlas.textureNamed($0) }
        
        let troopAtlas = SKTextureAtlas(named: "Troop")
        troopRunFrames = troopAtlas.textureNames.filter { $0.contains("run") }.sorted().map { troopAtlas.textureNamed($0) }
        troopAttackFrames = troopAtlas.textureNames.filter { $0.contains("attack") }.sorted().map { troopAtlas.textureNamed($0) }
    }
    
    func playTroopAttackAnimation(index: Int, completion: (() -> Void)? = nil) {
        guard let troopNode = self.children.first(where: { $0.name == "troop_\(index)" }) as? SKSpriteNode else {
            completion?()
            return
        }
        let attackKey = "troopAttackAnimation"
        if troopNode.action(forKey: attackKey) != nil {
            completion?()
            return
        }
        guard !troopAttackFrames.isEmpty else {
            completion?()
            return
        }
        troopNode.removeAllActions()
        let attackAction = SKAction.animate(with: troopAttackFrames, timePerFrame: 0.1)
        let setFirstFrame = SKAction.setTexture(troopAttackFrames.first ?? troopNode.texture!)
        let completionAction = SKAction.run { completion?() }
        let sequence = SKAction.sequence([attackAction, setFirstFrame, completionAction])
        troopNode.run(sequence, withKey: attackKey)
    }
    
    
    private func configurePlatform(_ platform: SKSpriteNode) {
        if let texture = platform.texture {
            platform.physicsBody = SKPhysicsBody(texture: texture, size: platform.size)
        } else {
            platform.physicsBody = SKPhysicsBody(rectangleOf: platform.size)
        }
        platform.physicsBody?.isDynamic = false
        platform.physicsBody?.categoryBitMask = 0x1 << 1
        print("Beat duration: \(String(presenter.beatDuration))")
        let moveUp = SKAction.moveBy(x: 0, y: 50, duration: presenter.beatDuration)
        let moveDown = SKAction.moveBy(x: 0, y: -50, duration: presenter.beatDuration)
        let sequence = SKAction.sequence([moveUp, moveDown])
        platform.run(SKAction.repeatForever(sequence))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
        for touch in touches {
            let location = touch.location(in: self)
            
            if backButton.contains(location) {
                presenter.backButtonPressed()
            }
            if rightbutton.contains(location) {
                interactor.startMovingRight()
            }
            if leftbutton.contains(location) {
                interactor.startMovingLeft()
            }
            if jump.contains(location) {
                presenter.jump()
            }
            if sword.contains(location) {
                presenter.swordPressed()
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
  
        for touch in touches {
            let location = touch.location(in: self)
            
            if rightbutton.contains(location) {
                interactor.stopMovingRight()
            }
            if leftbutton.contains(location) {
                interactor.stopMovingLeft()
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        presenter.update(currentTime)
        interactor.syncWarriorCoordinates()
        interactor.updateTroopsCoordinates()
        interactor.moveTroopsTowardWarrior(currentTime: currentTime)
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        if isWarriorContactWithPlatform(bodyA: bodyA, bodyB: bodyB) {
            isWarriorOnGround = true
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        
        if isWarriorContactWithPlatform(bodyA: bodyA, bodyB: bodyB) {
            isWarriorOnGround = false
        }
    }
    
    private func isWarriorContactWithPlatform(bodyA: SKPhysicsBody, bodyB: SKPhysicsBody) -> Bool {
        let warriorCategory = UInt32(0x1 << 0)
        let platformCategory = UInt32(0x1 << 1)
        return (bodyA.categoryBitMask == warriorCategory && bodyB.categoryBitMask == platformCategory) ||
        (bodyB.categoryBitMask == warriorCategory && bodyA.categoryBitMask == platformCategory)
    }
    
    
    func removeTroop(_ troop: SKSpriteNode) {
        troop.removeFromParent()
    }
    
    func updateHealthBar(currentHealth: Int, maxHealth: Int) {
        if healthBarWidth <= 0 {
            healthBarWidth = barHealth1.size.width
        }
        let percent = CGFloat(currentHealth) / CGFloat(maxHealth)
        let minWidth: CGFloat = 2.0
        healthScale.size.width = max(minWidth, healthBarWidth * percent)

        healthLabel.text = "\(currentHealth)"
        
        if Warrior.health <= 0 {
            let musicPlayer = MPMusicPlayerController.applicationMusicPlayer
            musicPlayer.stop()
            self.showYouLoseAndTransition()
        }
    }
    
    func showYouLoseAndTransition() {
        
        let dimNode = SKSpriteNode(color: .black, size: CGSize(width: self.size.width, height: self.size.height))
        dimNode.alpha = 0.0
        dimNode.zPosition = 1000
        dimNode.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        self.addChild(dimNode)
        

        let loseLabel = SKLabelNode(text: "YOU LOSE!")
        loseLabel.fontName = "Alagard-12px-unicode"
        loseLabel.fontSize = 54
        loseLabel.fontColor = .white
        loseLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        loseLabel.zPosition = dimNode.zPosition + 1
        loseLabel.alpha = 0.0
        self.addChild(loseLabel)
        
       
        let fadeIn = SKAction.fadeAlpha(to: 0.72, duration: 0.4)
        let textIn = SKAction.fadeAlpha(to: 1.0, duration: 0.25)
        dimNode.run(fadeIn)
        loseLabel.run(SKAction.sequence([SKAction.wait(forDuration: 0.15), textIn]))
        
       
        let transitionDelay = SKAction.wait(forDuration: 2.0)
        let transitionToMap = SKAction.run { [weak self] in
            self?.router?.navigateToMapScene()
        }
        self.run(SKAction.sequence([transitionDelay, transitionToMap]))
    }
    
    func showYouWinAndTransition() {

        let dimNode = SKSpriteNode(color: .black, size: CGSize(width: self.size.width, height: self.size.height))
        dimNode.alpha = 0.0
        dimNode.zPosition = 1000
        dimNode.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        self.addChild(dimNode)
        
 
        let winLabel = SKLabelNode(text: "YOU WIN!")
        winLabel.fontName = "Alagard-12px-unicode"
        winLabel.fontSize = 54
        winLabel.fontColor = .white
        winLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        winLabel.zPosition = dimNode.zPosition + 1
        winLabel.alpha = 0.0
        self.addChild(winLabel)
        
  
        let fadeIn = SKAction.fadeAlpha(to: 0.72, duration: 0.4)
        let textIn = SKAction.fadeAlpha(to: 1.0, duration: 0.25)
        dimNode.run(fadeIn)
        winLabel.run(SKAction.sequence([SKAction.wait(forDuration: 0.15), textIn]))
        
       
        let transitionDelay = SKAction.wait(forDuration: 2.0)
        let transitionToMap = SKAction.run { [weak self] in
            self?.router?.navigateToMapScene()
        }
        self.run(SKAction.sequence([transitionDelay, transitionToMap]))
    }

}
