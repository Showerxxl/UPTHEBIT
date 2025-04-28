import Foundation
import SpriteKit

protocol SettingsRouterProtocol {
    func routeToGameScene(from scene: SKScene)
}

class SettingsRouter: SettingsRouterProtocol {
    func routeToGameScene(from scene: SKScene) {
        if let view = scene.view {
            let gameScene = GameScene(size: scene.size)
            gameScene.scaleMode = .aspectFill
            let transition = SKTransition.fade(withDuration: 0.5)
            view.presentScene(gameScene, transition: transition)
        }
    }
}
