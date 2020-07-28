import Foundation
import ComposableArchitecture
import GoogleSignIn
import Combine
import GoogleAPIClientForREST

func getCalendarEventsEffect(calendarId: String) -> Effect<[EventModel], Never> {
    return Future { callback in
        let service = GTLRCalendarService()
        service.shouldFetchNextPages = true
        service.isRetryEnabled = true
        service.maxRetryInterval = 15
        
        guard let currentUser = GIDSignIn.sharedInstance().currentUser,
              let authentication = currentUser.authentication else {
            return callback(.success([]))
        }
        
        service.authorizer = authentication.fetcherAuthorizer()
    
        let date = Date()
        let startDateTime = GTLRDateTime(date: Calendar.current.startOfDay(for: date.startOfWeek!))
        let endDateTime = GTLRDateTime(date: Calendar.current.startOfDay(for: date.endOfWeek!))
        
        let eventsListQuery = GTLRCalendarQuery_EventsList.query(withCalendarId: calendarId)
        eventsListQuery.timeMin = startDateTime
        eventsListQuery.timeMax = endDateTime
        
        _ = service.executeQuery(eventsListQuery, completionHandler: { (ticket, result, error) in
            guard error == nil, let items = (result as? GTLRCalendar_Events)?.items else {
                return
            }
            
            let events = items.compactMap(EventModel.init(googleEvent:))
            callback(.success(events))
        })
    }.eraseToEffect()
}
