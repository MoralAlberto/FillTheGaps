import SwiftUI
import ComposableArchitecture

struct ContentView: View {
    let store: Store<AppState, AppAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            Group {
                if viewStore.user.isEmpty {
                    GoogleAuthenticationControllerWrapper(store: store)
                } else {
                    NavigationView {
                        List(viewStore.calendars, id: \.self) { calendar in
                            NavigationLink(destination: ListOfEvents(store: store, calendarId: calendar)) {
                                Text(calendar)
                            }
                        }.navigationBarTitle("Calendars")
                    }
                }
            }.onAppear {
                viewStore.send(.viewDidLoad)
            }
        }
    }
}
