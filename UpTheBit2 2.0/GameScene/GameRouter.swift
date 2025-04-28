import SpriteKit

// Протокол для взаимодействия Presenter -> Router
protocol GameRouterProtocol: AnyObject {
    func navigateToMapScene()
    func navigateToShopScene()
    func navigateToSettingsScene()
}

class GameRouter: GameRouterProtocol {
    weak var view: GameScene?

    func navigateToMapScene() {
        guard let view = view else { return }
        let transition = SKTransition.flipHorizontal(withDuration: 0.5)
        let mapScene = MapRouter.createMapModule()
        mapScene.size = view.size
        mapScene.scaleMode = .aspectFill
        view.view?.presentScene(mapScene, transition: transition)
    }

    func navigateToShopScene() {
        guard let view = view else { return }
        let transition = SKTransition.push(with: .left, duration: 0.5)
        let shopScene = ShopCategoryOneScene(size: view.size)
        shopScene.scaleMode = .aspectFill
        view.view?.presentScene(shopScene, transition: transition)
    }
    
    func navigateToSettingsScene() {
        guard let view = view else { return }
        let transition = SKTransition.fade(withDuration: 0.5)
        let settingsScene = SettingsScene(size: view.size)
        settingsScene.scaleMode = .aspectFill
        view.view?.presentScene(settingsScene, transition: transition)
    }
}
