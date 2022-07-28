import Foundation

struct TodoItem: Encodable, Decodable {
    let title: String
    let description: String
    let importance: String
    var isCompleted = false
}
