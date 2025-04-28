
import SpriteKit

class MapView: SKScene, MapViewProtocol {

    var presenter: MapPresenterProtocol!
    

    var backButton: SKSpriteNode!
    var background: SKSpriteNode!
    var firstBox: SKSpriteNode!
    var secondBox: SKSpriteNode!
    var thirdBox: SKSpriteNode!
    var firstBoxNum: SKSpriteNode!
    var secondBoxNum: SKSpriteNode!
    var thirdBoxNum: SKSpriteNode!
    

    private let firstLevelCompleteKey = "firstLevelComplete"
    
    override func didMove(to view: SKView) {
        setupUI()
    }
    

    private func setupUI() {
        background = SKSpriteNode(imageNamed: "background1")
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.size = CGSize(width: frame.width, height: frame.height)
        background.yScale = -background.yScale
        background.zPosition = -1
        addChild(background)
        
        let backButtonSize = frame.width * 0.07
        backButton = SKSpriteNode(imageNamed: "QuitIcon")
        backButton.size = CGSize(width: backButtonSize, height: backButtonSize)
        backButton.position = CGPoint(x: frame.maxX - backButton.size.width / 2 - 50,
                                      y: frame.maxY - backButton.size.height / 2 - 20)
        backButton.zPosition = 2
        addChild(backButton)
        
        let boxWidth = frame.width * 0.1
        let boxHeight = boxWidth

        
        let isFirstLevelComplete = UserDefaults.standard.bool(forKey: firstLevelCompleteKey)
        let firstBoxImage = isFirstLevelComplete ? "complete" : "1lvl"
        firstBox = SKSpriteNode(imageNamed: firstBoxImage)
        firstBox.size = CGSize(width: boxWidth, height: boxHeight)
        firstBox.position = CGPoint(x: frame.minX + firstBox.size.width / 2 + 50,
                                    y: frame.minY + firstBox.size.height / 2 + 50)
        firstBox.zPosition = 1
        addChild(firstBox)
        
        secondBox = SKSpriteNode(imageNamed: "2lvl")
        secondBox.size = CGSize(width: boxWidth, height: boxHeight)
        secondBox.position = CGPoint(x: frame.midX, y: frame.midY)
        secondBox.zPosition = 1
        addChild(secondBox)
        
        thirdBox = SKSpriteNode(imageNamed: "3lvl")
        thirdBox.size = CGSize(width: boxWidth, height: boxHeight)
        thirdBox.position = CGPoint(x: frame.maxX - thirdBox.size.width / 2 - 50,
                                    y: frame.midY)
        thirdBox.zPosition = 1
        addChild(thirdBox)
        
        firstBoxNum = SKSpriteNode(imageNamed: "1")
        firstBoxNum.size = CGSize(width: boxWidth, height: boxHeight)
        firstBoxNum.position = CGPoint(x: frame.minX + firstBox.size.width / 2 + 50,
                                       y: frame.minY + firstBoxNum.size.height / 2 + 50)
        firstBoxNum.zPosition = 3
        addChild(firstBoxNum)
        
        secondBoxNum = SKSpriteNode(imageNamed: "2")
        secondBoxNum.size = CGSize(width: boxWidth, height: boxHeight)
        secondBoxNum.position = CGPoint(x: frame.midX, y: frame.midY)
        secondBoxNum.zPosition = 3
        addChild(secondBoxNum)
        
        thirdBoxNum = SKSpriteNode(imageNamed: "3")
        thirdBoxNum.size = CGSize(width: boxWidth, height: boxHeight)
        thirdBoxNum.position = CGPoint(x: frame.maxX - thirdBox.size.width / 2 - 50,
                                       y: frame.midY)
        thirdBoxNum.zPosition = 3
        addChild(thirdBoxNum)
    }


    public func markFirstLevelComplete() {
        UserDefaults.standard.set(true, forKey: firstLevelCompleteKey)
        updateFirstBoxImage()
    }
    
   
    private func updateFirstBoxImage() {
        let texture = SKTexture(imageNamed: "complete")
        firstBox.texture = texture
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        if backButton.contains(location) {
            presenter.backButtonTapped()
        } else if firstBox.contains(location) {
            presenter.firstBoxTapped()
        }
    }
}
