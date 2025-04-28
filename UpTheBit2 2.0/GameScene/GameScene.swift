
import SpriteKit
import MediaPlayer
import GameplayKit
import AVFoundation
import UIKit

protocol GameViewProtocol: AnyObject {
    func updateCoinLabel(count: Int)
    func animateKnightTap()
    func animateKnightRelease()
    func updateLootScale(percent: CGFloat)
    func updateHealthScale(percent: CGFloat)
    func updateStrengthScale(percent: CGFloat)
}

class GameScene: SKScene, GameViewProtocol {
    var background: SKSpriteNode!
    var knight: SKSpriteNode!
    var map: SKSpriteNode!
    var damage: SKSpriteNode!
    var health: SKSpriteNode!
    var loot: SKSpriteNode!
    var mapBox: SKSpriteNode!
    var shopBox: SKSpriteNode!
    var settingsBox: SKSpriteNode!
    var barHealth: SKSpriteNode!
    var barDamage: SKSpriteNode!
    var barLoot: SKSpriteNode!
    var coinLabel: SKLabelNode!
    var healthLabel: SKLabelNode!
    var damageLabel: SKLabelNode!
    
    var lootScale: SKSpriteNode!
    var healthScale: SKSpriteNode!
    var strengthScale: SKSpriteNode!
    
    var backgroundMusic: SKAudioNode?
    var presenter: GamePresenterProtocol?

    override func didMove(to view: SKView) {
        //UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        // Настройка аудиосессии
        if MusicPlayerService.shared.shouldInitializeMusic() {
            if !MusicPlayerService.shared.isCustomMusicPlaying() {
                if let musicURL = Bundle.main.url(forResource: "mainMelody", withExtension: "mp3") {
                    let audioNode = SKAudioNode(url: musicURL)
                    audioNode.autoplayLooped = true
                    addChild(audioNode)
                    
                    backgroundMusic = audioNode
                    MusicPlayerService.shared.setMusicInitialized()
                }
            } else {
                MusicPlayerService.shared.forcePlayIfCustomMusicChosen()
                MusicPlayerService.shared.setMusicInitialized()
            }
        }

        // Инициализация компонентов VIPER
        let interactor = GameInteractor()
        let presenter = GamePresenter()
        let router = GameRouter()
        router.view = self

        self.presenter = presenter
        presenter.view = self
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter

        

        // Создание и добавление фона
        background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.size = CGSize(width: frame.width, height: frame.height)
        background.zPosition = -1
        addChild(background)

        // Создание и добавление рыцаря
        knight = SKSpriteNode(imageNamed: "knight")
        knight.position = CGPoint(x: frame.midX, y: frame.midY)
        knight.size = CGSize(width: Constants.khightWidth, height: Constants.khightHeight)
        knight.zPosition = 1
        addChild(knight)

        // Создание mapBox
        let boxWidth = frame.width * 0.12
        let boxHeight = boxWidth
        mapBox = SKSpriteNode(imageNamed: "mapBox")
        mapBox.size = CGSize(width: boxWidth, height: boxHeight)
        mapBox.position = CGPoint(x: frame.minX + mapBox.size.width / 2 + 40,
                                  y: frame.minY + mapBox.size.height / 2 + 30)
        mapBox.zPosition = 2
        addChild(mapBox)

        map = SKSpriteNode(imageNamed: "map")
        map.size = CGSize(width: mapBox.size.width * 0.8, height: mapBox.size.height * 0.8)
        map.position = CGPoint(x: 0, y: 0)
        map.zPosition = 3
        mapBox.addChild(map)

        // Создание shopBox
        shopBox = SKSpriteNode(imageNamed: "shopBox")
        shopBox.size = CGSize(width: boxWidth, height: boxHeight)
        shopBox.position = CGPoint(x: frame.maxX - shopBox.size.width / 2 - 40,
                                   y: frame.minY + shopBox.size.height / 2 + 30)
        shopBox.zPosition = 2
        addChild(shopBox)

        let shop = SKSpriteNode(imageNamed: "shop")
        shop.size = CGSize(width: shopBox.size.width * 0.8, height: shopBox.size.height * 0.8)
        shop.position = CGPoint(x: 0, y: 0)
        shop.zPosition = 3
        shopBox.addChild(shop)

        // Настройка иконок
        let topPadding: CGFloat = 20
        let leftPadding: CGFloat = 50
        let spacing: CGFloat = 10
        let barWidth = frame.width * 0.3
        let barHeight = barWidth * 0.1
        let iconSize = CGSize(width: barHeight, height: barHeight)

        barHealth = SKSpriteNode(imageNamed: "barHealth")
        barHealth.size = CGSize(width: barWidth, height: barHeight)
        barHealth.position = CGPoint(x: frame.minX + leftPadding + barHealth.size.width / 2,
                                     y: frame.maxY - topPadding - barHealth.size.height / 2)
        barHealth.zPosition = 2
        addChild(barHealth)
        
        
        healthScale = SKSpriteNode(imageNamed: "healthScale")
        healthScale.anchorPoint = CGPoint(x: 0, y: 0.5)
        healthScale.position = CGPoint(x: -barHealth.size.width/2 + 5, y: 0)
        healthScale.size = CGSize(width: barHealth.size.width * 0.97, height: barHealth.size.height * 0.55)
        healthScale.zPosition = 3
        barHealth.addChild(healthScale)

        health = SKSpriteNode(imageNamed: "health")
        health.size = iconSize
        health.position = CGPoint(x: barHealth.position.x - barHealth.size.width / 2 - iconSize.width / 2 - spacing,
                                  y: barHealth.position.y)
        health.zPosition = 2
        addChild(health)

        barDamage = SKSpriteNode(imageNamed: "barDamage")
        barDamage.size = CGSize(width: barWidth, height: barHeight)
        barDamage.position = CGPoint(x: barHealth.position.x,
                                     y: barHealth.position.y - barHealth.size.height - spacing)
        barDamage.zPosition = 2
        addChild(barDamage)
        
        
        strengthScale = SKSpriteNode(imageNamed: "strengthScale")
        strengthScale.anchorPoint = CGPoint(x: 0, y: 0.5)
        strengthScale.position = CGPoint(x: -barDamage.size.width/2 + 5, y: 0)
        strengthScale.size = CGSize(width: barDamage.size.width, height: barDamage.size.height * 0.55)
        strengthScale.zPosition = 3
        barDamage.addChild(strengthScale)

        damage = SKSpriteNode(imageNamed: "damage")
        damage.size = iconSize
        damage.position = CGPoint(x: barDamage.position.x - barDamage.size.width / 2 - iconSize.width / 2 - spacing,
                                  y: barDamage.position.y)
        damage.zPosition = 2
        addChild(damage)

        barLoot = SKSpriteNode(imageNamed: "barLoot")
        barLoot.size = CGSize(width: barWidth, height: barHeight)
        barLoot.position = CGPoint(x: barDamage.position.x,
                                   y: barDamage.position.y - barDamage.size.height - spacing)
        barLoot.zPosition = 2
        addChild(barLoot)
        
        lootScale = SKSpriteNode(imageNamed: "lootScale")
        lootScale.anchorPoint = CGPoint(x: 0, y: 0.5)
        lootScale.position = CGPoint(x: -barLoot.size.width/2 + 5, y: 0)
        lootScale.size = CGSize(width: barLoot.size.width * 0.97, height: barLoot.size.height * 0.55)
        lootScale.zPosition = 3
        barLoot.addChild(lootScale)

        loot = SKSpriteNode(imageNamed: "loot")
        loot.size = iconSize
        loot.position = CGPoint(x: barLoot.position.x - barLoot.size.width / 2 - iconSize.width / 2 - spacing,
                                y: barLoot.position.y)
        loot.zPosition = 2
        addChild(loot)

        let settingsBoxSize = frame.width * 0.09
        settingsBox = SKSpriteNode(imageNamed: "settingsBox")
        settingsBox.size = CGSize(width: settingsBoxSize, height: settingsBoxSize)
        settingsBox.position = CGPoint(x: frame.maxX - settingsBox.size.width / 2 - 50,
                                       y: frame.maxY - settingsBox.size.height / 2 - 20)
        settingsBox.zPosition = 2
        addChild(settingsBox)

        let settings = SKSpriteNode(imageNamed: "settings")
        settings.size = CGSize(width: settingsBox.size.width * 0.8, height: settingsBox.size.height * 0.8)
        settings.position = CGPoint(x: 1, y: 0)
        settings.zPosition = 3
        settingsBox.addChild(settings)

        // Создание метки для монет
        coinLabel = SKLabelNode(fontNamed: UIFont.pixelFontName)
        coinLabel.text = "\(UserDefaults.standard.integer(forKey: "coinCount"))"
        coinLabel.fontSize = 12
        coinLabel.fontColor = SKColor(red: 0.96, green: 0.96, blue: 0.86, alpha: 1.0)
        coinLabel.position = CGPoint(x: barLoot.position.x, y: barLoot.position.y - 6)
        coinLabel.zPosition = 10
        addChild(coinLabel)
        
        healthLabel = SKLabelNode(fontNamed: UIFont.pixelFontName)
        healthLabel.text = "\(UserDefaults.standard.integer(forKey: "playerHealth"))"
        healthLabel.fontSize = 12
        healthLabel.fontColor = SKColor(red: 0.96, green: 0.96, blue: 0.86, alpha: 1.0)
        healthLabel.position = CGPoint(x: barHealth.position.x, y: barHealth.position.y - 6)
        healthLabel.zPosition = 10
        addChild(healthLabel)
        
        
        damageLabel = SKLabelNode(fontNamed: UIFont.pixelFontName)
        damageLabel.text = "\(UserDefaults.standard.integer(forKey: "playerStrength"))"
        damageLabel.fontSize = 12
        damageLabel.fontColor = SKColor(red: 0.96, green: 0.96, blue: 0.86, alpha: 1.0)
        damageLabel.position = CGPoint(x: barDamage.position.x, y: barDamage.position.y - 6)
        damageLabel.zPosition = 10
        addChild(damageLabel)
                                  
        presenter.coinCountDidChange(to: interactor.loadCoinCount())
        presenter.playerHealthDidChange(to: UserDefaults.standard.integer(forKey: "playerHealth"))
        presenter.playerStrengthDidChange(to: UserDefaults.standard.integer(forKey: "playerStrength"))
    }
    
    override func willMove(from view: SKView) {
        if let bgMusic = backgroundMusic {
            bgMusic.removeFromParent()
        }
    }

    // Обработка касаний
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)

        if knight.contains(location) {
            presenter?.knightTapped()
        } else if mapBox.contains(location) {
            presenter?.mapBoxTapped()
        } else if shopBox.contains(location) {
            presenter?.shopBoxTapped()
        } else if settingsBox.contains(location) {
            presenter?.settingsBoxTapped()
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        if knight.contains(location) {
            presenter?.knightReleased()
        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        knight.run(SKAction.scale(to: 1.0, duration: 0.1))
    }


    func updateCoinLabel(count: Int) {
        if let label = coinLabel {
            label.text = "\(count)"
        } else {
            print("Ошибка: coinLabel равен nil")
        }
    }

    func animateKnightTap() {
        knight.size = CGSize(width: Constants.khightWidth, height: Constants.khightHeight)
        knight.run(SKAction.scale(to: 0.8, duration: 0.1))
        let soundAction = SKAction.playSoundFileNamed("sound.mp3", waitForCompletion: false)
        knight.run(soundAction)
    }

    func animateKnightRelease() {
        knight.run(SKAction.scale(to: 1.0, duration: 0.1))
    }
    
    func updateLootScale(percent: CGFloat) {
        let minWidth: CGFloat = 2.0
        let maxWidth = barLoot.size.width * 0.97
        lootScale.size.width = max(minWidth, maxWidth * percent)
    }

    func updateHealthScale(percent: CGFloat) {
        let minWidth: CGFloat = 2.0
        let maxWidth = barHealth.size.width * 0.97
        healthScale.size.width = max(minWidth, maxWidth * percent)
    }

    func updateStrengthScale(percent: CGFloat) {
        let minWidth: CGFloat = 2.0
        let maxWidth = barDamage.size.width * 0.97
        strengthScale.size.width = max(minWidth, maxWidth * percent)
    }
    
}


extension UIFont {
    static var pixelFontName: String { "Alagard-12px-unicode" }
}
