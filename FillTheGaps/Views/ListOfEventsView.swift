import Foundation
import SwiftUI
import ComposableArchitecture

struct ListOfEvents: View {
    let store: Store<AppState, AppAction>
    let calendarId: String
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack {
                Button("Create random Event") {
                    viewStore.send(.createEventInCalendar(calendarId: calendarId))
                }
                List(viewStore.events, id: \.self) { event in
                    HStack {
                        Text(event.name)
                        Spacer()
                        Button("Remove") {
                            viewStore.send(.tapOnRemoveEvent(eventId: event.id, calendarId: calendarId))
                        }
                    }
                }.onAppear {
                    viewStore.send(.tapOnCalendar(calendarId: calendarId))
                }.onDisappear {
                    viewStore.send(.dismissCalendarEvents)
                }
            }
        }
    }
}
