import Foundation
import SwiftUI
import ComposableArchitecture

struct ListOfEventsView: View {
    struct ViewState: Equatable {
        let currentCalendar: String
        let events: [Event]
        let dateOfNewEvent: Date
        let numberOfHoursNewEvent: Int
    }
    
    enum Action {
        case onViewDidLoad(calendarId: String)
        case tapOnCreateEventInCalendar(calendarId: String)
        case tapOnRemoveEvent(eventId: String, calendarId: String)
        case dateOfNewEventChanged(Date)
        case numberOfHoursChanged(Int)
        
    }
    
    private let calendarId: String
    @ObservedObject var viewStore: ViewStore<ViewState, Action>
    
    init(store: Store<EventFeatureState, EventAction>, calendarId: String) {
        self.viewStore = ViewStore(store.scope(state: { $0.view }, action: EventAction.view))
        self.calendarId = calendarId
    }
    
    var body: some View {
        VStack {
            Text("List of Events")
                .font(.system(size: 18, weight: .bold))
                .underline()
                .padding()
            List(viewStore.events, id: \.self) { event in
                HStack {
                    Text(event.name)
                    Spacer()
                    Button("Remove") {
                        viewStore.send(.tapOnRemoveEvent(eventId: event.id, calendarId: calendarId))
                    }
                }
            }
            
            Form {
                DatePicker("Choose date",
                           selection: viewStore.binding(get: \.dateOfNewEvent,
                                                        send: Action.dateOfNewEventChanged))
                Stepper("Number of Hours \(viewStore.numberOfHoursNewEvent)",
                        value: viewStore.binding(get: \.numberOfHoursNewEvent,
                                                 send: Action.numberOfHoursChanged),
                        in: 1...8)
                HStack {
                    Spacer()
                    Button("Create Event") {
                        viewStore.send(.tapOnCreateEventInCalendar(calendarId: calendarId))
                    }
                    Spacer()
                }.padding()
            }
            
            Spacer()
            .onAppear {
                viewStore.send(.onViewDidLoad(calendarId: calendarId))
            }
        }
    }
}

// MARK: Extension to init State and Action

extension EventFeatureState {
    var view: ListOfEventsView.ViewState {
        .init(currentCalendar: currentCalendar,
              events: events,
              dateOfNewEvent: dateOfNewEvent,
              numberOfHoursNewEvent: numberOfHoursNewEvent)
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
        case .dateOfNewEventChanged(let date):
            return .dateOfNewEventChanged(date: date)
        case .numberOfHoursChanged(let numberOfHours):
            return .numberOfHoursChanged(numberOfHours: numberOfHours)
        }
    }
}
