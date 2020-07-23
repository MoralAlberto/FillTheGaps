import Foundation
import ComposableArchitecture

/* App State */

struct AppState: Equatable {
    var user: String = ""
    var currentCalendar = ""
    var calendars: [CalendarModel] = []
    var events: [CustomEventCalendar] = []
    var presentSheetInCalendarView: Bool = false
    var calendarViewSheet: CalendarViewSheet = .listOfEvents
    var dateOfNewEvent: Date = Date()
    var numberOfHoursNewEvent: Int = 4
}

extension AppState {
    var session: SessionFeatureState {
        get {
            .init(user: self.user)
        }
        
        set {
            self.user = newValue.user
        }
    }
}

extension AppState {
    var event: EventFeatureState {
        get {
            .init(currentCalendar: self.currentCalendar,
                  events: self.events,
                  dateOfNewEvent: self.dateOfNewEvent,
                  numberOfHoursNewEvent: self.numberOfHoursNewEvent)
        }
        
        set {
            self.currentCalendar = newValue.currentCalendar
            self.events = newValue.events
            self.dateOfNewEvent = newValue.dateOfNewEvent
            self.numberOfHoursNewEvent = newValue.numberOfHoursNewEvent
        }
    }
}

extension AppState {
    var calendar: CalendarFeatureState {
        get {
            .init(user: self.user,
                  events: self.events,
                  calendars: self.calendars,
                  currentCalendar: self.currentCalendar,
                  presentSheetInCalendarView: self.presentSheetInCalendarView,
                  calendarViewSheet: self.calendarViewSheet)
        }
        
        set {
            self.user = newValue.user
            self.events = newValue.events
            self.calendars = newValue.calendars
            self.currentCalendar = newValue.currentCalendar
            self.presentSheetInCalendarView = newValue.presentSheetInCalendarView
            self.calendarViewSheet = newValue.calendarViewSheet
        }
    }
}

/* App Action */

enum AppAction {
    case session(SessionAction)
    case calendar(CalendarAction)
    case event(EventAction)
}

struct AppEnvironment {
    var getCurrentUser: () -> Effect<String, Never>
    var getCalendars: () -> Effect<[CalendarModel], Never>
    var getCalendarEvents: (_ calendarId: String) -> Effect<[Event], Never>
    var createEvent: (String, Date, Int) -> Effect<Bool, Never>
    var removeEvent:  (String, String) -> Effect<Bool, Never>
    var logout: () -> Effect<Bool, Never>
}

/* App Environment */

extension AppEnvironment {
    func toSessionEnvironment() -> SessionEnvironment {
        SessionEnvironment(getCurrentUser: getCurrentUserEffect)
    }
    
    func toEventEnvironment() -> EventEnvironment {
        EventEnvironment(getCalendarEvents: getCalendarEventsEffect, createEvent: createEventEffect, removeEvent: removeEventEffect)
    }
    
    func toCalendarEnvironment() -> CalendarEnvironment {
        CalendarEnvironment(getCalendars: getCalendarsEffect)
    }
}

/* App Reducer combined with: Session, Reducer and Event */

let appCombineReducer = Reducer<AppState, AppAction, AppEnvironment>
    .combine(
        sessionReducer.pullback(
            state: \AppState.session,
            action: /AppAction.session,
            environment: { $0.toSessionEnvironment() }
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
