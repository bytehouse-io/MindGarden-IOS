//
//  AuthenticationViewModel.swift
//  MindGarden
//
//  Created by Dante Kim on 7/4/21.
//

import GoogleSignIn
import FirebaseAuth
import Firebase
import CryptoKit
import SwiftUI
import AuthenticationServices
import Combine

class AuthenticationViewModel: NSObject, ObservableObject {
    @ObservedObject var viewRouter: ViewRouter
    @ObservedObject var userModel: UserViewModel
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var forgotEmail: String = ""
    @Published var alertError: Bool = false
    @Published var alertMessage: String = "Please try again using a different email or method"
    @Published var isLoading: Bool = false
    var currentNonce: String?
    var googleIsNew: Bool = true

    let db = Firestore.firestore()
    var isSignUp: Bool = false
    var appleAlreadySigned: Bool = false
    init(userModel: UserViewModel, viewRouter: ViewRouter) {
        self.userModel = userModel
        self.viewRouter = viewRouter
        super.init()
        setupGoogleSignIn()
    }
    var siwa: some View {
        return Group {
            if #available(iOS 14.0, *) {
                SignInWithAppleButton(
                    //Request
                    onRequest: { [self] request in
                        request.requestedScopes = [.fullName, .email]
                        let nonce = randomNonceString()
                        currentNonce = nonce
                        request.nonce = sha256(nonce)
                    },

                    //Completion
                    onCompletion: { [self] result in
                        isLoading = false
                        switch result {
                        case .success(let authResults):
                            switch authResults.credential {
                            case let appleIDCredential as ASAuthorizationAppleIDCredential:
                                guard let nonce = currentNonce else {
                                    alertError = true
                                    alertMessage = "Please try again using a different email or method"
                                    return
                                }
                                guard let appleIDToken = appleIDCredential.identityToken else {
                                    alertError = true
                                    return
                                }
                                guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                                    print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                                    return
                                }

                                let credential = OAuthProvider.credential(withProviderID: "apple.com",idToken: idTokenString,rawNonce: nonce)
                                    Auth.auth().signIn(with: credential, completion: { (user, error) in
                                        if (error != nil) {
                                            alertError = true
                                            alertMessage = error?.localizedDescription ?? "Please try again using a different email or method"
                                            print(error?.localizedDescription ?? "high roe")
                                            return
                                        }
                                        UserDefaults.standard.set(appleIDCredential.user, forKey: "appleAuthorizedUserIdKey")
                                        alertError = false
                                        withAnimation {
                                            viewRouter.currentPage = .meditate
                                        }
                                        guard let _ = appleIDCredential.email else {
                                            print("jangu")
                                            // User already signed in with this appleId once
                                            return
                                        }
                                        createUser()
                                    })
                                print("\(String(describing: Auth.auth().currentUser?.uid))")
                            default:
                                break

                            }
                        default:
                            break
                        }
                    }
                )
            } else {
                // Fallback on earlier versions
            }
        }
    }
    enum SignInState {
        case signedIn
        case signedOut
    }
    

    @Published var state: SignInState = .signedOut

    func signInWithGoogle() {
        if GIDSignIn.sharedInstance().currentUser == nil {
            GIDSignIn.sharedInstance().presentingViewController = UIApplication.shared.windows.first?.rootViewController
            GIDSignIn.sharedInstance().signIn()
        }
    }

    func signOut() {
        GIDSignIn.sharedInstance().signOut()

        do {
            try Auth.auth().signOut()
            state = .signedOut
        } catch let signOutError as NSError {
            print(signOutError.localizedDescription)
        }
    }

    private func setupGoogleSignIn() {
        GIDSignIn.sharedInstance().delegate = self
    }
}

extension AuthenticationViewModel: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error == nil {
            if isSignUp {
                Auth.auth().fetchSignInMethods(forEmail: user.profile.email, completion: { [self]
                    (providers, error) in
                    if let error = error {
                        alertError = true
                        alertMessage = error.localizedDescription
                    } else if let providers = providers {
                        if providers.count != 0 {
                            googleIsNew = false
                        }
                    }
                })
                self.firebaseAuthentication(withUser: user)
            }
        } else {
            print(error.debugDescription)
        }
    }

    private func firebaseAuthentication(withUser user: GIDGoogleUser) {
        if let authentication = user.authentication {
            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)

            Auth.auth().signIn(with: credential) { [self] (_, error) in
                isLoading = false
                if let _ = error {
                    alertError = true
                    alertMessage = error?.localizedDescription ?? "Please try again using a different email or method"
                } else {
                    if googleIsNew {
                        createUser()
                    }
                    self.state = .signedIn
                    withAnimation {
                        viewRouter.currentPage = .meditate
                    }
                    alertError = false
                }
            }
        }
    }
}

//MARK: - regular sign up
extension AuthenticationViewModel {
    var validatedPassword: AnyPublisher<String?, Never> {
        return $password
            .map { $0.count < 6 ? "invalid" : $0 }
            .eraseToAnyPublisher()
    }

    var validatedEmail: AnyPublisher<String?, Never> {
        let emailFormat = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" + "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" + "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" + "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" + "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" + "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" + "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return $email
            .map { !emailPredicate.evaluate(with: $0) ? "invalid"  : $0}
            .eraseToAnyPublisher()
    }

    var validatedCredentials: AnyPublisher<(String, String)?, Never> {
        validatedEmail.combineLatest(validatedPassword) { email, password in
            guard let mail = email, let pwd = password else { return nil }
            return (mail, pwd)
        }
        .eraseToAnyPublisher()
    }

    func signUp() {
        print("signing up")
        Auth.auth().createUser(withEmail: self.email, password: self.password) { [self] result,error in
            isLoading = false
            if error != nil  {
                alertError = true
                alertMessage = error?.localizedDescription ?? "Please try again using a different email or method"
                return
            }
            createUser()
            alertError = false
            withAnimation {
                viewRouter.currentPage = .meditate
            }
        }
    }

    func signIn() {
        Auth.auth().signIn(withEmail: email, password: password) { [self] authResult, error in
            isLoading = false
            if error != nil {
                alertError = true
                alertMessage = error?.localizedDescription ?? "Please try again using a different email or method"
                return
            }
            getData()
            alertError = false
            withAnimation {
                viewRouter.currentPage = .meditate
            }
        }
    }

    func forgotPassword() {
        Auth.auth().sendPasswordReset(withEmail: forgotEmail) { [self] error in
            isLoading = false
            if error != nil {
                alertError = true
                alertMessage = error?.localizedDescription ?? "Please try again using a different email or method"
            } else {
                alertError = false
            }
        }
    }

    func createUser() {
        // localize
        print("creating User")
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd,yyyy"
        if let email = Auth.auth().currentUser?.email {
            db.collection(K.userPreferences).document(email).setData([
                "name": "Bingo",
                "coins": 100,
//                "favorited": [0],
//                "plants": [],
                "joinDate": formatter.string(from: Date())
            ]) { (error) in
                if let e = error {
                    print("There was a issue saving data to firestore \(e) ")
                } else {
                    print("Succesfully saved")
                }
            }
        }
        userModel.coins = 100
        userModel.name = "Bingo"
        userModel.joinDate = formatter.string(from: Date())
    }

    func getData() {
        print("saving data")
        if let email = Auth.auth().currentUser?.email {
            db.collection(K.userPreferences).document(email).getDocument { (snapshot, error) in
                if let document = snapshot, document.exists {
                    if let name = document[K.defaults.name] {
                        UserDefaults.standard.setValue(name, forKey: K.defaults.name)
                    }
                    if let joinDate = document[K.defaults.joinDate] {
                        UserDefaults.standard.setValue(joinDate, forKey: K.defaults.joinDate)
                    }
                }
            }
        }
    }
}

extension AuthenticationViewModel {
    //Hashing function using CryptoKit
    func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()

        return hashString
    }

    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length

        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }

            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }

                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }

        return result
    }
}
