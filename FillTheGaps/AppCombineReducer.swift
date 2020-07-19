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

extension AppCombineEnvironment {
    func toAppEnvironment() -> AppEnvironment {
        AppEnvironment(getCurrentUser: getCurrentUserEffect, getCalendars: getCalendarsEffect, logout: logoutEffect)
    }
    
    func toEventEnvironment() -> EventEnvironment {
        EventEnvironment(getCalendarEvents: getCalendarEventsEffect, createEvent: createEventEffect, removeEvent: removeEventEffect)
    }
    
    func toCalendarEnvironment() -> CalendarEnvironment {
        CalendarEnvironment(getCalendars: getCalendarsEffect)
    }
}

let appCombineReducer = Reducer<AppState, AppAction, AppCombineEnvironment>
    .combine(
        appReducer.pullback(
            state: \AppState.self,
            action: /AppAction.self,
            environment: { $0.toAppEnvironment() }
        ),
        
        calendarReducer.pullback(
            state: \AppState.calendar,
            action: /AppAction.calendar,
            environment: { $0.toCalendarEnvironment() })
        ,
        eventReducer.pullback(
            state: \AppState.event,
            action: /AppAction.event,
            environment: { $0.toEventEnvironment() }
        )
)
