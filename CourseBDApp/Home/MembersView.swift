

import SwiftUI

struct MembersView: View {
    @State var members = [DiscordUser]()
    @State var memberSearch = ""
    var server: Server
    
    var body: some View {
        VStack {
            Text("Members")
                .font(.title)
            
            List(members) { user in
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
            
        }
        .frame(maxHeight: .infinity)
        .padding(.trailing, 90)
        .background(Color(.background))
        .scrollContentBackground(.hidden)
        .preferredColorScheme(.dark)
        .onChange(of: DatabaseService.shared.users) { oldValue, newValue in
            fetchMembers()
        }
        .onAppear {
            fetchMembers()
        }
    }
    
    func fetchMembers() {
        members = DatabaseService.shared.users.filter { user in
            server.members.contains(where: { $0 == user.id })
        }
    }
}

#Preview {
    MembersView(server: Server(createdAt: .now, name: "iOS Dojo", imageURL: "", admin: .init(), members: [], channels: []))
}
