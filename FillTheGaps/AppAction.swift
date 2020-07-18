import Foundation

enum AppAction: Equatable {
    case viewDidLoad
    case currentUserResponse(String)
    case authenticatedWithGoogleResponse(String)
    case listOfCalendarsResponse([String])
    case tapOnLogout
    case logoutResponse(Bool)
    case tapOnCalendar(calendarId: String)
    case dismissSheetInContentView
    case event(EventAction)
}
