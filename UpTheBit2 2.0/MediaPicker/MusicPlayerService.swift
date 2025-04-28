import MediaPlayer
import AVFoundation


class MusicPlayerService {

    static let shared = MusicPlayerService()
    

    private let customMusicChosenKey = "customMusicChosen"
    private let customMusicURLKey = "customMusicURL"
    private let isMusicPlayingKey = "isMusicPlaying"
    private let lastKnownBPMKey = "LastKnownBPM"
    

    private var isMusicInitialized = false
    
    private var audioPlayer: AVAudioPlayer?
    private let musicPlayer = MPMusicPlayerController.applicationMusicPlayer
    
    private init() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Не удалось настроить аудиосессию: \(error)")
        }
    }
    

    func isCustomMusicPlaying() -> Bool {
        return UserDefaults.standard.bool(forKey: customMusicChosenKey)
    }
    

    func isPlaying() -> Bool {

        guard let player = audioPlayer else {
            return false
        }
        return player.isPlaying
    }
    

    func setCustomMusicChosen(_ chosen: Bool) {
        UserDefaults.standard.set(chosen, forKey: customMusicChosenKey)
    }
    

    func shouldInitializeMusic() -> Bool {
        return !isMusicInitialized
    }
    

    func setMusicInitialized() {
        isMusicInitialized = true
    }
    
 
    func stopMusic() {
        audioPlayer?.stop()
    }
    
  
    func playDefaultMusic() {

        stopMusic()
        

        setCustomMusicChosen(false)
        

        if let musicURL = Bundle.main.url(forResource: "mainMelody", withExtension: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: musicURL)
                audioPlayer?.numberOfLoops = -1
                audioPlayer?.prepareToPlay()
                audioPlayer?.play()
                
         
                UserDefaults.standard.set(true, forKey: isMusicPlayingKey)
                UserDefaults.standard.set(128.0, forKey: lastKnownBPMKey)
                
                print("Стандартная музыка успешно запущена")
            } catch {
                print("Ошибка воспроизведения стандартной музыки: \(error)")
            }
        } else {
            print("Ошибка: файл mainMelody.mp3 не найден в бандле приложения")
        }
    }
    

    func playCustomMusic(mediaItem: MPMediaItem) {
        let mediaCollection = MPMediaItemCollection(items: [mediaItem])
        let descriptor = MPMusicPlayerMediaItemQueueDescriptor(itemCollection: mediaCollection)
        musicPlayer.setQueue(with: descriptor)
        musicPlayer.play()
        

        UserDefaults.standard.set(true, forKey: isMusicPlayingKey)
        setCustomMusicChosen(true)
 
        UserDefaults.standard.set(mediaItem.persistentID, forKey: "customMediaItemPersistentID")
        

        if let bpm = mediaItem.value(forProperty: MPMediaItemPropertyBeatsPerMinute) as? NSNumber {
            UserDefaults.standard.set(bpm.doubleValue, forKey: lastKnownBPMKey)
        }
    }
    

    func forcePlayIfCustomMusicChosen() {
        guard isCustomMusicPlaying() else { return }


        let persistentID = UserDefaults.standard.object(forKey: "customMediaItemPersistentID") as? NSNumber
        guard let persistentIDValue = persistentID?.uint64Value else {
            print("Не удалось получить persistentID для пользовательского трека")
            playDefaultMusic()
            return
        }

  
        let predicate = MPMediaPropertyPredicate(value: persistentIDValue, forProperty: MPMediaItemPropertyPersistentID, comparisonType: .equalTo)
        let query = MPMediaQuery.songs()
        query.addFilterPredicate(predicate)
        guard let mediaItem = query.items?.first else {
            print("Не удалось найти media item по persistentID")
            playDefaultMusic()
            return
        }

        playCustomMusic(mediaItem: mediaItem)
    }
    
 
    func getCurrentAudioPlayer() -> AVAudioPlayer? {
        return audioPlayer
    }
    

    func getApproximateBPM() -> Double {
        if !isCustomMusicPlaying() {
         
            return 128.0
        }
        
        return UserDefaults.standard.double(forKey: lastKnownBPMKey) != 0 ?
               UserDefaults.standard.double(forKey: lastKnownBPMKey) : 120.0
    }
    
 
    private func analyzeBPM(url: URL) {
        let defaultBPM: Double = 120.0
        UserDefaults.standard.set(defaultBPM, forKey: lastKnownBPMKey)
    }
}
