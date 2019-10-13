import Foundation

protocol ScenePresenterLogic: class {
  
  func presentIncreaseCount(response: SceneModel.Title.Response)
  func presentFetchItem(response: SceneModel.FetchItem.Response)
  func presentUpdateItem(response: SceneModel.UpdateItem.Response)
}

final class ScenePresenter: ScenePresenterLogic {
  
  weak var view: SceneDisplayLogic?
  
  func presentIncreaseCount(response: SceneModel.Title.Response) {
    
    let viewModel = SceneModel.Title.ViewModel(displayTitle: "Tap Tap x \(response.count)")
    view?.displayIncreaseTapCount(viewModel: viewModel)
  }
  
  func presentFetchItem(response: SceneModel.FetchItem.Response) {
    // nothing
  }
  
  func presentUpdateItem(response: SceneModel.UpdateItem.Response) {
    // nothing
  }
}
