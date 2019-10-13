import XCTest
import Nimble
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

// MARK: - Test Double Object

extension SceneInteractorTests {
  
  class Spy_ScenePresenter: ScenePresenterLogic {
    
    var presentIncreaseCountCalled: Int = 0
    
    func presentIncreaseCount(response: SceneModel.Title.Response) {
      self.presentIncreaseCountCalled += 1
    }
  }
  
}
