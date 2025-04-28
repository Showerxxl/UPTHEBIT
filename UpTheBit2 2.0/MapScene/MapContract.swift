import SpriteKit


protocol MapViewProtocol: AnyObject {
    var view: SKView? { get }
}


protocol MapPresenterProtocol: AnyObject {
    func backButtonTapped()
    func firstBoxTapped()
}


protocol MapInteractorProtocol: AnyObject {
}


protocol MapRouterProtocol: AnyObject {
    func navigateToMainScene(from view: MapViewProtocol)
    func navigateToMusicScene(from view: MapViewProtocol)
}
