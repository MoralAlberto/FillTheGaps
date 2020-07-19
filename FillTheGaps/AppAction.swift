import Foundation

enum AppAction: Equatable {
    case viewDidLoad
    case currentUserResponse(String)
    case authenticatedWithGoogleResponse(String)
    case tapOnLogout
    case logoutResponse(Bool)
    case calendar(CalendarAction)
    case event(EventAction)
}
