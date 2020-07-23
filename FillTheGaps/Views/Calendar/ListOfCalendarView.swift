import SwiftUI
import ComposableArchitecture

enum CalendarViewSheet {
    case listOfEvents
}

struct ListOfCalendarsView: View {
    struct ViewState: Equatable {
        let user: String
        let calendars: [CalendarModel]
        let currentCalendar: String
        let presentSheetInCalendarView: Bool
        let calendarViewSheet: CalendarViewSheet
    }
    
    enum Action {
        case viewDidLoad
        case tapOnCalendar(calendarId: String)
        case dismissSheetInCalendarView
    }
    
    let store: Store <AppState, AppAction>
    @ObservedObject var viewStore: ViewStore<ViewState, Action>
    
    init(store: Store<AppState, AppAction>) {
        self.store = store
        let calendarScope = store.scope(state: \.calendar, action: AppAction.calendar)
        self.viewStore = ViewStore(calendarScope.scope(state: { $0.view }, action: CalendarAction.view))
    }
    
    var body: some View {
            Group {
                if viewStore.user.isEmpty {
                    GoogleAuthenticationControllerWrapper(
                        store: store.scope(
                            state: \.session,
                            action: AppAction.session)
                    )
                } else {
                    Text("List of Calendars")
                        .font(.system(size: 18, weight: .bold))
                        .underline()
                        .padding()
                    List {
                        ForEach(viewStore.calendars, id: \.self) { calendar in
                            Text(calendar.summary).onTapGesture {
                                viewStore.send(.tapOnCalendar(calendarId: calendar.id))
                            }
                        }
                    }.onAppear {
                        viewStore.send(.viewDidLoad)
                    }
                }
            }.sheet(isPresented: .constant(viewStore.presentSheetInCalendarView),
                    onDismiss: { viewStore.send(.dismissSheetInCalendarView) })
            {
                if viewStore.calendarViewSheet == .listOfEvents {
                    ListOfEventsView(
                        store: store.scope(
                            state: \.event,
                            action: AppAction.event),
                        calendarId: viewStore.currentCalendar
                    )
                }
            }
    }
}

// MARK: Extension to init State and Action

extension CalendarFeatureState {
    var view: ListOfCalendarsView.ViewState {
        .init(user: user,
              calendars: calendars,
              currentCalendar: currentCalendar,
              presentSheetInCalendarView: presentSheetInCalendarView,
              calendarViewSheet: calendarViewSheet)
    }
}

extension CalendarAction {
    static func view(_ localAction: ListOfCalendarsView.Action) -> Self {
        switch localAction {
        case .viewDidLoad:
            return .getCalendars
        case .tapOnCalendar(calendarId: let calendarId):
            return .selectedCalendar(calendarId: calendarId)
        case .dismissSheetInCalendarView:
            return .dismissSheetInCalendarView
        }
    }
}

