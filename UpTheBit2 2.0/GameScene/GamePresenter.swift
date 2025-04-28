import UIKit

protocol GamePresenterProtocol: AnyObject {
    func knightTapped()
    func knightReleased()
    func mapBoxTapped()
    func shopBoxTapped()
    func settingsBoxTapped()
    func coinCountDidChange(to count: Int)
    func playerHealthDidChange(to value: Int)
    func playerStrengthDidChange(to value: Int)
}

class GamePresenter: GamePresenterProtocol {
    weak var view: GameViewProtocol?
    var interactor: GameInteractorProtocol?
    var router: GameRouterProtocol?
    
    
    let maxCoinCount: CGFloat = 20000.0
    let maxPlayerHealth: CGFloat = 20.0
    let maxPlayerStrength: CGFloat = 13.0

    func knightTapped() {
        interactor?.incrementCoinCount()
        view?.animateKnightTap()
    }

    func knightReleased() {
        view?.animateKnightRelease()
    }

    func mapBoxTapped() {
        router?.navigateToMapScene()
    }

    func shopBoxTapped() {
        router?.navigateToShopScene()
    }
    
    func settingsBoxTapped() {
        router?.navigateToSettingsScene()
    }

    func coinCountDidChange(to count: Int) {
        view?.updateCoinLabel(count: count)
        let percent = min(1.0, CGFloat(count)/maxCoinCount)
        view?.updateLootScale(percent: percent)
    }

    func playerHealthDidChange(to value: Int) {
        let percent = min(1.0, CGFloat(value)/maxPlayerHealth)
        view?.updateHealthScale(percent: percent)
    }

    func playerStrengthDidChange(to value: Int) {
        let percent = min(1.0, CGFloat(value)/maxPlayerStrength)
        view?.updateStrengthScale(percent: percent)
    }
}
