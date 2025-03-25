import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let skView = self.view as? SKView {
            let width = max(skView.bounds.width, skView.bounds.height)
            let height = min(skView.bounds.width, skView.bounds.height)
            let sceneSize = CGSize(width: width, height: height)
            
    
            let scene = GameScene(size: sceneSize)
            scene.scaleMode = .aspectFill
            

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
