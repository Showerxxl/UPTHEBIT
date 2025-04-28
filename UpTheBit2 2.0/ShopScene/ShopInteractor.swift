import SpriteKit
import Foundation

protocol ShopInteractorProtocol: AnyObject {
    func setupCategoryButtons(in scene: SKScene)

    func purchaseBox(_ boxButton: SKSpriteNode, shopEntity: inout ShopEntity, index: Int)
}

class ShopInteractor: ShopInteractorProtocol {

    func setupCategoryButtons(in scene: SKScene) {
        // Параметры для кнопок категорий
        let startX = scene.frame.width / CGFloat(ShopConstants.buttonCount) / 1.7
        let buttonWidth = scene.frame.width / CGFloat(ShopConstants.buttonCount) / 1.4
        let buttonSpacing: CGFloat = buttonWidth * 1.1
        let buttonHeight = scene.frame.width / 15
        let yPosition = scene.frame.height - buttonHeight / 1.5
        
        // Массив с именами иконок для кнопок, по порядку
        let icons = ["WEAPON", "ARMOR", "CASH"]
        
        for index in 0..<ShopConstants.buttonCount {
            let imageName = (index == ShopItem.selectedSection - 1) ? "selectsection" : "section"
            let button = SKSpriteNode(imageNamed: imageName)
            button.name = "section\(index+1)"
            button.size = CGSize(width: buttonWidth, height: buttonHeight)
            button.position = CGPoint(x: startX + CGFloat(index) * buttonSpacing, y: yPosition)
            button.zPosition = 1
            
            if index < icons.count {
                let iconSprite = SKSpriteNode(imageNamed: icons[index])
                iconSprite.size = CGSize(width: buttonWidth * 0.5, height: buttonHeight * 0.5)
                iconSprite.position = CGPoint.zero
                iconSprite.zPosition = 2
                button.addChild(iconSprite)
            }
            
            scene.addChild(button)
        }
        
        // Добавление кнопки QuitIcon в правый верхний угол
        let quitButton = SKSpriteNode(imageNamed: "QuitIcon")
        quitButton.name = "quitButton"
        quitButton.size = CGSize(width: buttonHeight, height: buttonHeight)
        let margin: CGFloat = buttonHeight * 0.3
        quitButton.position = CGPoint(x: scene.frame.width - margin - quitButton.size.width, y: yPosition)
        quitButton.zPosition = 10
        scene.addChild(quitButton)
    }
    

    func purchaseBox(_ boxButton: SKSpriteNode, shopEntity: inout ShopEntity, index: Int) {
        guard let buttonName = boxButton.name else { return }
        
        let currentCoinCount = UserDefaults.standard.integer(forKey: "coinCount")
        let defaults = UserDefaults.standard

        switch buttonName {
        case let name where name.hasPrefix("boxButton_1_"):
            if shopEntity.boxListWeapon[index].isBought {
                print("Этот бокс уже куплен.")
                return
            }
            let cost = shopEntity.boxListWeapon[index].price
            if currentCoinCount >= Int(cost) {
                let newCoinCount = currentCoinCount - Int(cost)
                defaults.set(newCoinCount, forKey: "coinCount")
                shopEntity.boxListWeapon[index].isBought = true
                boxButton.texture = SKTexture(imageNamed: "boughtbox")
                let purchaseKey = "\(buttonName)_isBought"
                defaults.set(true, forKey: purchaseKey)
                let charac = shopEntity.boxListWeapon[index].characteristic
                let oldStrength = defaults.integer(forKey: "playerStrength")
                let newStrength = max(oldStrength, charac)
                defaults.set(newStrength, forKey: "playerStrength")
            } else {
                print("Недостаточно средств для покупки. Доступно: \(currentCoinCount), требуется: \(cost)")
            }
            
        case let name where name.hasPrefix("boxButton_2_"):
            if shopEntity.boxListArmor[index].isBought {
                print("Этот бокс уже куплен.")
                return
            }
            let cost = shopEntity.boxListArmor[index].price
            if currentCoinCount >= Int(cost) {
                let newCoinCount = currentCoinCount - Int(cost)
                defaults.set(newCoinCount, forKey: "coinCount")
                shopEntity.boxListArmor[index].isBought = true
                boxButton.texture = SKTexture(imageNamed: "boughtbox")
                let purchaseKey = "\(buttonName)_isBought"
                defaults.set(true, forKey: purchaseKey)
                let charac = shopEntity.boxListArmor[index].characteristic
                let oldHealth = defaults.integer(forKey: "playerHealth")
                let newHealth = max(oldHealth, charac)
                defaults.set(newHealth, forKey: "playerHealth")
            } else {
                print("Недостаточно средств для покупки. Доступно: \(currentCoinCount), требуется: \(cost)")
            }
            
        case let name where name.hasPrefix("boxButton_3_"):
            if shopEntity.boxListCash[index].isBought {
                print("Этот бокс уже куплен.")
                return
            }
            let cost = shopEntity.boxListCash[index].price
            if currentCoinCount >= Int(cost) {
                let newCoinCount = currentCoinCount - Int(cost)
                defaults.set(newCoinCount, forKey: "coinCount")
                shopEntity.boxListCash[index].isBought = true
                boxButton.texture = SKTexture(imageNamed: "boughtbox")
                let purchaseKey = "\(buttonName)_isBought"
                defaults.set(true, forKey: purchaseKey)
                let charac = shopEntity.boxListCash[index].characteristic
                let oldLoot = defaults.integer(forKey: "playerLoot")
                let newLoot = max(oldLoot, charac)
                defaults.set(newLoot, forKey: "playerLoot")
            } else {
                print("Недостаточно средств для покупки. Доступно: \(currentCoinCount), требуется: \(cost)")
            }
            
        default:
            print("Неизвестная категория бокса.")
        }
    }
}
