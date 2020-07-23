import ComposableArchitecture
import Foundation

struct EventFeatureState: Equatable {
    var currentCalendar: String
    var events: [CustomEventCalendar]
    var dateOfNewEvent: Date
    var numberOfHoursNewEvent: Int = 4
}

enum EventAction: Equatable {
    case loadEventsInCalendar(calendarId: String)
    case responseEventsInCalendar([Event])
    case createEventInCalendar(calendarId: String)
    case responseAddEvent(Bool)
    case tapOnRemoveEvent(eventId: String, calendarId: String)
    case responseRemoveEvent(Bool)
    case dateOfNewEventChanged(date: Date)
    case numberOfHoursChanged(numberOfHours: Int)
}

struct EventEnvironment {
    var getCalendarEvents: (_ calendarId: String) -> Effect<[Event], Never>
    var createEvent: (String, Date, Int) -> Effect<Bool, Never>
    var removeEvent: (String, String) -> Effect<Bool, Never>
}

struct CustomEventCalendar: Equatable, Hashable, Identifiable {
    var id: String
    var events: [Event]
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
        
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: result, by: { calendar.startOfDay(for: $0.start) })
        let value = grouped.sorted { $0.key > $1.key }.reversed()
        
        let formattedEvents = value.map { date -> CustomEventCalendar in
            let formattedDays = ["", "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
            let day = Calendar.current.component(.weekday, from: date.key)
            let arrayOfEvents = date.value.map { $0 }
            return CustomEventCalendar(id: formattedDays[day], events: arrayOfEvents)
        }
        
        state.events = formattedEvents
        
        print("Formatted Events \(formattedEvents)")
        
    case .createEventInCalendar(calendarId: let calendarId):
        
        return environment.createEvent(calendarId, state.dateOfNewEvent, state.numberOfHoursNewEvent)
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
        
    case .dateOfNewEventChanged(date: let date):
        print("New Date \(date)")
        state.dateOfNewEvent = date
        
    case .numberOfHoursChanged(numberOfHours: let numberOfHours):
        print("Number \(numberOfHours)")
        state.numberOfHoursNewEvent = numberOfHours
    
    }
    return .none
}
