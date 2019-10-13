import Foundation

protocol ScenePresenterLogic: class {
  
  func presentIncreaseCount(response: SceneModel.Title.Response)
}

final class ScenePresenter: ScenePresenterLogic {
  
  weak var view: SceneDisplayLogic?
  
  func presentIncreaseCount(response: SceneModel.Title.Response) {
    
    let viewModel = SceneModel.Title.ViewModel(displayTitle: "Tap Tap x \(response.count)")
    view?.displayIncreaseTapCount(viewModel: viewModel)
  }
}
