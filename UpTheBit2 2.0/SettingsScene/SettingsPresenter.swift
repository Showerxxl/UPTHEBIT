import Foundation
import SpriteKit

protocol SettingsPresenterProtocol {
    func quitButtonTapped(from scene: SKScene)
}

class SettingsPresenter: SettingsPresenterProtocol {
    var router: SettingsRouterProtocol = SettingsRouter()
    
    func quitButtonTapped(from scene: SKScene) {
        router.routeToGameScene(from: scene)
    }
}
