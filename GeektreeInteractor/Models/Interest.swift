import Codextended

struct Interest: Codable {
  
  var id: Int
  var title: String?
  
  init(id: Int) {
    self.id = id
  }
  
  init(from decoder: Decoder) throws {
    self.id = try! decoder.decode("id")
    self.title = try? decoder.decode("title")
  }
}
