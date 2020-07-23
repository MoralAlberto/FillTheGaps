import Foundation
import GoogleAPIClientForREST

extension CalendarModel {
    init(googleCalendar: GTLRCalendar_CalendarListEntry) {
        self.id = googleCalendar.identifier ?? ""
        self.summary = googleCalendar.summary ?? ""
    }
}
