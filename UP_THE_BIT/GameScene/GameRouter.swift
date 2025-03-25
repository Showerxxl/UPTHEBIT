import SpriteKit

// Протокол для взаимодействия Presenter -> Router
protocol GameRouterProtocol: AnyObject {
    func navigateToMapScene()
    func navigateToShopScene()
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
        let transition = SKTransition.flipHorizontal(withDuration: 0.5)
        let shopScene = MusicSelectionScene(size: view.size)
        shopScene.scaleMode = .aspectFill
        view.view?.presentScene(shopScene, transition: transition)
    }
}
