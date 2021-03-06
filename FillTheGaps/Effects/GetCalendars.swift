import Foundation
import ComposableArchitecture
import GoogleSignIn
import Combine
import GoogleAPIClientForREST

func getCalendarsEffect() -> Effect<[CalendarModel], Never> {
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
    
        let calendars = GTLRCalendarQuery_CalendarListList.query()

        _ = service.executeQuery(calendars, completionHandler: { (ticket, result, error) in
            guard error == nil,
                  let items = (result as? GTLRCalendar_CalendarList)?.items else {
                return
            }

            let calendarsIdentifiers = items.compactMap(CalendarModel.init(googleCalendar:)).sorted(by: { $0.id > $1.id })
            callback(.success(calendarsIdentifiers))
        })
    }.eraseToEffect()
}
