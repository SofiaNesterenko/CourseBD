

import SwiftUI

struct CreateChannelView: View {
    @Environment(\.dismiss) var dismiss
    @State var name = ""
    var server: Server
    
    var body: some View {
        VStack {
            HStack {
                Button("Close") {
                    dismiss()
                }
                .bold()
                
                Spacer()
                
                Text("Create Channel")
                    .font(.title2)
                    .bold()
                
                Spacer()
                
                Button("Create") {
                    createChannel()
                }
                .bold()
            }
            .padding()
            .foregroundStyle(.white)
            
            ScrollView {
                DiscordTextField(header: "Channel name", placeHolder: "new-channel", text: $name)
                    .padding(.vertical)
                
                Text("Channel Type")
                    .font(.callout)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack {
                    Image(systemName: "number")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18)
                        .foregroundStyle(.gray)
                    
                    VStack(alignment: .leading) {
                        Text("Text")
                        
                        Text("Post images, GIFs, stickers, opinions, and puns")
                            .font(.caption)
                            .foregroundStyle(.gray)
                            .lineLimit(1)
                    }
                    
                    Spacer()
                    
                    Toggle("", isOn: .constant(true))
                        .toggleStyle(.button)
                        .tint(Color.discord)
                        .clipShape(Circle())
                        .overlay {
                            Circle()
                                .stroke()
                                .padding(-6)
                        }
                }
                .padding(.horizontal)
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .preferredColorScheme(.dark)
        .background(Color.background)
        .onChange(of: name) { oldValue, newValue in
            name = name.replacingOccurrences(of: " ", with: "-")
        }
    }
    
    func createChannel() {
        Task {
            do {
                guard let user = AuthService.shared.currentUser, let uid = user.id, let serverId = server.id, name.count > 2 else {
                    return
                }
                let channel = Channel(createdAt: .now, name: name, channelUid: UUID(), admin: uid, serverId: serverId, messages: [])
                try await DatabaseService.shared.createChannelForServer(admin: user, server: server, channel: channel)
                dismiss()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

#Preview {
    CreateChannelView(server: Server(createdAt: .now, name: "iOS Dojo", imageURL: "", admin: .init(), members: [], channels: []))
}
