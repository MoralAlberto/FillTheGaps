import Foundation
import GoogleAPIClientForREST

extension Event {
    init(googleEvent: GTLRCalendar_Event) {
        self.id = googleEvent.identifier ?? ""
        self.name = googleEvent.summary ?? "No Name"
        self.start = "\(String(describing: googleEvent.start?.dateTime?.date))"
        self.end = "\(String(describing: googleEvent.end?.dateTime?.date))"
    }
}
