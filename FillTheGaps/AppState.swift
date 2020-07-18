import Foundation
import ComposableArchitecture


struct AppState: Equatable {
    var user: String = ""
    var currentCalendar = ""
    var calendars: [String] = []
    var events: [Event] = []
}

enum AppAction: Equatable {
    case viewDidLoad
    case currentUserResponse(String)
    case authenticatedWithGoogleResponse(String)
    case listOfCalendarsResponse([String])
    case tapOnLogout
    case logoutResponse(Bool)
    case tapOnCalendar(calendarId: String)
    case calendarEventsResponse([Event])
    case createEventInCalendar(calendarId: String)
    case dismissCalendarEvents
    case createCalendarResponse(Bool)
    case tapOnRemoveEvent(eventId: String, calendarId: String)
    case responseRemoveEvent(Bool)
}

struct AppEnvironment {
    var getCurrentUser: () -> Effect<String, Never>
    var getCalendars: () -> Effect<[String], Never>
    var getCalendarEvents: (_ calendarId: String) -> Effect<[Event], Never>
    var createEvent: (String) -> Effect<Bool, Never>
    var removeEvent:  (String, String) -> Effect<Bool, Never>
    var logout: () -> Effect<Bool, Never>
}

let appReducer = Reducer<AppState, AppAction, AppEnvironment> { state, action, environment in
    switch action {
    case .viewDidLoad:
        return environment.getCurrentUser()
                .map(AppAction.currentUserResponse)
                .receive(on: DispatchQueue.main)
                .eraseToEffect()
        
    case .currentUserResponse(let currentUser):
        state.user = currentUser
        
        return environment.getCalendars()
            .map(AppAction.listOfCalendarsResponse)
            .receive(on: DispatchQueue.main)
            .eraseToEffect()
        
    case .authenticatedWithGoogleResponse(let currentUser):
        state.user = currentUser
        
        return environment.getCalendars()
            .map(AppAction.listOfCalendarsResponse)
            .receive(on: DispatchQueue.main)
            .eraseToEffect()
    
    case .listOfCalendarsResponse(let calendars):
        state.calendars = calendars
        
        return .none
        
    case .tapOnLogout:
        return environment.logout()
            .map(AppAction.logoutResponse)
            .receive(on: DispatchQueue.main)
            .eraseToEffect()
        
    case .logoutResponse(let result):
        if result {
            state.user = ""
        }
        
        return .none
        
    case .tapOnCalendar(calendarId: let calendarId):
        state.currentCalendar = calendarId
        
        return environment.getCalendarEvents(calendarId)
            .map(AppAction.calendarEventsResponse)
            .receive(on: DispatchQueue.main)
            .eraseToEffect()
        
    case .dismissCalendarEvents:
        state.events = []
        state.currentCalendar = ""
        
        return .none
        
    case .calendarEventsResponse(let result):
        print("Result \(result)")
        state.events = result
        
        return .none
        
    case .createEventInCalendar(calendarId: let calendarId):
        
        return environment.createEvent(calendarId)
            .map(AppAction.createCalendarResponse)
            .receive(on: DispatchQueue.main)
            .eraseToEffect()
    
    case .createCalendarResponse(let result):
        if result {
            print("Success")
        } else {
            print("Error")
        }
        
        return environment.getCalendarEvents(state.currentCalendar)
            .map(AppAction.calendarEventsResponse)
            .receive(on: DispatchQueue.main)
            .eraseToEffect()
        
    case .tapOnRemoveEvent(eventId: let eventId, calendarId: let calendarId):
    
        return environment.removeEvent(calendarId, eventId)
            .map(AppAction.responseRemoveEvent)
            .receive(on: DispatchQueue.main)
            .eraseToEffect()
            
    case .responseRemoveEvent(let result):
        if result {
            print("Success")
        } else {
            print("Error")
        }
        
        return environment.getCalendarEvents(state.currentCalendar)
            .map(AppAction.calendarEventsResponse)
            .receive(on: DispatchQueue.main)
            .eraseToEffect()
    }
}
