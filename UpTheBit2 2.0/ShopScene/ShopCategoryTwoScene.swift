
import SpriteKit

class ShopCategoryTwoScene: SKScene {
    
    var background: SKSpriteNode!
    var shopplace: SKSpriteNode!
    

    var shopEntity: ShopEntity!
    

    var presenter: ShopPresenterProtocol = ShopPresenter()
    
    override func didMove(to view: SKView) {

        shopEntity = ShopEntity()
        
        background = SKSpriteNode(imageNamed: "shopbg")
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.size = CGSize(width: frame.width, height: frame.height)
        background.zPosition = -1
        addChild(background)
        
        shopplace = SKSpriteNode(imageNamed: "shopplace")
        shopplace.position = CGPoint(x: frame.midX, y: frame.midY)
        shopplace.size = CGSize(width: frame.width, height: frame.height)
        shopplace.zPosition = 0
        addChild(shopplace)
        

        ShopInteractor().setupCategoryButtons(in: self)
        

        let boxItems = shopEntity.boxListArmor
        
 
        let boxButtonWidth = frame.width / 8.0
        let boxButtonHeight = boxButtonWidth
        let horizontalSpacing: CGFloat = boxButtonWidth / 1.2
        let startX = boxButtonHeight / 1.2

        let boxY = shopplace.position.y + boxButtonHeight / 5.0
        
        for index in 0..<boxItems.count {
            let xPosition = startX + CGFloat(index) * (boxButtonWidth + horizontalSpacing)
            let boxButton = SKSpriteNode(imageNamed: "box")
            

            boxButton.name = "boxButton_2_\(index)"
            

            boxButton.size = CGSize(width: boxButtonWidth, height: boxButtonHeight)
            boxButton.position = CGPoint(x: xPosition + boxButtonWidth / 2, y: boxY)
            boxButton.zPosition = 1
            
            if shopEntity.boxListArmor[index].isBought {
                boxButton.texture = SKTexture(imageNamed: "boughtbox")
            }
            

            let armorImageName = "armor\(index + 1)"
            let armorSprite = SKSpriteNode(imageNamed: armorImageName)

            armorSprite.size = CGSize(width: boxButton.size.width * 0.8, height: boxButton.size.height * 0.8)
            armorSprite.position = CGPoint.zero
            armorSprite.zPosition = 2
            boxButton.addChild(armorSprite)
            addChild(boxButton)
            
            
            let strengthY = boxY - boxButtonHeight * 0.8
            for index in 0..<boxItems.count {
                let xPosition = startX + CGFloat(index) * (boxButtonWidth + horizontalSpacing)
                let strengthSprite = SKSpriteNode(imageNamed: "strength\(index + 1)")
                strengthSprite.size = CGSize(width: boxButtonWidth, height: boxButtonHeight * 0.3)
                strengthSprite.position = CGPoint(x: xPosition + boxButtonWidth / 2, y: strengthY)
                strengthSprite.zPosition = 1
                addChild(strengthSprite)
            }
            let cY = strengthY - boxButtonHeight * 0.3
            for index in 0..<boxItems.count {
               let xPosition = startX + CGFloat(index) * (boxButtonWidth + horizontalSpacing)
               let cSprite = SKSpriteNode(imageNamed: "c\(index + 1)")
                cSprite.size = CGSize(width: boxButtonWidth * 0.8, height: boxButtonHeight * 0.2)
               cSprite.position = CGPoint(x: xPosition + boxButtonWidth / 2, y: cY)
               cSprite.zPosition = 1
               addChild(cSprite)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        

        for node in tappedNodes {
            if let nodeName = node.name, nodeName.hasPrefix("boxButton_2_") {
                guard let indexString = nodeName.components(separatedBy: "_").last,
                      let index = Int(indexString) else { return }
                
                if let boxButton = node as? SKSpriteNode {
                    ShopInteractor().purchaseBox(boxButton, shopEntity: &shopEntity, index: index)
                }
                return
            }
        }
        
   
        for node in tappedNodes {
            if let name = node.name {
                if name == "quitButton" {
                    presenter.exitShop(from: self)
                    return
                }
                switch name {
                case "section1":
                    presenter.navigateToCategory(1, from: self)
                case "section2":

                    break
                case "section3":
                    presenter.navigateToCategory(3, from: self)
                default:
                    break
                }
            }
        }
    }
}
