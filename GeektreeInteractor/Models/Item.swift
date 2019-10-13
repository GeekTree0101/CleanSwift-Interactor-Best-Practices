import Codextended

struct Item: Codable {
  
  var id: Int
  var title: String?
  
  init(from decoder: Decoder) throws {
    self.id = try! decoder.decode("id")
    self.title = try? decoder.decode("title")
  }
}
