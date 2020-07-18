import ComposableArchitecture
import Foundation

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
        
    case .tapOnLogout:
        return environment.logout()
            .map(AppAction.logoutResponse)
            .receive(on: DispatchQueue.main)
            .eraseToEffect()
        
    case .logoutResponse(let result):
        if result {
            state.user = ""
        }
        
    case .tapOnCalendar(calendarId: let calendarId):
        state.currentCalendar = calendarId
        state.presentSheetInContentView = true
        
    case .dismissSheetInContentView:
        state.presentSheetInContentView = false
        state.events = []
        state.currentCalendar = ""
    
        // TODO: Remove this event case
    case .event(_):
        return .none
    }
    
    return .none
}
