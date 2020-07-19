import Foundation
import ComposableArchitecture
import GoogleSignIn
import Combine
import GoogleAPIClientForREST

func createEventEffect(inCalendarId calendarId: String, startDate: Date, duration: Int) -> Effect<Bool, Never> {
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
  
        let event = GTLRCalendar_Event()
        event.summary = "Fill the Gap"
        event.descriptionProperty = "Description Example 🤓"
        event.visibility = "confidential"
        
        let endDate = startDate.addingTimeInterval(Double(duration) * 60 * 60)
        event.start = buildDate(date: startDate)
        event.end = buildDate(date: endDate)
        
        let insertEventQuery = GTLRCalendarQuery_EventsInsert.query(withObject: event, calendarId: calendarId)

        _ = service.executeQuery(insertEventQuery, completionHandler: { (ticket, result, error) in
            if error == nil {
                callback(.success(true))
            } else {
                callback(.success(false))
            }
        })
    }.eraseToEffect()
}


func buildDate(date: Date) -> GTLRCalendar_EventDateTime {
    let dateTime = GTLRDateTime(date: date)
    let eventDateTime = GTLRCalendar_EventDateTime()
    eventDateTime.dateTime = dateTime
    return eventDateTime
}
