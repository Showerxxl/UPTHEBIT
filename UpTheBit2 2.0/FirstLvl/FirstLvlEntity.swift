import Foundation

protocol FirstLvlEntityProtocol: AnyObject {
    var isMovingLeft: Bool { get set }
    var isMovingRight: Bool { get set }
    var isJumping: Bool { get set }
    var warriorLives: Int { get set }
    var troopHealth: Int { get set }
}

class FirstLvlEntity: FirstLvlEntityProtocol {
    var isMovingLeft: Bool = false
    var isMovingRight: Bool = false
    var isJumping: Bool = false
    var warriorLives: Int = 5
    var troopHealth: Int = 5
}

struct TroopData {
    
    var position: CGPoint
    var size: CGSize
    var health: Int
    var speed: CGFloat
    var name: String
    var index: Int

}

class Troop {
    static var troopsData: [TroopData] = []
    static var troopCount: Int = 5
    static var troopSpeed: CGFloat = 50.0
    static var troopHealth: Int = 4
    static let troopCategory = 0x1 << 2
    
}


class Warrior {
    static var health: Int = UserDefaults.standard.integer(forKey: "playerHealth")
    
    static func reloadHealthFromDefaults() {
        health = UserDefaults.standard.integer(forKey: "playerHealth")
    }

    static var strength: Int {
        get { UserDefaults.standard.integer(forKey: "playerStrength") }
        set { UserDefaults.standard.set(newValue, forKey: "playerStrength") }
    }
    static var loot: Int {
        get { UserDefaults.standard.integer(forKey: "playerLoot") }
        set { UserDefaults.standard.set(newValue, forKey: "playerLoot") }
    }
    static let warriorCategory = 0x1 << 0
    static var xPosition: CGFloat = 0
    static var yPosition: CGFloat = 0
}



