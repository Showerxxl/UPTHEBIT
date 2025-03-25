import SpriteKit
import GameplayKit
import AVFoundation
import MediaPlayer

class FirstLvlView: SKScene, SKPhysicsContactDelegate {

    var backButton: SKSpriteNode!
    var background: SKSpriteNode!
    var warrior: SKSpriteNode!
    var troop: SKSpriteNode!
    var rightMove: SKSpriteNode!
    var leftMove: SKSpriteNode!
    var jump: SKSpriteNode!
    var ground: SKSpriteNode!
    var ground1: SKSpriteNode!
    var ground2: SKSpriteNode!
    var ground3: SKSpriteNode!
    var barHealth1: SKSpriteNode!
    var barHealth: SKSpriteNode!
    var health: SKSpriteNode!
    var sword: SKSpriteNode!
    
    // Анимационные кадры
    var warriorRunFrames: [SKTexture] = []
    var warriorAttackFrames: [SKTexture] = []
    var warriorJumpFrames: [SKTexture] = []
    var troopRunFrames: [SKTexture] = []
    var troopAttackFrames: [SKTexture] = []
    
    // Presenter
    var presenter: FirstLvlPresenter!
    
    override func didMove(to view: SKView) {
        self.view?.showsPhysics = true
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -2)
        self.physicsWorld.contactDelegate = self
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame) // Границы сцены
        
        // Инициализация сцены
        setupScene()
        setupControls()
        setupPlatforms()
        setupHealthBar()
        setupAnimations()
        
        // Настройка платформ
        configurePlatform(ground1)
        configurePlatform(ground2)
        configurePlatform(ground3)
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
        warrior.position = CGPoint(x: frame.midX, y: frame.midY)
        warrior.size = CGSize(width: 118, height: 115)
        warrior.zPosition = 15 // Выше платформ
        warrior.physicsBody = SKPhysicsBody(texture: warrior.texture!, size: warrior.size)
        warrior.physicsBody?.affectedByGravity = true
        warrior.physicsBody?.isDynamic = true
        warrior.physicsBody?.allowsRotation = false
        warrior.physicsBody?.categoryBitMask = 0x1 << 0
        warrior.physicsBody?.collisionBitMask = 0x1 << 1
        warrior.physicsBody?.contactTestBitMask = 0x1 << 2
        
        addChild(warrior)
        
        troop = SKSpriteNode(imageNamed: "troop")
        troop.position = CGPoint(x: frame.midX + 350, y: frame.midY)
        troop.size = CGSize(width: 118, height: 115)
        troop.zPosition = 15
        troop.physicsBody = SKPhysicsBody(texture: troop.texture!, size: troop.size)
        troop.physicsBody?.affectedByGravity = true
        troop.physicsBody?.isDynamic = true
        troop.physicsBody?.allowsRotation = false
        troop.physicsBody?.collisionBitMask = 0x1 << 1
        troop.physicsBody?.categoryBitMask = 0x1 << 2
        troop.physicsBody?.contactTestBitMask = 0x1 << 0
        addChild(troop)
    }
    
    private func setupControls() {
        let moveButtonSize = frame.width * 0.1
        
        leftMove = SKSpriteNode(imageNamed: "leftMove")
        leftMove.size = CGSize(width: moveButtonSize, height: moveButtonSize)
        leftMove.position = CGPoint(x: frame.minX + leftMove.size.width / 2 + 40, y: frame.minY + leftMove.size.height / 2 + 30)
        leftMove.zPosition = 20
        leftMove.alpha = 0.5
        addChild(leftMove)
        
        rightMove = SKSpriteNode(imageNamed: "rightMove")
        rightMove.size = CGSize(width: moveButtonSize, height: moveButtonSize)
        rightMove.position = CGPoint(x: frame.minX + rightMove.size.width / 2 + 250, y: frame.minY + rightMove.size.height / 2 + 30)
        rightMove.zPosition = 20
        rightMove.alpha = 0.5
        addChild(rightMove)
        
        jump = SKSpriteNode(imageNamed: "jump")
        jump.size = CGSize(width: moveButtonSize * 0.9, height: (moveButtonSize * 1.2) * 0.9)
        jump.zRotation = .pi / 2
        jump.position = CGPoint(x: frame.maxX + jump.size.width / 2 - 120, y: frame.minY + jump.size.height / 2 + 30)
        jump.zPosition = 20
        jump.alpha = 0.5
        addChild(jump)
        
        sword = SKSpriteNode(imageNamed: "sword")
        sword.size = CGSize(width: moveButtonSize, height: moveButtonSize)
        sword.position = CGPoint(x: frame.maxX + jump.size.width / 2 - 250, y: frame.minY + jump.size.height / 2 + 30)
        sword.zPosition = 20
        sword.alpha = 0.5
        addChild(sword)
    }
    
    private func setupPlatforms() {
        ground = SKSpriteNode(imageNamed: "ground")
        ground.size = CGSize(width: frame.width, height: 70)
        ground.position = CGPoint(x: frame.midX, y: frame.minY + ground.size.height / 2)
        ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.categoryBitMask = 0x1 << 1
        ground.zPosition = 1
        addChild(ground)
        
        ground1 = SKSpriteNode(imageNamed: "ground1")
        ground1.position = CGPoint(x: frame.midX + 100, y: frame.midY)
        ground1.size = CGSize(width: 1000, height: 800)
        ground1.zPosition = 3
        addChild(ground1)
        
        ground2 = SKSpriteNode(imageNamed: "ground2")
        ground2.position = CGPoint(x: frame.midX + 200, y: frame.midY - 20)
        ground2.size = CGSize(width: 1000, height: 800)
        ground2.zPosition = 10
        addChild(ground2)
        
        ground3 = SKSpriteNode(imageNamed: "ground3")
        ground3.position = CGPoint(x: frame.midX - 300, y: frame.midY + 20)
        ground3.size = CGSize(width: 1000, height: 800)
        ground3.zPosition = 10
        addChild(ground3)
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
        
        health = SKSpriteNode(imageNamed: "health")
        health.size = iconSize
        health.position = CGPoint(x: barHealth1.position.x - barHealth1.size.width / 2 - iconSize.width / 2 - spacing, y: barHealth1.position.y)
        health.zPosition = 20
        addChild(health)
        
        barHealth = SKSpriteNode(color: UIColor.red, size: CGSize(width: barWidth - 10, height: barHeight - 10))
        barHealth.zPosition = 21
        barHealth.anchorPoint = CGPoint(x: 0.0, y: 0.5)
        barHealth.position = CGPoint(x: frame.minX + 55, y: frame.maxY - topPadding - barHealth1.size.height / 2)
        addChild(barHealth)
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
    
    private func configurePlatform(_ platform: SKSpriteNode) {
        if let texture = platform.texture {
            platform.physicsBody = SKPhysicsBody(texture: texture, size: platform.size)
        } else {
            platform.physicsBody = SKPhysicsBody(rectangleOf: platform.size)
        }
        platform.physicsBody?.isDynamic = false
        platform.physicsBody?.categoryBitMask = 0x1 << 1
        
        let moveUp = SKAction.moveBy(x: 0, y: 20, duration: presenter.beatDuration)
        let moveDown = SKAction.moveBy(x: 0, y: -20, duration: presenter.beatDuration)
        let sequence = SKAction.sequence([moveUp, moveDown])
        platform.run(SKAction.repeatForever(sequence))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        if backButton.contains(location) {
            presenter.backButtonPressed()
        } else if rightMove.contains(location) {
            presenter.startMovingRight()
        } else if leftMove.contains(location) {
            presenter.startMovingLeft()
        } else if jump.contains(location) {
            presenter.jump()
        } else if sword.contains(location) {
            presenter.swordPressed()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        if rightMove.contains(location) {
            presenter.stopMovingRight()
        } else if leftMove.contains(location) {
            presenter.stopMovingLeft()
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        presenter.update(currentTime)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        presenter.didBeginContact(contact)
    }
    
    func updateWarriorVelocity(dx: CGFloat) {
        warrior.physicsBody?.velocity.dx = dx
    }
    
    func updateWarriorScale(xScale: CGFloat) {
        warrior.xScale = xScale
    }
    
    func runWarriorRunAnimation() {
        if warrior.action(forKey: "runAnimation") == nil, !warriorRunFrames.isEmpty {
            let runAction = SKAction.animate(with: warriorRunFrames, timePerFrame: 0.1)
            warrior.run(SKAction.repeatForever(runAction), withKey: "runAnimation")
        }
    }
    
    func stopWarriorRunAnimation() {
        warrior.removeAction(forKey: "runAnimation")
        if let staticTexture = warriorRunFrames.first {
            warrior.texture = staticTexture
        }
    }
    
    func performJumpAction() {
        if !warriorJumpFrames.isEmpty {
            let jumpAnimation = SKAction.animate(with: warriorJumpFrames, timePerFrame: 0.15)
            warrior.run(jumpAnimation)
        }
        warrior.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 300))
    }
    
    func performSwordAttack() {
        if warrior.action(forKey: "attackAnimation") == nil, !warriorAttackFrames.isEmpty {
            let attackAction = SKAction.animate(with: warriorAttackFrames, timePerFrame: 0.1)
            let completionAction = SKAction.run { [weak self] in
                if let staticTexture = self?.warriorRunFrames.first {
                    self?.warrior.texture = staticTexture
                }
            }
            warrior.run(SKAction.sequence([attackAction, completionAction]), withKey: "attackAnimation")
        }
    }
    
    func updateHealthBar(width: CGFloat) {
        barHealth.size.width = width
    }
    
    func removeTroop() {
        troop.removeFromParent()
    }
    
    func bounceWarrior(direction: CGFloat) {
        let radius: CGFloat = 5
        let direction: CGFloat = warrior.position.x >= troop.position.x ? 1 : -1
        let arcPath = UIBezierPath()
        if direction > 0 {
            arcPath.addArc(withCenter: CGPoint(x: radius, y: 0),
                           radius: radius,
                           startAngle: .pi,
                           endAngle: 0,
                           clockwise: true)
        } else {
            arcPath.addArc(withCenter: CGPoint(x: -radius, y: 0),
                           radius: radius,
                           startAngle: 0,
                           endAngle: .pi,
                           clockwise: true)
        }
        let bounceWarriorAction = SKAction.follow(arcPath.cgPath, asOffset: true, orientToPath: false, duration: 0.3)
        warrior.run(bounceWarriorAction)
    }
    
    func bounceTroop(direction: CGFloat) {
        let radius: CGFloat = 35
        let arcPath = UIBezierPath()
        if direction > 0 {
            arcPath.addArc(withCenter: CGPoint(x: radius, y: 0), radius: radius, startAngle: .pi, endAngle: 0, clockwise: true)
        } else {
            arcPath.addArc(withCenter: CGPoint(x: -radius, y: 0), radius: radius, startAngle: 0, endAngle: .pi, clockwise: true)
        }
        let bounceAction = SKAction.follow(arcPath.cgPath, asOffset: true, orientToPath: false, duration: 0.3)
        troop.run(bounceAction)
    }
}
