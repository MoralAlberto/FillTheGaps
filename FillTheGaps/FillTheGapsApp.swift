import SwiftUI
import ComposableArchitecture

@main
struct FillTheGapsApp: App {
    var body: some Scene {
        WindowGroup {
            ListOfCalendarsView(
                store: Store(
                    initialState: AppState(),
                    reducer: appCombineReducer,
                    environment: AppCombineEnvironment(
                        getCurrentUser: getCurrentUserEffect,
                        getCalendars: getCalendarsEffect,
                        getCalendarEvents: getCalendarEventsEffect,
                        createEvent: createEventEffect,
                        removeEvent: removeEventEffect,
                        logout: logoutEffect)
                )
            )
        }
    }
}
