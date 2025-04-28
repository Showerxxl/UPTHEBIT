import SpriteKit

class SecondLvlView: SKScene {
    
    var background: SKSpriteNode!
    var quit : SKSpriteNode!
    var water: SKSpriteNode!
    var tallground1 : SKSpriteNode!
    var tallground2 : SKSpriteNode!
    var smallground1 : SKSpriteNode!
    var smallground2 : SKSpriteNode!
    var smallground3 : SKSpriteNode!
    var bigground : SKSpriteNode!
    var leftbutton : SKSpriteNode!
    var rightbutton : SKSpriteNode!
    var sword : SKSpriteNode!
    var jump : SKSpriteNode!
    var presenter: SettingsPresenterProtocol = SettingsPresenter()
    
    override func didMove(to view: SKView) {

        
        background = SKSpriteNode(imageNamed: "level2")
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.size = CGSize(width: frame.width, height: frame.height)
        background.zPosition = -1
        addChild(background)
        
        quit = SKSpriteNode(imageNamed: "QuitIcon")
        quit.position = CGPoint(x: frame.midX  +  background.size.width / 2.5, y: frame.midY + background.size.height / 2.8)
        quit.size = CGSize(width: frame.width / 12, height: frame.width / 12)
        quit.zPosition = 1
        addChild(quit)
        
        water = SKSpriteNode(imageNamed: "water")
        water.position = CGPoint(x: frame.midX, y: frame.midY)
        water.size = CGSize(width: frame.width * 2, height: frame.height)
        water.zPosition = 0
        addChild(water)
        
        tallground1 = SKSpriteNode(imageNamed: "tallground")
        tallground1.position = CGPoint(x: frame.midX / 5.1, y: frame.midY * 0.6)
        tallground1.size = CGSize(width: frame.width / 14, height: frame.height * 0.78)
        tallground1.zPosition = 1
        addChild(tallground1)
        
        tallground2 = SKSpriteNode(imageNamed: "tallground")
        tallground2.position = CGPoint(x: frame.midX / 1.45, y: frame.midY * 0.35)
        tallground2.size = CGSize(width: frame.width / 14, height: frame.height * 0.55)
        tallground2.zPosition = 1
        addChild(tallground2)
        
        bigground = SKSpriteNode(imageNamed: "bigground")
        bigground.position = CGPoint(x: frame.midX * 1.45, y: frame.midY * 0.65)
        bigground.size = CGSize(width: frame.width / 3.5, height: frame.height / 1.4)
        bigground.zPosition = 1
        addChild(bigground)
        
        
        smallground1 = SKSpriteNode(imageNamed: "smallground")
        smallground1.position = CGPoint(x: frame.midX * 0.44, y: frame.midY * 0.7)
        smallground1.size = CGSize(width: frame.width * 1.2, height: frame.height * 2.5)
        smallground1.zPosition = 2
        addChild(smallground1)
        
        
        smallground2 = SKSpriteNode(imageNamed: "smallground")
        smallground2.position = CGPoint(x: frame.midX * 0.95, y: frame.midY * 0.3)
        smallground2.size = CGSize(width: frame.width * 1.2, height: frame.height * 2.5)
        smallground2.zPosition = 2
        addChild(smallground2)
        
        smallground3 = SKSpriteNode(imageNamed: "smallground")
        smallground3.position = CGPoint(x: frame.midX * 1.85, y: frame.midY * 0.6)
        smallground3.size = CGSize(width: frame.width * 1.2, height: frame.height * 2.5)
        smallground3.zPosition = 2
        addChild(smallground3)
        
        
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        if quit.contains(location) {
            presenter.quitButtonTapped(from: self)
        }
    }
}
