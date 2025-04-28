import SpriteKit

class MusicSelectionScene: SKScene {
    
    var label: SKSpriteNode!
    var background: SKSpriteNode!
    var select: SKSpriteNode!
    private var musicPickerManager: MusicPickerManager?
    
    override func didMove(to view: SKView) {

        background = SKSpriteNode(imageNamed: "musicbg")
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.size = CGSize(width: frame.width, height: frame.height)
        background.zPosition = -1
        addChild(background)
        
       
        let selectMusicButton = SKLabelNode(text: "Выбрать фоновую музыку")
        selectMusicButton.fontSize = 30
        selectMusicButton.fontColor = SKColor.white
        selectMusicButton.position = CGPoint(x: size.width/2, y: size.height/2)
        selectMusicButton.name = "selectMusic"
        addChild(selectMusicButton)
        
        label = SKSpriteNode(imageNamed: "label")
        label.position = CGPoint(x: frame.midX, y: frame.midY)
        label.size = CGSize(width: frame.size.width / 2, height: frame.size.height / 5)
        label.zPosition = 1
        
        select = SKSpriteNode(imageNamed: "Select")
        select.size = CGSize(width: label.size.width * 0.5, height: label.size.height * 0.5)
        select.position = CGPoint.zero
        select.zPosition = 2
        label.addChild(select)
        addChild(label)


        if let viewController = view.next as? UIViewController ?? view.window?.rootViewController {
            musicPickerManager = MusicPickerManager(presentingViewController: viewController)
            musicPickerManager?.delegate = self
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        if label.contains(location) {
            let blackOverlay = SKSpriteNode(color: .black, size: self.size)
            blackOverlay.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            blackOverlay.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
            blackOverlay.zPosition = 100 
            blackOverlay.name = "blackOverlay"
            addChild(blackOverlay)
            musicPickerManager?.presentMediaPicker()
        }
    }
}

extension MusicSelectionScene: MusicPickerManagerDelegate {
    func musicPickerManagerDidPickMusic(_ manager: MusicPickerManager) {
        if let blackOverlay = self.childNode(withName: "blackOverlay") {
            blackOverlay.removeFromParent()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            guard let self = self else { return }
            let view = FirstLvlView(size: self.size)
            let interactor = FirstLvlInteractor()
            let router = FirstLvlRouter(view: view)
            let presenter = FirstLvlPresenter(view: view, interactor: interactor, router: router)
            view.presenter = presenter
            view.interactor = interactor
            view.router = router 
            view.scaleMode = .aspectFill
            let transition = SKTransition.fade(withDuration: 0.5)
            self.view?.presentScene(view, transition: transition)
        }
    }
    
    func musicPickerManagerDidCancel(_ manager: MusicPickerManager) {
        if let blackOverlay = self.childNode(withName: "blackOverlay") {
            blackOverlay.removeFromParent()
        }
    }
}
