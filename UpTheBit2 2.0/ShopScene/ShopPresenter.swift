import SpriteKit
import Foundation

protocol ShopPresenterProtocol: AnyObject {
    func navigateToCategory(_ category: Int, from scene: SKScene)
    func exitShop(from scene: SKScene)
}

class ShopPresenter: ShopPresenterProtocol {
    var router: ShopRouterProtocol = ShopRouter()
    
    func navigateToCategory(_ category: Int, from scene: SKScene) {
        router.navigateToCategory(category, from: scene)
    }
    
    func exitShop(from scene: SKScene) {
        ShopItem.selectedSection = 1;
        router.exitShop(from: scene)
    }
}
