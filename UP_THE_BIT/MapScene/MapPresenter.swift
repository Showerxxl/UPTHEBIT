import Foundation

class MapPresenter: MapPresenterProtocol {
    weak var view: MapViewProtocol!
    var interactor: MapInteractorProtocol!
    var router: MapRouterProtocol!
    
    // Обработка нажатия на кнопку "назад"
    func backButtonTapped() {
        router.navigateToMainScene(from: view)
    }
    
    // Обработка нажатия на первую коробку
    func firstBoxTapped() {
        router.navigateToShopScene(from: view)
    }
}
