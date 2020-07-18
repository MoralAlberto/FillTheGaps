import Foundation
import ComposableArchitecture
import GoogleSignIn
import Combine
import GoogleAPIClientForREST

func removeEventEffect(inCalendarId calendarId: String, eventId: String) -> Effect<Bool, Never> {
    return Future { callback in
        let service = GTLRCalendarService()
        service.shouldFetchNextPages = true
        service.isRetryEnabled = true
        service.maxRetryInterval = 15

        guard let currentUser = GIDSignIn.sharedInstance().currentUser,
              let authentication = currentUser.authentication else {
            return callback(.success(false))
        }

        service.authorizer = authentication.fetcherAuthorizer()
        
        let deleteEventQuery = GTLRCalendarQuery_EventsDelete.query(withCalendarId: calendarId, eventId: eventId)

        _ = service.executeQuery(deleteEventQuery, completionHandler: { (ticket, result, error) in
            if error == nil {
                callback(.success(true))
            } else {
                callback(.success(false))
            }
        })
    }.eraseToEffect()
}
