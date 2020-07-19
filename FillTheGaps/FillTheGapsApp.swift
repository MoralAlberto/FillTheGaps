import SwiftUI
import ComposableArchitecture

@main
struct FillTheGapsApp: App {
    var store = Store(
        initialState: AppState(),
        reducer: appCombineReducer,
        environment: AppEnvironment(
            getCurrentUser: getCurrentUserEffect,
            getCalendars: getCalendarsEffect,
            getCalendarEvents: getCalendarEventsEffect,
            createEvent: createEventEffect,
            removeEvent: removeEventEffect,
            logout: logoutEffect)
    )
    
    var body: some Scene {
        WindowGroup {
            ListOfCalendarsView(store: store)
                .onAppear {
                    let sessionStore = store.scope(
                        state: \.session,
                        action: AppAction.session)
                    
                    ViewStore(sessionStore).send(.viewDidLoad)
                }
        }
    }
}
