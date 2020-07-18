import Foundation
import ComposableArchitecture
import GoogleSignIn
import Combine

func logoutEffect() -> Effect<Bool, Never> {
    return Future { callback in
        GIDSignIn.sharedInstance()?.signOut()
        callback(.success(true))
    }.eraseToEffect()
}
