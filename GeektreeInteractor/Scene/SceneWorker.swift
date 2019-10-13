import Foundation
import Codextended
import PromiseKit

class SceneWorker {
  
  func fetchItem(id: Int) -> Promise<Item> {
    let fakeJson = #"{"id": \#(id), "title": "hello world"}"#.utf8
    let item = try! Data(fakeJson).decoded() as Item
    return Promise.value(item)
  }
  
  func updateItem(item: Item) -> Promise<Item> {
    return Promise.value(item)
  }
}
