import UIKit
import MediaPlayer


protocol MusicPickerManagerDelegate: AnyObject {
    
    func musicPickerManagerDidPickMusic(_ manager: MusicPickerManager)
    
   
    func musicPickerManagerDidCancel(_ manager: MusicPickerManager)
}


class MusicPickerManager: NSObject, MPMediaPickerControllerDelegate {
    
    weak var delegate: MusicPickerManagerDelegate?
    weak var presentingViewController: UIViewController?
    
    init(presentingViewController: UIViewController) {
        self.presentingViewController = presentingViewController
        super.init()
    }
    

    func presentMediaPicker() {
        let mediaPicker = MPMediaPickerController(mediaTypes: .music)
        mediaPicker.delegate = self
        mediaPicker.allowsPickingMultipleItems = false
        mediaPicker.showsCloudItems = true
        mediaPicker.prompt = "Выберите мелодию для игры"
        
        presentingViewController?.present(mediaPicker, animated: true)
    }
    
 
    
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        
        mediaPicker.dismiss(animated: true)
        
        guard let item = mediaItemCollection.items.first else {
            print("Не удалось получить MPMediaItem выбранной мелодии")
            return
        }
        

        MusicPlayerService.shared.playCustomMusic(mediaItem: item)
        

        delegate?.musicPickerManagerDidPickMusic(self)
    }
    
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        mediaPicker.dismiss(animated: true)
        delegate?.musicPickerManagerDidCancel(self)
    }
}
