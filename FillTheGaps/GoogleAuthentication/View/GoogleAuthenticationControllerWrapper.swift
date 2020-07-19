import Foundation
import SwiftUI
import UIKit
import ComposableArchitecture

struct GoogleAuthenticationControllerWrapper: UIViewControllerRepresentable {
    let store: Store<SessionFeatureState, SessionAction>
    
    func makeUIViewController(context: Context) -> some UIViewController {
        GoogleAuthenticationController(store: store)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}
