
import SpriteKit
import UIKit

class SettingsScene: SKScene {
    
    var background: SKSpriteNode!
    var area: SKSpriteNode!
    var quit : SKSpriteNode!
    var label1 : SKSpriteNode!
    var label2 : SKSpriteNode!
    var namel: SKSpriteNode!
    var select : SKSpriteNode!
    

    var resetMusicButton: SKSpriteNode!
    var defaultIcon: SKSpriteNode!
    

    private var blackOverlay: SKSpriteNode?
    
    var presenter: SettingsPresenterProtocol = SettingsPresenter()
    private var musicPickerManager: MusicPickerManager?

    override func didMove(to view: SKView) {
        background = SKSpriteNode(imageNamed: "settingsbg")
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.size = CGSize(width: frame.width, height: frame.height)
        background.zPosition = -1
        addChild(background)
        
        area = SKSpriteNode(imageNamed: "setarea")
        area.position = CGPoint(x: frame.midX, y: frame.midY)
        area.size = CGSize(width: frame.width * 0.8, height: frame.height * 0.8)
        area.zPosition = 0
        addChild(area)
        
        quit = SKSpriteNode(imageNamed: "QuitIcon")
        quit.position = CGPoint(x: frame.midX + area.size.width / 2.2, y: frame.midY + area.size.height / 2.8)
        quit.size = CGSize(width: frame.width / 15, height: frame.width / 15)
        quit.zPosition = 1
        addChild(quit)
        
        label1 = SKSpriteNode(imageNamed: "label")
        label1.position = CGPoint(x: frame.midX, y: frame.midY + area.size.height / 3)
        label1.size = CGSize(width: area.size.width / 2, height: area.size.height / 5)
        label1.zPosition = 1
        
        namel = SKSpriteNode(imageNamed: "SETTINGS")
        namel.size = CGSize(width: label1.size.width * 0.4, height: label1.size.height * 0.4)
        namel.position = CGPoint(x: 0, y: namel.size.height * 0.4)
        namel.zPosition = 2
        label1.addChild(namel)
        addChild(label1)
        

        label2 = SKSpriteNode(imageNamed: "label")
        label2.position = CGPoint(x: frame.midX, y: frame.midY)
        label2.size = CGSize(width: area.size.width / 2, height: area.size.height / 5)
        label2.zPosition = 1
        
        select = SKSpriteNode(imageNamed: "Select")
        select.size = CGSize(width: label1.size.width * 0.5, height: label1.size.height * 0.5)
        select.position = CGPoint.zero
        select.zPosition = 2
        label2.addChild(select)
        
        addChild(label2)
        
 
        resetMusicButton = SKSpriteNode(imageNamed: "label")
        resetMusicButton.position = CGPoint(x: frame.midX, y: frame.midY - area.size.height / 4)
        resetMusicButton.size = CGSize(width: area.size.width / 2, height: area.size.height / 5)
        resetMusicButton.zPosition = 1
        
 
        defaultIcon = SKSpriteNode(imageNamed: "Default")
        defaultIcon.size = CGSize(width: label1.size.width * 0.5, height: label1.size.height * 0.5)
        defaultIcon.position = CGPoint.zero
        defaultIcon.zPosition = 2
        resetMusicButton.addChild(defaultIcon)
        
        addChild(resetMusicButton)
        
   
        if let viewController = view.next as? UIViewController ?? view.window?.rootViewController {
            musicPickerManager = MusicPickerManager(presentingViewController: viewController)
            musicPickerManager?.delegate = self
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        if quit.contains(location) {
            presenter.quitButtonTapped(from: self)
        } else if label2.contains(location) {
            showBlackOverlayAndPresentPicker()
        } else if resetMusicButton.contains(location) {
   
            resetToDefaultMusic()
        }
    }
    
    
    private func showBlackOverlayAndPresentPicker() {

        blackOverlay = SKSpriteNode(color: .black, size: self.size)
        blackOverlay!.position = CGPoint(x: frame.midX, y: frame.midY)
        blackOverlay!.zPosition = 10
        blackOverlay!.alpha = 0
        addChild(blackOverlay!)
        
        
        let fadeIn = SKAction.fadeIn(withDuration: 0.3)
     
        let wait = SKAction.wait(forDuration: 0.2)

        let presentPickerAction = SKAction.run { [weak self] in
            self?.musicPickerManager?.presentMediaPicker()
        }
        
   
        blackOverlay!.run(SKAction.sequence([fadeIn, wait, presentPickerAction]))
        
       
        label2.run(SKAction.sequence([
            SKAction.scale(to: 0.9, duration: 0.1),
            SKAction.scale(to: 1.0, duration: 0.1)
        ]))
    }
    

    private func removeBlackOverlay(completion: (() -> Void)? = nil) {
        guard let overlay = blackOverlay else {
            completion?()
            return
        }
        
       
        let fadeOut = SKAction.fadeOut(withDuration: 0.3)
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([fadeOut, remove])
        
        overlay.run(sequence) { [weak self] in
            self?.blackOverlay = nil
            completion?()
        }
    }
    
  
    private func resetToDefaultMusic() {

        MusicPlayerService.shared.playDefaultMusic()
        
   
        resetMusicButton.run(SKAction.sequence([
            SKAction.scale(to: 0.9, duration: 0.1),
            SKAction.scale(to: 1.0, duration: 0.1)
        ]))
        

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.navigateToGameScene()
        }
    }
    
   
    private func navigateToGameScene() {
        let gameScene = GameScene(size: self.size)
        gameScene.scaleMode = .aspectFill
        let transition = SKTransition.fade(withDuration: 0.5)
        self.view?.presentScene(gameScene, transition: transition)
    }
}

extension SettingsScene: MusicPickerManagerDelegate {
    func musicPickerManagerDidPickMusic(_ manager: MusicPickerManager) {
   
        removeBlackOverlay { [weak self] in
      
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
                self?.navigateToGameScene()
            }
        }
    }
    
    func musicPickerManagerDidCancel(_ manager: MusicPickerManager) {

        removeBlackOverlay()
    }
}
