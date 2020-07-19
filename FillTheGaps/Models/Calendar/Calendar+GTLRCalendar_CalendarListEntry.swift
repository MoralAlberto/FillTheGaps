import Foundation
import GoogleAPIClientForREST

extension Calendar {
    init(googleCalendar: GTLRCalendar_CalendarListEntry) {
        self.id = googleCalendar.identifier ?? ""
        self.summary = googleCalendar.summary ?? ""
    }
}
