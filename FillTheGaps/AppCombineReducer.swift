import Foundation
import ComposableArchitecture

struct AppCombineEnvironment {
    var getCurrentUser: () -> Effect<String, Never>
    var getCalendars: () -> Effect<[String], Never>
    var getCalendarEvents: (_ calendarId: String) -> Effect<[Event], Never>
    var createEvent: (String) -> Effect<Bool, Never>
    var removeEvent:  (String, String) -> Effect<Bool, Never>
    var logout: () -> Effect<Bool, Never>
}

let appCombineReducer = Reducer<AppState, AppAction, AppCombineEnvironment>
    .combine(
        appReducer.pullback(
            state: \AppState.self,
            action: /AppAction.self,
            environment: { _ in AppEnvironment(
                getCurrentUser: getCurrentUserEffect,
                getCalendars: getCalendarsEffect,
                logout: logoutEffect) }
        ),
        
        eventReducer.pullback(
            state: \AppState.event,
            action: /AppAction.event,
            environment: { _ in EventEnvironment(
                getCalendarEvents: getCalendarEventsEffect,
                createEvent: createEventEffect,
                removeEvent: removeEventEffect) }
        )
)
