
import Foundation

protocol GameInteractorProtocol: AnyObject {
    func incrementCoinCount()
    func loadCoinCount() -> Int

    func savePlayer()
    func loadPlayer()
}

class GameInteractor: GameInteractorProtocol {
    weak var presenter: GamePresenterProtocol?
    var player: PlayerEntity {
        didSet {
            savePlayer()
        }
    }

    init() {
        let savedCoinCount = UserDefaults.standard.integer(forKey: "coinCount")
        let savedHealth = UserDefaults.standard.object(forKey: "playerHealth") as? Int ?? 5
        let savedStrength = UserDefaults.standard.object(forKey: "playerStrength") as? Int ?? 1
        let savedLoot = UserDefaults.standard.object(forKey: "playerLoot") as? Int ?? 1
        player = PlayerEntity(coinCount: savedCoinCount, health: savedHealth, strength: savedStrength, loot: savedLoot)
    }

    func incrementCoinCount() {
        player.coinCount += player.loot
        presenter?.coinCountDidChange(to: player.coinCount)
    }

    func loadCoinCount() -> Int {
        return player.coinCount
    }
    

    
    func savePlayer() {
        UserDefaults.standard.set(player.coinCount, forKey: "coinCount")
        UserDefaults.standard.set(player.health, forKey: "playerHealth")
        UserDefaults.standard.set(player.strength, forKey: "playerStrength")
        UserDefaults.standard.set(player.loot, forKey: "playerLoot")
    }

    func loadPlayer() {
        player.coinCount = UserDefaults.standard.integer(forKey: "coinCount")
        player.health = UserDefaults.standard.object(forKey: "playerHealth") as? Int ?? 5
        player.strength = UserDefaults.standard.object(forKey: "playerStrength") as? Int ?? 1
        player.loot = UserDefaults.standard.object(forKey: "playerLoot") as? Int ?? 1
    }
}
