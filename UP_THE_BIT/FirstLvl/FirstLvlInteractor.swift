import Foundation
class FirstLvlInteractor {
    var warriorLives: Int = 5
    var troopHealth: Int = 5
    var lastHitTime: TimeInterval = 0.0
    
    func handleCollision(currentTime: TimeInterval) -> Bool {
        if currentTime - lastHitTime < 1.0 { return false }
        lastHitTime = currentTime
        warriorLives -= 1
        return warriorLives <= 0
    }
    
    func handleSwordHit(distance: CGFloat) -> Bool {
        if distance <= 120 {
            troopHealth -= 1
            return troopHealth <= 0
        }
        return false
    }
}
