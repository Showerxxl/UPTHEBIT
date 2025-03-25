import SpriteKit

// Протокол для View, предоставляющий доступ к SKView для навигации
protocol MapViewProtocol: AnyObject {
    var view: SKView? { get }
}

// Протокол для Presenter, определяющий обработку действий пользователя
protocol MapPresenterProtocol: AnyObject {
    func backButtonTapped()
    func firstBoxTapped()
}


protocol MapInteractorProtocol: AnyObject {
}

// Протокол для Router, отвечающий за навигацию
protocol MapRouterProtocol: AnyObject {
    func navigateToMainScene(from view: MapViewProtocol)
    func navigateToShopScene(from view: MapViewProtocol)
}
