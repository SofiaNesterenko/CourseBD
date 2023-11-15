
import SwiftUI

struct ContentView: View {
    var body: some View {
        if let user = AuthService.shared.currentUser {
            DiscordTabView()
        } else {
            AuthView()
        }
    }
}

#Preview {
    ContentView()
}
