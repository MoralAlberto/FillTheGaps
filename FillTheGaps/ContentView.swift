import SwiftUI
import ComposableArchitecture

enum ContentViewSheet {
    case listOfEvents
}

struct ContentView: View {
    let store: Store<AppState, AppAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            Group {
                if viewStore.user.isEmpty {
                    GoogleAuthenticationControllerWrapper(store: store)
                } else {
                    List {
                        ForEach(viewStore.calendars, id: \.self) { calendar in
                            Text(calendar).onTapGesture {
                                viewStore.send(.tapOnCalendar(calendarId: calendar))
                            }
                        }
                    }
                }
            }.onAppear {
                viewStore.send(.viewDidLoad)
            }.sheet(isPresented: .constant(viewStore.presentSheetInContentView),
                    onDismiss: {
                //self.inAppPurchaseViewShowSheet = false
                        print("Dismiss")
                        viewStore.send(.dismissSheetInContentView)
            }) {
                if viewStore.contentViewSheet == .listOfEvents {
                    ListOfEventsView(
                        store: store.scope(
                            state: \.event,
                            action: AppAction.event),
                        calendarId: viewStore.currentCalendar
                    )
                } else {
                    Text("Hello")
                }
        }
        }
    }
}
