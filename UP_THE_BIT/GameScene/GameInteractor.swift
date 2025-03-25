import Foundation

protocol GameInteractorProtocol: AnyObject {
    func incrementCoinCount()
    func loadCoinCount() -> Int
}

class GameInteractor: GameInteractorProtocol {
    weak var presenter: GamePresenterProtocol?
    var player: PlayerEntity {
        didSet {

            UserDefaults.standard.set(player.coinCount, forKey: "coinCount")
        }
    }

    init() {
        let savedCoinCount = UserDefaults.standard.integer(forKey: "coinCount")
        player = PlayerEntity(coinCount: savedCoinCount)
    }

    func incrementCoinCount() {
        player.coinCount += 1
        presenter?.coinCountDidChange(to: player.coinCount)
    }

    func loadCoinCount() -> Int {
        return player.coinCount
    }
}
