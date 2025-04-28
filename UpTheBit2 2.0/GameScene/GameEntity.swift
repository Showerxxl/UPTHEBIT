
import Foundation

enum PlayerScreenState: String, Codable {
    case mainMenu
    case firstLevel
    case settings
    case shop
    case map
}

struct PlayerEntity {
    var coinCount: Int
    var health: Int = 5
    var strength: Int = 1
    var loot: Int = 1
    var screenState: PlayerScreenState = .mainMenu


    private static let screenStateKey = "playerScreenState"

    // Сохрание текущее состояние экрана в UserDefaults
    func saveScreenState() {
        UserDefaults.standard.set(screenState.rawValue, forKey: PlayerEntity.screenStateKey)
    }

    // Загрузка состояние экрана из UserDefaults
    static func loadScreenState() -> PlayerScreenState {
        if let raw = UserDefaults.standard.string(forKey: PlayerEntity.screenStateKey),
           let state = PlayerScreenState(rawValue: raw) {
            return state
        } else {
            return .mainMenu
        }
    }
}
