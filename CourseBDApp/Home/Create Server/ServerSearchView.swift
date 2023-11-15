

import SwiftUI

struct ServerSearchView: View {
    @Environment(\.dismiss) var dismiss
    @State var serverSearch = ""
    
    var body: some View {
        List(DatabaseService.shared.servers) { server in
            Button {
                joinServer(server)
            } label: {
                HStack {
                    Text(server.name.prefix(1))
                        .font(.largeTitle)
                        .frame(width: 32)
                        .padding()
                        .background {
                            Circle()
                                .fill(Color(.discord))
                        }
                    
                    Text(server.name)
                        .font(.title3)
                }
            }
            .foregroundStyle(.white)

        }
        .frame(maxHeight: .infinity)
        .background(Color(.background))
        .scrollContentBackground(.hidden)
        .searchable(text: $serverSearch)
        .navigationTitle("Server")
        .preferredColorScheme(.dark)
    }
    
    func joinServer(_ server: Server) {
        Task {
            do {
                guard let user = AuthService.shared.currentUser, let uid = user.id, !server.members.contains(uid) else {
                    return
                }
                
                try await DatabaseService.shared.joinServer(server: server, user: user)
                dismiss()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

#Preview {
    ServerSearchView()
}
