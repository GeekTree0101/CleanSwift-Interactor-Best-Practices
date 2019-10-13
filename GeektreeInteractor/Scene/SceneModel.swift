import Foundation

enum SceneModel {
  
  enum Title {
    
    struct Request {
      
    }
    
    struct Response {
      
      var count: Int
    }
    
    struct ViewModel {
      
      var displayTitle: String
    }
  }
  
  enum FetchItem {
    
    struct Request {
      
      var id: Int
    }
    
    struct Response {
      
      var item: Item?
      var error: Error?
    }
    
    struct ViewModel {
      
    }
  }
  
  enum UpdateItem {
    
    struct Request {
      
    }
    
    struct Response {
      
      var item: Item?
      var error: Error?
    }
    
    struct ViewModel {
      
    }
  }
  
  enum TwoWay {
    
    struct Request {
      
      var cardID: Int
      var interestID: Int
    }
    
    struct Response {
      
      var card: Card?
      var interest: Interest?
      var error: Error?
    }
    
    struct ViewModel {
      
    }
  }
}
