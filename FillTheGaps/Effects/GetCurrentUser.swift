import Foundation
import ComposableArchitecture
import GoogleSignIn
import Combine

func getCurrentUserEffect() -> Effect<String, Never> {
    return Future { callback in
        GIDSignIn.sharedInstance().clientID = "703057389515-3mihmq71h2fiv7ur72j9r3grakvii6bh.apps.googleusercontent.com"
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        let currentUser = GIDSignIn.sharedInstance()?.currentUser
        callback(.success(currentUser?.profile.name ?? ""))
    }.eraseToEffect()
}
