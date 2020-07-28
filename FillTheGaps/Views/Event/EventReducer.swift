import ComposableArchitecture
import Foundation

struct EventFeatureState: Equatable {
    var currentCalendar: String
    var events: [CustomEventCalendar]
    var dateOfNewEvent: Date
    var numberOfHoursNewEvent: Int = 4
    var titleOfNewEvent: String
}

enum EventAction: Equatable {
    case loadEventsInCalendar(calendarId: String)
    case responseEventsInCalendar([EventModel])
    case createEventInCalendar(calendarId: String)
    case responseAddEvent(Bool)
    case tapOnRemoveEvent(eventId: String, calendarId: String)
    case responseRemoveEvent(Bool)
    case dateOfNewEventChanged(date: Date)
    case numberOfHoursChanged(numberOfHours: Int)
    case titleOfNewEventChanged(title: String)
}

struct EventEnvironment {
    var getCalendarEvents: (_ calendarId: String) -> Effect<[EventModel], Never>
    var createEvent: (String, String, Date, Int) -> Effect<Bool, Never>
    var removeEvent: (String, String) -> Effect<Bool, Never>
}

struct CustomEventCalendar: Equatable, Hashable, Identifiable {
    var id: String
    var events: [EventModel]
    var isToday: Bool = false
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
        state.events = formatAllEvents(events: result)
        
    case .createEventInCalendar(calendarId: let calendarId):
        return environment.createEvent(calendarId,
                                       state.titleOfNewEvent,
                                       state.dateOfNewEvent,
                                       state.numberOfHoursNewEvent)
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
        state.dateOfNewEvent = date
        
    case .numberOfHoursChanged(numberOfHours: let numberOfHours):
        state.numberOfHoursNewEvent = numberOfHours
    
    case .titleOfNewEventChanged(title: let title):
        state.titleOfNewEvent = title
    }
    
    return .none
}

func formatAllEvents(events: [EventModel]) -> [CustomEventCalendar] {
    let calendar = Calendar.current
            
    let groupedByDay = Dictionary(grouping: events, by: { calendar.startOfDay(for: $0.start) })
    let value = groupedByDay.sorted { $0.key > $1.key }.reversed()
    
    // Today
    let today = Date()
    let currentWeekday = calendar.component(.weekday, from: today)
    let currentDay = calendar.component(.day, from: today)
    
    return value.map { date -> CustomEventCalendar in
        let formattedDays = ["", "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        let weekday = calendar.component(.weekday, from: date.key)
        let day = calendar.component(.day, from: date.key)
        let arrayOfEvents = date.value.map { $0 }
        
        if currentWeekday == weekday, currentDay == day {
            return CustomEventCalendar(id: "\(day)\n\(formattedDays[weekday])",
                                       events: arrayOfEvents,
                                       isToday: true)
        }
        return CustomEventCalendar(id: "\(day)\n\(formattedDays[weekday])", events: arrayOfEvents)
    }
}
