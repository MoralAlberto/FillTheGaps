import Foundation
import SwiftUI
import ComposableArchitecture

struct ListOfEventsView: View {
    struct ViewState: Equatable {
        let currentCalendar: String
        let events: [CustomEventCalendar]
        let dateOfNewEvent: Date
        let numberOfHoursNewEvent: Int
        
        func eventsBy(day: String) -> [EventModel] {
            events.filter { $0.id == day }
                  .flatMap { $0.events }
        }
        
        func allEvents() -> [EventModel] {
            events.flatMap { $0.events }
        }
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
        VStack(spacing: 0) {
            Text("List of Events")
                .font(.system(size: 18, weight: .bold))
                .underline()
                .padding()
            
            HStack {
                ForEach(viewStore.state.events, id:\.self) { value in
                    VStack {
                        if value.isToday {
                            Text(value.id)
                                .font(.system(size: 16, weight: .bold))
                                .underline()
                        } else {
                            Text(value.id)
                                .font(.system(size: 16, weight: .regular))
                        }
                        
                        List {
                            ForEach(viewStore.state.eventsBy(day: value.id)) { value in
                                Text(value.name)
                                    .font(.system(size: 8, weight: .regular, design: .default))
                                    .listRowBackground(Color.green)
                            }
                        }
                    }
                }
            }.padding(.bottom, 4)
            
            List(viewStore.state.allEvents(), id: \.self) { event in
                HStack {
                    HStack {
                        Text("\(event.startDateFormatted)")
                            .font(.system(size: 12, weight: .bold, design: .default))
                            .foregroundColor(Color.gray)
                            .padding(.trailing, 12)
                        
                        Text(event.name)
                            .font(.system(size: 16, weight: .bold, design: .default))
                    }
                    Spacer()
                    Button {
                        viewStore.send(.tapOnRemoveEvent(eventId: event.id, calendarId: calendarId))
                    } label: {
                        Image(systemName: "trash")
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
                    Button {
                        viewStore.send(.tapOnCreateEventInCalendar(calendarId: calendarId))
                    } label: {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Create Event")
                        }
                    }
                    Spacer()
                }.padding()
            }.onAppear {
                viewStore.send(.onViewDidLoad(calendarId: calendarId))
            }
            
            Spacer()
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

struct ListOfEventsView_Previews: PreviewProvider {
    static var previews: some View {
        ListOfEventsView(
            store: Store(
                initialState: EventFeatureState(
                    currentCalendar: "1",
                    events: [],
                    dateOfNewEvent: Date()),
                reducer: eventReducer,
                environment: EventEnvironment(getCalendarEvents: getCalendarEventsEffect,
                                              createEvent: createEventEffect,
                                              removeEvent: removeEventEffect)),
            calendarId: "1")
    }
}
