import Foundation
import ComposableArchitecture

struct SessionFeatureState: Equatable {
    var user: String
}

enum SessionAction: Equatable {
    case viewDidLoad
    case responseCurrentUser(String)
    case responseAuthenticatedWithGoogle(String)
}

struct SessionEnvironment {
    var getCurrentUser: () -> Effect<String, Never>
}

let sessionReducer = Reducer<SessionFeatureState, SessionAction, SessionEnvironment> { state, action, environment in
    
    switch action {
    case .viewDidLoad:
        return environment.getCurrentUser()
            .map(SessionAction.responseCurrentUser)
            .receive(on: DispatchQueue.main)
            .eraseToEffect()
        
    case .responseCurrentUser(let user):
        state.user = user
        
    case .responseAuthenticatedWithGoogle(let user):
        state.user = user
    }
    
    return .none
    
}
