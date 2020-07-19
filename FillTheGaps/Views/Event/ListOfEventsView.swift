import Foundation
import SwiftUI
import ComposableArchitecture

struct ListOfEventsView: View {
    struct ViewState: Equatable {
        let currentCalendar: String
        let events: [Event]
    }
    
    enum Action {
        case onViewDidLoad(calendarId: String)
        case tapOnCreateEventInCalendar(calendarId: String)
        case tapOnRemoveEvent(eventId: String, calendarId: String)
    }
    
    private let calendarId: String
    @ObservedObject var viewStore: ViewStore<ViewState, Action>
    
    init(store: Store<EventFeatureState, EventAction>, calendarId: String) {
        self.viewStore = ViewStore(store.scope(state: { $0.view }, action: EventAction.view))
        self.calendarId = calendarId
    }
    
    var body: some View {
        VStack {
            Button("Create random Event") {
                viewStore.send(.tapOnCreateEventInCalendar(calendarId: calendarId))
            }.padding()
            List(viewStore.events, id: \.self) { event in
                HStack {
                    Text(event.name)
                    Spacer()
                    Button("Remove") {
                        viewStore.send(.tapOnRemoveEvent(eventId: event.id, calendarId: calendarId))
                    }
                }
            }.onAppear {
                viewStore.send(.onViewDidLoad(calendarId: calendarId))
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
        case .onViewDidLoad(calendarId: let calendarId):
            return .loadEventsInCalendar(calendarId: calendarId)
        case .tapOnCreateEventInCalendar(calendarId: let calendarId):
            return .createEventInCalendar(calendarId: calendarId)
        case .tapOnRemoveEvent(eventId: let eventId, calendarId: let calendarId):
            return .tapOnRemoveEvent(eventId: eventId, calendarId: calendarId)
        }
    }
}
