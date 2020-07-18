import SwiftUI
import ComposableArchitecture

@main
struct FillTheGapsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(
                store: Store(
                    initialState: AppState(),
                    reducer: appReducer,
                    environment: AppEnvironment(
                        getCurrentUser: getCurrentUserEffect,
                        getCalendars: getCalendarsEffect,
                        getCalendarEvents: getCalendarEventsEffect,
                        createEvent: createEventEffect,
                        removeEvent: removeEventEffect(inCalendarId:eventId:),
                        logout: logoutEffect)
                )
            )
        }
    }
}
