import ComposableArchitecture
import Foundation

let appReducer = Reducer<AppState, AppAction, AppEnvironment> { state, action, environment in
    switch action {
    case .viewDidLoad:
        return environment.getCurrentUser()
                .map(AppAction.currentUserResponse)
                .receive(on: DispatchQueue.main)
                .eraseToEffect()
        
    case .currentUserResponse(let currentUser):
        state.user = currentUser
        
        return .none
        
    case .authenticatedWithGoogleResponse(let currentUser):
        state.user = currentUser
        
        return .none
        
    case .tapOnLogout:
        return environment.logout()
            .map(AppAction.logoutResponse)
            .receive(on: DispatchQueue.main)
            .eraseToEffect()
        
    case .logoutResponse(let result):
        if result {
            state.user = ""
        }
            
    case .event(_):
        return .none
    case .calendar(_):
        return .none
    }
    
    return .none
}

// Create Session Reducer
