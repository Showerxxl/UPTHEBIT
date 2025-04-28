import Foundation
import SpriteKit
import MediaPlayer
import AVFoundation

// Added SpriteKit import because we will be handling UI elements.

class FirstLvlInteractor {
    var lastHitTime: TimeInterval = 0.0
    static var isMovingRight = false
    static var isMovingLeft = false
    
    
    weak var view: FirstLvlView?
    var router: FirstLvlRouter!
    weak var presenter: FirstLvlPresenter?
    var beatDuration: TimeInterval = 0.5
    
 
    private let defaultBPM: Double = 120.0

    private let mainMelodyBPM: Double = 128.0
    
    struct TroopBounceInfo {
        var bounceEndTime: TimeInterval = 0
        var active: Bool = false
    }
    private var troopBounceStates: [Int: TroopBounceInfo] = [:]
    
    private var lastTroopAttackTime: [Int: TimeInterval] = [:]
    private let troopAttackCooldown: TimeInterval = 1.0
    private let minTroopAttackDistance: CGFloat = 40.0
    
    func handleCollision(currentTime: TimeInterval) -> Bool {
        if currentTime - lastHitTime < 1.0 { return false }
        lastHitTime = currentTime
        Warrior.health -= 1
        return Warrior.health <= 0
    }
    
    func handleSwordHit(distance: CGFloat) -> Bool {
        
        return false
    }
    
   
    func updateWarriorVelocity(dx: CGFloat) {
        view?.warrior.physicsBody?.velocity.dx = dx
    }
    
    func updateWarriorScale(xScale: CGFloat) {
        view?.warrior.xScale = xScale
    }
    
    func updateHealthBar(width: CGFloat) {
        view?.barHealth.size.width = width
    }
    
    
    func startMovingRight() {
        FirstLvlInteractor.isMovingRight = true
    }
    
    func stopMovingRight() {
        FirstLvlInteractor.isMovingRight = false
    }
    
    func startMovingLeft() {
        FirstLvlInteractor.isMovingLeft = true
    }
    
    func stopMovingLeft() {
        FirstLvlInteractor.isMovingLeft = false
    }
    
    func syncWarriorCoordinates() {
        guard let warrior = view?.warrior else { return }
        Warrior.xPosition = warrior.position.x
        Warrior.yPosition = warrior.position.y
    }
    
    func updateTroopsCoordinates() {
        for i in 0..<Troop.troopsData.count {
            if let troopNode = findTroopSpriteByIndex(i) {
                Troop.troopsData[i].position = troopNode.position
            }
        }
    }

    
    func setUpTroopsData() {
        guard let view = self.view else {
            print("Error: View is not set")
            return
        }
        
        Troop.troopsData.removeAll()
        let frame = view.frame
        
        for i in 0..<Troop.troopCount {
            let position = CGPoint(x: frame.minX + 20 + frame.width / 6 * CGFloat(i + 1), y: frame.maxY - 100)
            let size = CGSize(width: 118, height: 115)
            let id = UUID().uuidString
            let troop = TroopData(

                position: position,
                size: size,
                health: Troop.troopHealth,
                speed: Troop.troopSpeed,
                name: "troop_\(i)",
                index: i
            )
            
            Troop.troopsData.append(troop)
        }
        
    }
    
    func findNearestEnemy() -> Int? {

        guard let warriorNode = view?.warrior, !Troop.troopsData.isEmpty else { return nil }
        let warriorPos = CGPoint(x: Warrior.xPosition, y: Warrior.yPosition)
        let lookRight = warriorNode.xScale > 0
        
        var minDistance = CGFloat.greatestFiniteMagnitude
        var nearestIndex: Int? = nil
        
        for (i, troop) in Troop.troopsData.enumerated() {
            let dx = troop.position.x - warriorPos.x
          
            if (lookRight && dx <= 0) || (!lookRight && dx >= 0) {
                continue
            }
            let dy = troop.position.y - warriorPos.y
            let dist = sqrt(dx*dx + dy*dy)
            if dist < minDistance {
                minDistance = dist
                nearestIndex = i
            }
        }
        return nearestIndex
    }
    
    func bounceTroop(at index: Int, fromWarriorX warriorX: CGFloat, sceneTime: TimeInterval) {
        guard let troopNode = findTroopSpriteByIndex(index),
              Troop.troopsData.indices.contains(index),
              let warriorNode = view?.warrior
        else { return }
        
        
        let dx = troopNode.position.x - warriorX
        var bounceDirection: CGFloat
        if abs(dx) < 2.0 {
            bounceDirection = warriorNode.xScale >= 0 ? 1 : -1
        } else {
            bounceDirection = dx > 0 ? 1 : -1
        }
  
        let impulseX: CGFloat = 50.0 * bounceDirection
        let impulseY: CGFloat = 50.0

        troopNode.physicsBody?.velocity = .zero
        troopNode.physicsBody?.applyImpulse(CGVector(dx: impulseX, dy: impulseY))

        troopBounceStates[index] = TroopBounceInfo(bounceEndTime: sceneTime + 0.45, active: true)
    }
    

    func moveTroopsTowardWarrior(currentTime: TimeInterval) {
        guard let view = self.view else { return }
        let warriorPos = view.warrior.position
        let runKey = "troopRunAnimation"
        let attackKey = "troopAttackAnimation"

        for i in 0..<Troop.troopsData.count {
            guard let troopNode = findTroopSpriteByIndex(i) else { continue }
            let troopData = Troop.troopsData[i]


            if let bounce = troopBounceStates[i], bounce.active {
                if currentTime < bounce.bounceEndTime {
                    continue
                }
                troopBounceStates[i] = nil
            }

           
            if troopNode.action(forKey: attackKey) != nil {
       
                troopNode.physicsBody?.velocity.dx = 0
                continue
            }

            let dx = warriorPos.x - troopNode.position.x
            let speed: CGFloat = troopData.speed
            let direction: CGFloat
            if abs(dx) < 2.0 {
                direction = 0
            } else {
                direction = dx > 0 ? 1 : -1
            }
            troopNode.physicsBody?.velocity.dx = speed * direction

  
            if direction > 0 {
                troopNode.xScale = abs(troopNode.xScale)
            } else if direction < 0 {
                troopNode.xScale = -abs(troopNode.xScale)
            }

  
            if direction != 0 {
                if troopNode.action(forKey: runKey) == nil, !view.troopRunFrames.isEmpty {
                    let runAction = SKAction.animate(with: view.troopRunFrames, timePerFrame: 0.12)
                    troopNode.run(SKAction.repeatForever(runAction), withKey: runKey)
                }
            } else {
                if troopNode.action(forKey: runKey) != nil {
                    troopNode.removeAction(forKey: runKey)
                    if let staticTexture = view.troopRunFrames.first {
                        troopNode.texture = staticTexture
                    }
                }
            }


            let distanceToWarrior = hypot(warriorPos.x - troopNode.position.x, warriorPos.y - troopNode.position.y)
            if distanceToWarrior <= minTroopAttackDistance {
                let lastAttack = lastTroopAttackTime[i] ?? 0
                if currentTime - lastAttack >= troopAttackCooldown {
                    attackWarriorByTroop(index: i, at: currentTime, attackSourceX: troopNode.position.x)
                }
            }
        }
    }

    
    private func attackWarriorByTroop(index: Int, at time: TimeInterval, attackSourceX: CGFloat) {
        lastTroopAttackTime[index] = time
        Warrior.health -= 1
        
        print("[TROOP ATTACK] Troop \(index) атаковал Warrior! Осталось жизней: \(Warrior.health)")
        
        if let view = self.view {
            view.playTroopAttackAnimation(index: index) { [weak self] in
                guard let self = self else { return }
                let userDefaults = UserDefaults.standard
                let maxHealth = userDefaults.integer(forKey: "playerHealth")
                view.updateHealthBar(currentHealth: Warrior.health, maxHealth: maxHealth)
                self.presenter?.bounceWarrior(from: attackSourceX)
            }
        } else {
       
            self.presenter?.bounceWarrior(from: attackSourceX)
        }
    }
    
    private func troopSpeed(forBPM bpm: Double) -> CGFloat {
    
        return CGFloat(max(30.0, min(bpm * 0.7, 180.0)))
    }
    
    
    func extractBPM(from string: String) -> Double? {
        let pattern = #"BPM is ([0-9]+(?:\.[0-9]+)?)"#
        if let regex = try? NSRegularExpression(pattern: pattern, options: []),
           let match = regex.firstMatch(in: string, options: [], range: NSRange(location: 0, length: string.utf16.count)),
           let bpmRange = Range(match.range(at: 1), in: string) {
            let bpmString = String(string[bpmRange])
            return Double(bpmString)
        }
        return nil
    }
    
    func updateBPM(completion: ((TimeInterval) -> Void)? = nil) {
        print("[BPM] Начинаем определение BPM")
        
        let applicationPlayer = MPMusicPlayerController.applicationMusicPlayer
        let systemPlayer = MPMusicPlayerController.systemMusicPlayer

        print("[BPM][DEBUG] applicationPlayer.playbackState: \(applicationPlayer.playbackState.rawValue), nowPlayingItem: \(String(describing: applicationPlayer.nowPlayingItem))")
        print("[BPM][DEBUG] systemPlayer.playbackState: \(systemPlayer.playbackState.rawValue), nowPlayingItem: \(String(describing: systemPlayer.nowPlayingItem))")
        
        let activePlayer: MPMusicPlayerController?
        if let item = applicationPlayer.nowPlayingItem {
            activePlayer = applicationPlayer
            print("[BPM][DEBUG] Используем applicationPlayer")
        } else if let item = systemPlayer.nowPlayingItem {
            activePlayer = systemPlayer
            print("[BPM][DEBUG] Используем systemPlayer")
        } else {
            activePlayer = nil
            print("[BPM][DEBUG] Нет доступного nowPlayingItem ни в одном плеере")
        }
        
        if let currentItem = activePlayer?.nowPlayingItem {
            print("[BPM] Найден nowPlayingItem в MPMusicPlayerController")
            
       
            if let bpm = currentItem.value(forProperty: MPMediaItemPropertyBeatsPerMinute) as? NSNumber,
               bpm.doubleValue > 0 {
                print("[BPM] Получен BPM из метаданных: \(bpm.doubleValue)")
                self.beatDuration = 60.0 / bpm.doubleValue
                Troop.troopSpeed = troopSpeed(forBPM: bpm.doubleValue)
                UserDefaults.standard.set(bpm.doubleValue, forKey: "LastKnownBPM")
                completion?(self.beatDuration)
                return
            }
            
         
            if let assetURL = currentItem.assetURL {
                print("[BPM] Анализируем BPM из файла")
                _ = BPMAnalyzer.core.getBpmFrom(assetURL) { [weak self] bpmString in
                    guard let self = self else { return }
                    print("[BPM] Результат анализа: \(bpmString)")
                    if let bpm = self.extractBPM(from: bpmString), bpm > 0 {
                        self.beatDuration = 60.0 / bpm
                        Troop.troopSpeed = self.troopSpeed(forBPM: bpm)
                        UserDefaults.standard.set(bpm, forKey: "LastKnownBPM")
                        print("[BPM] Успешно определен BPM: \(bpm)")
                        completion?(self.beatDuration)
                    }
                }
                return
            }
        }
    }


    
    
    func findTroopSpriteByIndex(_ index: Int) -> SKSpriteNode? {
        guard let view = view else { return nil }
        let troopName = "troop_\(index)"
        return view.children.first(where: { $0.name == troopName }) as? SKSpriteNode
    }


    func handleSwordHitAndBounce(presenter: FirstLvlPresenter) {
        guard let view = self.view else { return }
        guard let nearestTroopIndex = findNearestEnemy(),
              let troopNode = findTroopSpriteByIndex(nearestTroopIndex)
        else {
            print("No troop to hit")
            return
        }

        let warriorPosition = CGPoint(x: Warrior.xPosition, y: Warrior.yPosition)
        let distance = hypot(troopNode.position.x - warriorPosition.x, troopNode.position.y - warriorPosition.y)
        let minHitRadius = (view.warrior.size.width + troopNode.size.width) / 2 + 15

        print("[DEBUG] Sword hit? dist=\(distance), minRadiusForHit=\(minHitRadius)")

        if distance <= minHitRadius {
            
            print(distance)
            Troop.troopsData[nearestTroopIndex].health -= Warrior.strength
            print("[HIT] Труп \(nearestTroopIndex) получил урон. Осталось жизней: \(Troop.troopsData[nearestTroopIndex]).health)")


            let sceneTime = CACurrentMediaTime()
            bounceTroop(at: nearestTroopIndex, fromWarriorX: Warrior.xPosition, sceneTime: sceneTime)

           
            if Troop.troopsData[nearestTroopIndex].health <= 0 {
                presenter.removeTroopSprite(at: nearestTroopIndex)
                return
            }
        } else {
            print("[MISS] Труп \(nearestTroopIndex) слишком далеко для удара.")
        }
    }
  

}
