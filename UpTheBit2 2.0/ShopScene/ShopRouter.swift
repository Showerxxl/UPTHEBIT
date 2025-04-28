import SpriteKit
import Foundation

protocol ShopRouterProtocol: AnyObject {
    func navigateToCategory(_ category: Int, from scene: SKScene)
    func exitShop(from scene: SKScene)
}

class ShopRouter: ShopRouterProtocol {
    func navigateToCategory(_ category: Int, from scene: SKScene) {
        ShopItem.selectedSection = category
        
        let newScene: SKScene
        let transition: SKTransition
        
        switch category {
        case 1:

            transition = SKTransition.push(with: .right, duration: 0.5)
            newScene = ShopCategoryOneScene(size: scene.size)
        case 2:
            if scene is ShopCategoryOneScene {

                transition = SKTransition.push(with: .left, duration: 0.5)
            } else {
                transition = SKTransition.push(with: .right, duration: 0.5)
            }
            newScene = ShopCategoryTwoScene(size: scene.size)
        case 3:
            transition = SKTransition.push(with: .left, duration: 0.5)
            newScene = ShopCategoryThreeScene(size: scene.size)
            
        default:
            return
        }
        
        newScene.scaleMode = scene.scaleMode
        scene.view?.presentScene(newScene, transition: transition)
    }
    
    func exitShop(from scene: SKScene) {
        let transition = SKTransition.fade(withDuration: 0.5)
        let gameScene = GameScene(size: scene.size)
        gameScene.scaleMode = scene.scaleMode
        scene.view?.presentScene(gameScene, transition: transition)
    }
}
