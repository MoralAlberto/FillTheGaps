import Foundation
import ComposableArchitecture
import GoogleSignIn
import Combine

func getCurrentUserEffect() -> Effect<String, Never> {
    return Future { callback in
        GIDSignIn.sharedInstance().clientID = TwitterClient.clientId.rawValue
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        let currentUser = GIDSignIn.sharedInstance()?.currentUser
        callback(.success(currentUser?.profile.name ?? ""))
    }.eraseToEffect()
}
