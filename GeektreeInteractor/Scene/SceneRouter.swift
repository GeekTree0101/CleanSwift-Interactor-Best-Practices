import Foundation

protocol SceneRouterLogic: class {

}

protocol SceneDataPassing: class {
  
  var dataStore: SceneDataStore? { get }
}

final class SceneRouter: SceneDataPassing {
  
  var dataStore: SceneDataStore?
  weak var viewController: SceneController?
  
}

extension SceneRouter: SceneRouterLogic {
  
}
