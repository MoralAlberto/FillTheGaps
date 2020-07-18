import Foundation
import SwiftUI
import ComposableArchitecture


struct ListOfEventsView: View {
    struct ViewState {
        let currentCalendar: String
        let events: [Event]
    }
    
//    enum Action {
//        case onViewDidLoad(currentCalendar: String)
//        case tapOnCreateEventInCalendar(calendarId: String)
//        case tapOnRemoveEvent(eventId: String, calendarId: String)
//    }
    
    let store: Store<EventFeatureState, EventAction>
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
                    viewStore.send(.loadEventsInCalendar(calendarId: calendarId))
                }
            }
        }
    }
}

// MARK: Extension to init State and Action

extension EventFeatureState {
    var view: ListOfEventsView.ViewState {
        .init(currentCalendar: currentCalendar,
              events: events)
    }
}

extension EventAction {
    static func view(_ localAction: ListOfEventsView.Action) -> Self {
        switch localAction {
        case .onViewDidLoad(currentCalendar: let currentCalendar):
            return .loadEventsInCalendar(calendarId: currentCalendar)
        case .tapOnCreateEventInCalendar(calendarId: let calendarId):
            return .createEventInCalendar(calendarId: calendarId)
        case .tapOnRemoveEvent(eventId: let eventId, calendarId: let calendarId):
            return .tapOnRemoveEvent(eventId: eventId, calendarId: calendarId)
        }
    }
}
