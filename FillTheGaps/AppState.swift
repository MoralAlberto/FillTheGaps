import Foundation
import ComposableArchitecture

struct AppState: Equatable {
    var user: String = ""
    var currentCalendar = ""
    var calendars: [String] = []
    var events: [Event] = []
    var presentSheetInCalendarView: Bool = false
    var calendarViewSheet: CalendarViewSheet = .listOfEvents
}

extension AppState {
    var event: EventFeatureState {
        get {
            EventFeatureState(currentCalendar: self.currentCalendar,
                              events: self.events)
        }
        
        set {
            self.currentCalendar = newValue.currentCalendar
            self.events = newValue.events
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
