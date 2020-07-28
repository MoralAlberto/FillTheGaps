import Foundation
import GoogleAPIClientForREST

extension EventModel {
    init(googleEvent: GTLRCalendar_Event) {
        self.id = googleEvent.identifier ?? ""
        self.name = googleEvent.summary ?? "No Name"
        self.start = googleEvent.start?.dateTime?.date ?? Date()
        self.end = "\(String(describing: googleEvent.end?.dateTime?.date))"
    }
}
