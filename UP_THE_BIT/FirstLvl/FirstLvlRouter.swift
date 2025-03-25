import SpriteKit
class FirstLvlRouter {
    weak var view: FirstLvlView!
    
    init(view: FirstLvlView) {
        self.view = view
    }
    
    func navigateToMapScene() {
        guard let view = view else { return }
        let transition = SKTransition.flipHorizontal(withDuration: 0.5)
        let mapScene = MapRouter.createMapModule()
        mapScene.size = view.size
        mapScene.scaleMode = .aspectFill
        view.view?.presentScene(mapScene, transition: transition)
    }
}
