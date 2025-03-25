import SpriteKit
import GameplayKit
import AVFoundation

protocol GameViewProtocol: AnyObject {
    func updateCoinLabel(count: Int)
    func animateKnightTap()
    func animateKnightRelease()
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
    var backgroundMusic: SKAudioNode?

    var presenter: GamePresenterProtocol?

    override func didMove(to view: SKView) {
        // Настройка аудиосессии
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Ошибка настройки AVAudioSession: \(error)")
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

        presenter.coinCountDidChange(to: interactor.loadCoinCount())

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

        loot = SKSpriteNode(imageNamed: "loot")
        loot.size = iconSize
        loot.position = CGPoint(x: barLoot.position.x - barLoot.size.width / 2 - iconSize.width / 2 - spacing,
                                y: barLoot.position.y)
        loot.zPosition = 2
        addChild(loot)

        // Создание settingsBox
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
        coinLabel = SKLabelNode(fontNamed: "Arial-BoldMT")
        coinLabel.text = "0"
        coinLabel.fontSize = 12
        coinLabel.fontColor = SKColor(red: 0.96, green: 0.96, blue: 0.86, alpha: 1.0)
        coinLabel.position = CGPoint(x: barLoot.position.x, y: barLoot.position.y - 6)
        coinLabel.zPosition = 10
        addChild(coinLabel)

        // Добавление фоновой музыки
        if let musicURL = Bundle.main.url(forResource: "mainMelody", withExtension: "mp3") {
            backgroundMusic = SKAudioNode(url: musicURL)
            if let backgroundMusic = backgroundMusic {
                addChild(backgroundMusic)
                backgroundMusic.autoplayLooped = true
            }
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

    // Реализация методов GameViewProtocol
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
}
