import SpriteKit

class MapRouter: MapRouterProtocol {

    func navigateToMainScene(from view: MapViewProtocol) {
        guard let skView = view.view else { return }
        let mainScene = GameScene(size: skView.bounds.size)
        mainScene.scaleMode = .aspectFill
        let transition = SKTransition.flipHorizontal(withDuration: 0.5)
        skView.presentScene(mainScene, transition: transition)
    }
    

    func navigateToMusicScene(from view: MapViewProtocol) {
        guard let skView = view.view else { return }
        let shopScene = MusicSelectionScene(size: skView.bounds.size)
        shopScene.scaleMode = .aspectFill
        let transition = SKTransition.flipHorizontal(withDuration: 0.5)
        skView.presentScene(shopScene, transition: transition)
        
    }
    
    static func createMapModule() -> MapView {
        let view = MapView()
        let presenter = MapPresenter()
        let interactor = MapInteractor()
        let router = MapRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        return view
    }
}
