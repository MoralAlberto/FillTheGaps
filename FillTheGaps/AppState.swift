import Foundation
import ComposableArchitecture

struct AppState: Equatable {
    var user: String = ""
    var currentCalendar = ""
    var calendars: [String] = []
    var events: [Event] = []
    var presentSheetInContentView: Bool = false
    var contentViewSheet: ContentViewSheet = .listOfEvents
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
