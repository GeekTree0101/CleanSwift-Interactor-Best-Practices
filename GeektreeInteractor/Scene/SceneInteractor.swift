import Foundation
import PromiseKit

protocol SceneInteractorLogic: class {
  
  // Basic
  func increaseTapCount(request: SceneModel.Title.Request)
  
  // Examples
  func fetchItem(request: SceneModel.FetchItem.Request) -> Guarantee<SceneModel.FetchItem.Response>
  func fetchItem2(request: SceneModel.FetchItem.Request)
  func fetchItem3(request: SceneModel.FetchItem.Request)
  func updateItem(request: SceneModel.UpdateItem.Request)
}

protocol SceneDataStore: class {
  
  var tapCount: Int { get set }
  var item: Item? { get set }
}

final class SceneInteractor: SceneDataStore {
  
  // MARK: - Presenter
  var presenter: ScenePresenterLogic?
  
  // MARK: - Workers
  var worker: SceneWorker?
  
  // MARK: - Data
  var tapCount: Int = 0
  var item: Item?
}

extension SceneInteractor: SceneInteractorLogic {
  
  func increaseTapCount(request: SceneModel.Title.Request) {
    self.tapCount += 1
    let response = SceneModel.Title.Response(count: self.tapCount)
    presenter?.presentIncreaseCount(response: response)
  }
  
  // fetchItem I
  // 외부에서 다른 Interactor 를 호출할 수 있는 기회를 주기 위해 Gurantee를 넘겨줌
  func fetchItem(request: SceneModel.FetchItem.Request) -> Guarantee<SceneModel.FetchItem.Response> {
    let (promise, seal) = Guarantee<SceneModel.FetchItem.Response>.pending()
    
    worker?.fetchItem(id: request.id)
      .done({ [weak self] item in
        guard let self = self else { return }
        self.item = item
        let response = SceneModel.FetchItem.Response(item: item, error: nil)
        self.presenter?.presentFetchItem(response: response)
        seal(response)
      })
      .catch({ error in
        let response = SceneModel.FetchItem.Response(item: nil, error: error)
        seal(response)
      })
    
    return promise
  }
  
  // fetchItem II
  // 필요에 따라 내부에서 다른 인터렉터 로직을 호출
  func fetchItem2(request: SceneModel.FetchItem.Request) {
    
    worker?.fetchItem(id: request.id)
      .done(on: .main, { [weak self] item in
        guard let self = self else { return }
        self.item = item
        let response = SceneModel.FetchItem.Response(item: item, error: nil)
        self.presenter?.presentFetchItem(response: response)
        self.updateItem(request: SceneModel.UpdateItem.Request())
      })
      .catch(on: .main, { [weak self] error in
        guard let self = self else { return }
        let response = SceneModel.FetchItem.Response(item: nil, error: error)
        self.presenter?.presentFetchItem(response: response)
      })
  }
  
  // fetchItem III
  // I, II 과 다르게 최대한 worker만 사용하는 방향으로
  func fetchItem3(request: SceneModel.FetchItem.Request) {
    guard let worker = self.worker else { return }
    
    let fetchWorkflow = worker.fetchItem(id: request.id)
    
    fetchWorkflow
      .done(on: .main, { [weak self] item in
        guard let self = self else { return }
        self.item = item
        self.presenter?.presentFetchItem(
          response: SceneModel.FetchItem.Response(item: item, error: nil)
        )
      })
      .catch({ [weak self] error in
        guard let self = self else { return }
        self.presenter?.presentFetchItem(
          response: SceneModel.FetchItem.Response(item: nil, error: error)
        )
      })
    
    let updataWorkflow = fetchWorkflow.then(on: .global(), { item -> Promise<Item> in
      return worker.updateItem(item: item)
    })
    
    updataWorkflow
      .done(on: .main, { [weak self] item in
        guard let self = self else { return }
        self.item = item
        self.presenter?.presentUpdateItem(
          response: SceneModel.UpdateItem.Response(item: item, error: nil)
        )
      })
      .catch(on: .main, { [weak self] error in
        guard let self = self else { return }
        self.presenter?.presentUpdateItem(
          response: SceneModel.UpdateItem.Response(item: nil, error: error)
        )
      })
  }
  
  func updateItem(request: SceneModel.UpdateItem.Request) {
    guard let item = self.item else { return }
    
    worker?.updateItem(item: item)
      .done(on: .main, { [weak self] item in
        guard let self = self else { return }
        self.item = item
        self.presenter?.presentUpdateItem(
          response: SceneModel.UpdateItem.Response(item: item, error: nil)
        )
      })
      .cauterize()
  }
}
