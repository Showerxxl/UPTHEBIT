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
