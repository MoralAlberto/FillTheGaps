import Foundation

struct EventModel: Equatable, Hashable, Identifiable {
    let id: String
    let name: String
    let start: Date
    let end: String
    
    var startDateFormatted: String {
        let template = "MMMMd"
        let dateFormat = DateFormatter.dateFormat(fromTemplate: template, options: 0, locale: nil)
        let df = DateFormatter()
        df.dateFormat = dateFormat
        return df.string(from: start)
    }
}
