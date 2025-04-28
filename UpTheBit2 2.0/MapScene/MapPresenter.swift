import Foundation

class MapPresenter: MapPresenterProtocol {
    weak var view: MapViewProtocol!
    var interactor: MapInteractorProtocol!
    var router: MapRouterProtocol!
    
    
    func backButtonTapped() {
        router.navigateToMainScene(from: view)
    }
    

    func firstBoxTapped() {
        router.navigateToMusicScene(from: view)
    }
}
