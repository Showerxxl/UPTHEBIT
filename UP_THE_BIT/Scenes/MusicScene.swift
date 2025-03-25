import SpriteKit
import MediaPlayer

class MusicSelectionScene: SKScene {
    
    private var mediaPicker: MPMediaPickerController?
    private var musicPlayer: MPMusicPlayerController?
    
    override func didMove(to view: SKView) {

        backgroundColor = SKColor.black
        
        // Создание кнопки выбора музыки
        let selectMusicButton = SKLabelNode(text: "Выбрать фоновую музыку")
        selectMusicButton.fontSize = 30
        selectMusicButton.fontColor = SKColor.white
        selectMusicButton.position = CGPoint(x: size.width/2, y: size.height/2)
        selectMusicButton.name = "selectMusic"
        addChild(selectMusicButton)
        

        musicPlayer = MPMusicPlayerController.applicationMusicPlayer
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNode = atPoint(location)
        
        if touchedNode.name == "selectMusic" {
            showMediaPicker()
        }
    }
    
    private func showMediaPicker() {
        mediaPicker = MPMediaPickerController(mediaTypes: .music)
        if let picker = mediaPicker {
            picker.delegate = self
            picker.allowsPickingMultipleItems = false
            picker.showsCloudItems = true
            

            if let viewController = view?.window?.rootViewController {
                viewController.present(picker, animated: true, completion: nil)
            }
        }
    }
}

extension MusicSelectionScene: MPMediaPickerControllerDelegate {

    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        // Устанавливаем выбранную музыку
        musicPlayer?.setQueue(with: mediaItemCollection)
        musicPlayer?.play()
        
        // Закрываем picker и переходим на FirstLvl после выбора песни
        mediaPicker.dismiss(animated: true, completion: { [weak self] in
            guard let self = self else { return }
            
      
            let view = FirstLvlView(size: self.size)
            let interactor = FirstLvlInteractor()
            let router = FirstLvlRouter(view: view)
            let presenter = FirstLvlPresenter(view: view, interactor: interactor, router: router)
            

            view.presenter = presenter
            

            view.scaleMode = .aspectFill
            
    
            let transition = SKTransition.fade(withDuration: 0.5)
            self.view?.presentScene(view, transition: transition)
        })
    }
    
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {

        mediaPicker.dismiss(animated: true, completion: nil)
    }
}
