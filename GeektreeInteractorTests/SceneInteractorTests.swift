import XCTest
import Nimble

import PromiseKit

@testable import GeektreeInteractor

class SceneInteractorTests: XCTestCase {
  
  var interactor: SceneInteractor!
  
  override func setUp() {
    super.setUp()
    self.interactor = SceneInteractor.init()
  }
  
  override func tearDown() {
    super.tearDown()
  }
  
}

// MARK: - Basic Interactor Test Case

extension SceneInteractorTests {
  
  func test_increaseTapCount() {
    // Given
    let presenter = Spy_ScenePresenter.init()
    self.interactor.presenter = presenter
    self.interactor.tapCount = 0
    
    // When: firstly tapping
    self.interactor.increaseTapCount(
      request: SceneModel.Title.Request.init()
    )
    
    // Then
    expect(presenter.presentIncreaseCountCalled) == 1
    expect(self.interactor.tapCount) == 1
    
    // When: secondly tapping
    self.interactor.increaseTapCount(
      request: SceneModel.Title.Request.init()
    )
    
    // Then
    expect(presenter.presentIncreaseCountCalled) == 2
    expect(self.interactor.tapCount) == 2
    
    // Given: tapCount begin at 100
    self.interactor.tapCount = 100
    
    // When: thirdly tapping
    self.interactor.increaseTapCount(
      request: SceneModel.Title.Request.init()
    )
    
    // Then
    expect(presenter.presentIncreaseCountCalled) == 3
    expect(self.interactor.tapCount) == 101
  }
}

// MARK: - 외부에서 다른 Interactor 를 호출할 수 있는 기회를 주기 위해 Gurantee를 넘겨줌

extension SceneInteractorTests {
  
  func test_successFetchItem() {
    // Given
    let presenter = Spy_ScenePresenter.init()
    let worker = Stub_Worker.init()
    
    worker.register(Promise<Item>.self, name: "fetchItem", provider: {
      return Promise<Item>.value(Item(id: 1))
    })
    
    interactor.presenter = presenter
    interactor.worker = worker
    
    // When
    _ = interactor.fetchItem(request: SceneModel.FetchItem.Request(id: 1))
    
    // Then
    expect(presenter.presentFetchItemCalled).toEventually(equal(1), timeout: 1.0)
    expect(worker.fetchItemCalled).toEventually(equal(1), timeout: 1.0)
  }
  
  func test_failedFetchItem() {
    // Given
    let presenter = Spy_ScenePresenter.init()
    let worker = Stub_Worker.init()
    
    worker.register(Promise<Item>.self, name: "fetchItem", provider: {
      return Promise<Item>.init(error: NSError.init(domain: "test error", code: -1, userInfo: nil))
    })
    
    interactor.presenter = presenter
    interactor.worker = worker
    
    // When
    _ = interactor.fetchItem(request: SceneModel.FetchItem.Request(id: 1))
    
    // Then
    expect(presenter.presentFetchItemCalled).toEventually(equal(0), timeout: 1.0)
    expect(worker.fetchItemCalled).toEventually(equal(1), timeout: 1.0)
  }
}

// MARK: - 필요에 따라 내부에서 다른 인터렉터 로직을 호출

extension SceneInteractorTests {
  
  func test_successFetchItem2() {
    // Given
    let presenter = Spy_ScenePresenter.init()
    let worker = Stub_Worker.init()
    
    worker.register(Promise<Item>.self, name: "fetchItem", provider: {
      return Promise<Item>.value(Item(id: 1))
    })
    
    worker.register(Promise<Item>.self, name: "updateItem", provider: {
      return Promise<Item>.value(Item(id: 1))
    })
    
    interactor.presenter = presenter
    interactor.worker = worker
    
    // When
    interactor.fetchItem2(request: SceneModel.FetchItem.Request(id: 1))
    
    // Then
    expect(presenter.presentFetchItemCalled).toEventually(equal(1), timeout: 1.0)
    expect(presenter.presentUpdateItemCalled).toEventually(equal(1), timeout: 1.0)
    expect(worker.fetchItemCalled).toEventually(equal(1), timeout: 1.0)
    expect(worker.updateItemCalled).toEventually(equal(1), timeout: 1.0)
  }
  
  func test_failedFetchItem2() {
    // Given
    let presenter = Spy_ScenePresenter.init()
    let worker = Stub_Worker.init()
    
    worker.register(Promise<Item>.self, name: "fetchItem", provider: {
      return Promise<Item>.init(error: NSError.init(domain: "test error", code: -1, userInfo: nil))
    })
    
    worker.register(Promise<Item>.self, name: "updateItem", provider: {
      return Promise<Item>.value(Item(id: 1))
    })
    
    interactor.presenter = presenter
    interactor.worker = worker
    
    // When
    interactor.fetchItem2(request: SceneModel.FetchItem.Request(id: 1))
    
    // Then
    expect(presenter.presentFetchItemCalled).toEventually(equal(1), timeout: 1.0)
    expect(presenter.presentUpdateItemCalled).toEventually(equal(0), timeout: 1.0)
    expect(worker.fetchItemCalled).toEventually(equal(1), timeout: 1.0)
    expect(worker.updateItemCalled).toEventually(equal(0), timeout: 1.0)
  }
}

// MARK: - I, II 과 다르게 최대한 worker만 사용하는 방향으로

extension SceneInteractorTests {
  
  func test_successFetchItem3() {
    // Given
    let presenter = Spy_ScenePresenter.init()
    let worker = Stub_Worker.init()
    
    worker.register(Promise<Item>.self, name: "fetchItem", provider: {
      return Promise<Item>.value(Item(id: 1))
    })
    
    worker.register(Promise<Item>.self, name: "updateItem", provider: {
      return Promise<Item>.value(Item(id: 1))
    })
    
    interactor.presenter = presenter
    interactor.worker = worker
    
    // When
    interactor.fetchItem2(request: SceneModel.FetchItem.Request(id: 1))
    
    // Then
    expect(presenter.presentFetchItemCalled).toEventually(equal(1), timeout: 1.0)
    expect(presenter.presentUpdateItemCalled).toEventually(equal(1), timeout: 1.0)
    expect(worker.fetchItemCalled).toEventually(equal(1), timeout: 1.0)
    expect(worker.updateItemCalled).toEventually(equal(1), timeout: 1.0)
  }
  
  
  func test_successFetchItem3ButUpdateFailed() {
    // Given
    let presenter = Spy_ScenePresenter.init()
    let worker = Stub_Worker.init()
    
    worker.register(Promise<Item>.self, name: "fetchItem", provider: {
      return Promise<Item>.value(Item(id: 1))
    })
    
    worker.register(Promise<Item>.self, name: "updateItem", provider: {
      return Promise<Item>.init(error: NSError.init(domain: "test error", code: -1, userInfo: nil))
    })
    
    interactor.presenter = presenter
    interactor.worker = worker
    
    // When
    interactor.fetchItem2(request: SceneModel.FetchItem.Request(id: 1))
    
    // Then
    expect(presenter.presentFetchItemCalled).toEventually(equal(1), timeout: 1.0)
    expect(presenter.presentUpdateItemCalled).toEventually(equal(0), timeout: 1.0)
    expect(worker.fetchItemCalled).toEventually(equal(1), timeout: 1.0)
    expect(worker.updateItemCalled).toEventually(equal(1), timeout: 1.0)
  }
  
  func test_failedFetchItem3() {
    // Given
    let presenter = Spy_ScenePresenter.init()
    let worker = Stub_Worker.init()
    
    worker.register(Promise<Item>.self, name: "fetchItem", provider: {
      return Promise<Item>.init(error: NSError.init(domain: "test error", code: -1, userInfo: nil))
    })
    
    interactor.presenter = presenter
    interactor.worker = worker
    
    // When
    interactor.fetchItem2(request: SceneModel.FetchItem.Request(id: 1))
    
    // Then
    expect(presenter.presentFetchItemCalled).toEventually(equal(1), timeout: 1.0)
    expect(presenter.presentUpdateItemCalled).toEventually(equal(0), timeout: 1.0)
    expect(worker.fetchItemCalled).toEventually(equal(1), timeout: 1.0)
    expect(worker.updateItemCalled).toEventually(equal(0), timeout: 1.0)
  }
}

// MARK: - Test Double Object

extension SceneInteractorTests {
  
  class Spy_ScenePresenter: ScenePresenterLogic {
    
    var presentIncreaseCountCalled: Int = 0
    var presentFetchItemCalled: Int = 0
    var presentUpdateItemCalled: Int = 0
    
    func presentIncreaseCount(response: SceneModel.Title.Response) {
      self.presentIncreaseCountCalled += 1
    }
    
    func presentFetchItem(response: SceneModel.FetchItem.Response) {
      self.presentFetchItemCalled += 1
    }
    
    func presentUpdateItem(response: SceneModel.UpdateItem.Response) {
      self.presentUpdateItemCalled += 1
    }
  }
  
  class Stub_Worker: SceneWorker & Injectable {
    
    var fetchItemCalled: Int = 0
    var updateItemCalled: Int = 0

    override func fetchItem(id: Int) -> Promise<Item> {
      fetchItemCalled += 1
      return resolve(Promise<Item>.self, name: "fetchItem")!
    }
    
    override func updateItem(item: Item) -> Promise<Item> {
      updateItemCalled += 1
      return resolve(Promise<Item>.self, name: "updateItem")!
    }
    
  }
}
