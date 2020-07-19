import Foundation

struct Event: Equatable, Hashable, Identifiable {
    let id: String
    let name: String
    let start: String
    let end: String
}
