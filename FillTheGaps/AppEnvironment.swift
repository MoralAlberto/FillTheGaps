import Foundation
import ComposableArchitecture

struct AppEnvironment {
    var getCurrentUser: () -> Effect<String, Never>
    var getCalendars: () -> Effect<[String], Never>
//    var getCalendarEvents: (_ calendarId: String) -> Effect<[Event], Never>
//    var createEvent: (String) -> Effect<Bool, Never>
//    var removeEvent:  (String, String) -> Effect<Bool, Never>
    var logout: () -> Effect<Bool, Never>
}
