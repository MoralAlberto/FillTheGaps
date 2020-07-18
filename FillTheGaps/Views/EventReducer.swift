import ComposableArchitecture

struct EventFeatureState: Equatable {
    var currentCalendar: String
    var events: [Event]
}

enum EventAction: Equatable {
    case loadEventsInCalendar(calendarId: String)
    case calendarEventsResponse([Event])
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
    switch action {
    
    case .loadEventsInCalendar(calendarId: let calendarId):
        return environment.getCalendarEvents(calendarId)
            .map(EventAction.calendarEventsResponse)
            .receive(on: DispatchQueue.main)
            .eraseToEffect()
        
    case .calendarEventsResponse(let result):
        state.events = result
        
        return .none
        
    case .createEventInCalendar(calendarId: let calendarId):
        
        return environment.createEvent(calendarId)
            .map(EventAction.responseAddEvent)
            .receive(on: DispatchQueue.main)
            .eraseToEffect()
    
    case .responseAddEvent(let result):
        if result {
            print("Success")
        } else {
            print("Error")
        }
        
        return environment.getCalendarEvents(state.currentCalendar)
            .map(EventAction.calendarEventsResponse)
            .receive(on: DispatchQueue.main)
            .eraseToEffect()
        
    case .tapOnRemoveEvent(eventId: let eventId, calendarId: let calendarId):
    
        return environment.removeEvent(calendarId, eventId)
            .map(EventAction.responseRemoveEvent)
            .receive(on: DispatchQueue.main)
            .eraseToEffect()
            
    case .responseRemoveEvent(let result):
        if result {
            print("Success")
        } else {
            print("Error")
        }
        
        return environment.getCalendarEvents(state.currentCalendar)
            .map(EventAction.calendarEventsResponse)
            .receive(on: DispatchQueue.main)
            .eraseToEffect()
    }
}
