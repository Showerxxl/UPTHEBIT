protocol GamePresenterProtocol: AnyObject {
    func knightTapped()
    func knightReleased()
    func mapBoxTapped()
    func shopBoxTapped()
    func coinCountDidChange(to count: Int)
}

class GamePresenter: GamePresenterProtocol {
    weak var view: GameViewProtocol?
    var interactor: GameInteractorProtocol?
    var router: GameRouterProtocol?

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

    func coinCountDidChange(to count: Int) {
        view?.updateCoinLabel(count: count)
    }
}
