import Foundation

protocol SceneInteractorLogic: class {
  
  // Basic
  func increaseTapCount(request: SceneModel.Title.Request)
  
  // Examples
}

protocol SceneDataStore: class {
  
  var tapCount: Int { get set }
}

final class SceneInteractor: SceneDataStore {
  
  // MARK: - Presenter
  var presenter: ScenePresenterLogic?
  
  // MARK: - Workers
  var worker: SceneWorker?
  
  // MARK: - Data
  var tapCount: Int = 0
}

extension SceneInteractor: SceneInteractorLogic {
  
  func increaseTapCount(request: SceneModel.Title.Request) {
    self.tapCount += 1
    let response = SceneModel.Title.Response(count: self.tapCount)
    presenter?.presentIncreaseCount(response: response)
  }
}
