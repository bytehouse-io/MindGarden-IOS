//
//  AuthenticationViewModel.swift
//  MindGarden
//
//  Created by Dante Kim on 7/4/21.
//

import GoogleSignIn
import FirebaseAuth
import CryptoKit
import SwiftUI
import AuthenticationServices
import Combine

class AuthenticationViewModel: NSObject, ObservableObject {
    @State var currentNonce:String?
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var forgotEmail: String = ""
    @Published var alertError: Bool = false
    @Published var goToHome: Bool = false
    @Published var isLoading: Bool = false

    var siwa: some View {
        return Group {
            if #available(iOS 14.0, *) {
                SignInWithAppleButton(

                    //Request
                    onRequest: { [self] request in
                        let nonce = randomNonceString()
                        currentNonce = nonce
                        request.requestedScopes = [.fullName, .email]
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
                                Auth.auth().signIn(with: credential) { (authResult, error) in
                                    if (error != nil) {
                                        alertError = true
                                        print(error?.localizedDescription as Any)
                                        return
                                    }
                                    alertError = false
                                    goToHome = true
                                }

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

    override init() {
        super.init()

        setupGoogleSignIn()
    }

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
            firebaseAuthentication(withUser: user)
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
                } else {
                    self.state = .signedIn
                    goToHome = true
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
        Auth.auth().createUser(withEmail: self.email, password: self.password) { [self] result,error in
            isLoading = false
            if error != nil  {
                alertError = true
                return
            }
            alertError = false
            goToHome = true
        }
    }

    func signIn() {
        Auth.auth().signIn(withEmail: email, password: password) { [self] authResult, error in
            isLoading = false
            if error != nil {
                alertError = true
                return
            }
            alertError = false
            goToHome = true
        }
    }

    func forgotPassword() {
        Auth.auth().sendPasswordReset(withEmail: forgotEmail) { [self] error in
            isLoading = false
            if error != nil {
                alertError = true
            } else {
                alertError = false
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
