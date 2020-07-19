import ComposableArchitecture

struct EventFeatureState: Equatable {
    var currentCalendar: String
    var events: [Event]
}

enum EventAction: Equatable {
    case loadEventsInCalendar(calendarId: String)
    case responseEventsInCalendar([Event])
    case createEventInCalendar(calendarId: String)
    case responseAddEvent(Bool)
    case tapOnRemoveEvent(eventId: String, calendarId: String)
    case responseRemoveEvent(Bool)
}

struct EventEnvironment {
    var getCalendarEvents: (_ calendarId: String) -> Effect<[Event], Never>
    var createEvent: (String) -> Effect<Bool, Never>
    var removeEvent: (String, String) -> Effect<Bool, Never>
}

let eventReducer = Reducer<EventFeatureState, EventAction, EventEnvironment> { state, action, environment in
    func getCalendarEvents() -> Effect<EventAction, Never> {
        return environment.getCalendarEvents(state.currentCalendar)
                .map(EventAction.responseEventsInCalendar)
                .receive(on: DispatchQueue.main)
                .eraseToEffect()
    }
    
    switch action {
    case .loadEventsInCalendar(calendarId: let calendarId):
        return getCalendarEvents()
        
    case .responseEventsInCalendar(let result):
        state.events = result
        return .none
        
    case .createEventInCalendar(calendarId: let calendarId):
        
        return environment.createEvent(calendarId)
            .map(EventAction.responseAddEvent)
            .receive(on: DispatchQueue.main)
            .eraseToEffect()
    
    case .responseAddEvent(let result):
        return getCalendarEvents()
        
    case .tapOnRemoveEvent(eventId: let eventId, calendarId: let calendarId):
        return environment.removeEvent(calendarId, eventId)
            .map(EventAction.responseRemoveEvent)
            .receive(on: DispatchQueue.main)
            .eraseToEffect()
            
    case .responseRemoveEvent(let result):
        return getCalendarEvents()
    }
}
