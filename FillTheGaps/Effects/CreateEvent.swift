import Foundation
import ComposableArchitecture
import GoogleSignIn
import Combine
import GoogleAPIClientForREST

func createEventEffect(inCalendarId calendarId: String) -> Effect<Bool, Never> {
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
        event.summary = "Fill the Gap 2"
        event.descriptionProperty = "Description Example 🤓"
        event.visibility = "confidential"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        let startDate = dateFormatter.date(from: "19/07/2020 15:00")
        let endDate = dateFormatter.date(from: "19/07/2020 15:30")
        
        guard let toBuildDateStart = startDate, let toBuildDateEnd = endDate else {
            return callback(.success(false))
        }
        
        event.start = buildDate(date: toBuildDateStart)
        event.end = buildDate(date: toBuildDateEnd)
        
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
