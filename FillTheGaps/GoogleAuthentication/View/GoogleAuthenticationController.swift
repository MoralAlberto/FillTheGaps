import Foundation
import UIKit
import GoogleSignIn
import GoogleAPIClientForREST
import ComposableArchitecture

class GoogleAuthenticationController: UIViewController {
    let store: Store<SessionFeatureState, SessionAction>
    let clientId = "703057389515-3mihmq71h2fiv7ur72j9r3grakvii6bh.apps.googleusercontent.com"
    
    lazy var loginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Login with Google", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(loginWithGoogle), for: .touchUpInside)
        return button
    }()
    
    var authentication: GIDAuthentication?
    
    fileprivate lazy var calendarService: GTLRCalendarService? = {
        let service = GTLRCalendarService()
        service.shouldFetchNextPages = true
        service.isRetryEnabled = true
        service.maxRetryInterval = 15
        
        guard let currentUser = GIDSignIn.sharedInstance().currentUser,
              let authentication = currentUser.authentication else {
            return nil
        }
        
        service.authorizer = authentication.fetcherAuthorizer()
        return service
    }()
    
    init(store: Store<SessionFeatureState, SessionAction>) {
        self.store = store
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(loginButton)
        
        NSLayoutConstraint.activate([
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc func loginWithGoogle() {
        startGoogleAuthentication()
    }
}

extension GoogleAuthenticationController: GIDSignInDelegate {

    func startGoogleAuthentication() {
        GIDSignIn.sharedInstance().clientID = clientId
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()

        var scopes = GIDSignIn.sharedInstance().scopes
        scopes?.append("https://www.googleapis.com/auth/calendar")
        GIDSignIn.sharedInstance().presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().scopes = scopes!
        GIDSignIn.sharedInstance()?.shouldFetchBasicProfile = true
        GIDSignIn.sharedInstance().signIn()
    }
    
    // MARK: Delegates
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("Error Login with Google: \(error)")
            return
        }
  
        ViewStore(store).send(.responseAuthenticatedWithGoogle(user.profile.name))
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("User disconnected")
    }
}
