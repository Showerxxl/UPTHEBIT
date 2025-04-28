import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func loadView() {

        self.view = SKView(frame: UIScreen.main.bounds)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        if let skView = self.view as? SKView {
         
            let scene = GameScene(size: skView.bounds.size)
            scene.scaleMode = .resizeFill

            
            let interactor = GameInteractor()
            let presenter = GamePresenter()
            let router = GameRouter()
            
            router.view = scene
            scene.presenter = presenter
            presenter.view = scene
            presenter.interactor = interactor
            presenter.router = router
            interactor.presenter = presenter
            
            skView.presentScene(scene)
            skView.ignoresSiblingOrder = true
            skView.showsFPS = true
            skView.showsNodeCount = true
        }
    }

    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
