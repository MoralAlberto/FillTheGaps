import Foundation
import ComposableArchitecture

struct CalendarFeatureState: Equatable {
    var user: String
    var events: [Event]
    var calendars: [Calendar]
    var currentCalendar: String
    var presentSheetInCalendarView: Bool
    var calendarViewSheet: CalendarViewSheet
}

enum CalendarAction: Equatable {
    case getCalendars
    case responseListOfCalendars([Calendar])
    case selectedCalendar(calendarId: String)
    case dismissSheetInCalendarView
}

struct CalendarEnvironment {
    var getCalendars: () -> Effect<[Calendar], Never>
}

let calendarReducer = Reducer<CalendarFeatureState, CalendarAction, CalendarEnvironment> { state, action, environment in
    switch action {
    case .getCalendars:
        return environment.getCalendars()
            .map(CalendarAction.responseListOfCalendars)
            .receive(on: DispatchQueue.main)
            .eraseToEffect()
                
    case .responseListOfCalendars(let calendars):
        state.calendars = calendars
        
    case .selectedCalendar(calendarId: let calendarId):
        state.currentCalendar = calendarId
        state.presentSheetInCalendarView = true
        
    case .dismissSheetInCalendarView:
        state.events = []
        state.presentSheetInCalendarView = false
        state.currentCalendar = ""
    }
    
    return .none
}

