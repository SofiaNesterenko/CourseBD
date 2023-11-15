
import SwiftUI

@Observable
final class AuthViewModel {
    var signInEmail = ""
    var signInPassword = ""
    
    var registerEmail = ""
    var registerPassword = ""
    var registerUsername = ""
    var registerDisplayName = ""
    var registerDOB = Date.now
    
    func logIn() {
        Task {
            do {
                try await AuthService.shared.signIn(email: signInEmail, password: signInPassword)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func createAccount() {
        Task {
            do {
                let user = DiscordUser(createdAt: .now, username: registerUsername, displayName: registerUsername, email: registerEmail, imageURL: "", dob: registerDOB, servers: [])
                try await AuthService.shared.registerNewUserWithEmail(user: user, password: registerPassword)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

extension EnvironmentValues {
    var authViewModel: AuthViewModel {
        get { self[AuthViewModelKey.self] }
        set { self[AuthViewModelKey.self] = newValue }
    }
}

private struct AuthViewModelKey: EnvironmentKey {
    static var defaultValue: AuthViewModel = AuthViewModel()
}