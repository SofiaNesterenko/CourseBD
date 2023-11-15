

import SwiftUI

struct UserSearchView: View {
    @State var userSearch = ""
    
    var filterUsers: [DiscordUser] {
        DatabaseService.shared.users.filter({
            $0.username.localizedCaseInsensitiveContains(userSearch)
        })
    }
    
    var body: some View {
        NavigationStack {
            List(userSearch.isEmpty ? DatabaseService.shared.users : filterUsers) { user in
                HStack {
                    Text(user.username.prefix(1))
                        .font(.largeTitle)
                        .frame(width: 32)
                        .padding()
                        .background {
                            Circle()
                                .fill(Color(.discord))
                        }
                    
                    Text(user.username)
                        .font(.title3)
                }
            }
            .frame(maxHeight: .infinity)
            .background(Color(.background))
            .scrollContentBackground(.hidden)
            .searchable(text: $userSearch)
            .navigationTitle("Users")
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    UserSearchView()
}
