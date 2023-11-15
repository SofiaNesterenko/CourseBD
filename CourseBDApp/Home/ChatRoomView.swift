

import SwiftUI
import SDWebImageSwiftUI

struct ChatRoomView: View {
    @State var message = ""
    @Binding var messages: [Message]
    var channel: Channel
    var mockMessages = [
        Message(id: .init(), createdAt: Calendar.current.date(byAdding: .hour, value: -2, to: .now)!, username: "tomars", imageURL: "elon", text: "Maybe I'll buy discord next 🤔", channelUid: .init(), serverId: 5),
        Message(id: .init(), createdAt: Calendar.current.date(byAdding: .minute, value: -66, to: .now)!, username: "captainlevi", imageURL: "levi", text: "Where's Eren ?!?", channelUid: .init(), serverId: 5),
        Message(id: .init(), createdAt: Calendar.current.date(byAdding: .hour, value: -1, to: .now)!, username: "jason", imageURL: "jason", text: "FULL STACK BABYYYY! 🔥", channelUid: .init(), serverId: 5),
        Message(id: .init(), createdAt: .now, username: "elon", imageURL: "elon", text: "*INSERT PROBLEMATIC MEME*", channelUid: .init(), serverId: 5),
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            ScrollViewReader { scrollView in
                ScrollView {
                    VStack {
                        VStack(alignment: .leading) {
                            Image(systemName: "number")
                                .imageScale(.large)
                                .padding()
                                .background {
                                    Circle()
                                        .fill(Color(uiColor: .systemGray3))
                                }
                                .padding(.bottom, 24)
                                
                            
                            Text("Welcome to \(channel.name)")
                                .font(.title2)
                                .bold()
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        
                        LazyVStack {
                            ForEach(messages) { message in
                                MessageView(message: message)
                            }
                        }
                    }
                }
                .onAppear {
                    withAnimation {
                        scrollView.scrollTo(messages.count - 1, anchor: .bottom)
                    }
                }
                .onChange(of: messages) { oldValue, newValue in
                    withAnimation {
                        scrollView.scrollTo(messages.count - 1, anchor: .bottom)
                    }
                }
            }
            
            Divider()
                .overlay {
                    Color.black
                }
            
            HStack {
                TextField("Message #\(channel.name)", text: $message)
                    .padding()
                    .background {
                        Capsule()
                            .fill(Color(uiColor: .systemGray6))
                    }
                
                Button {
                    sendMessage()
                } label: {
                    Image(systemName: "arrow.up.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32)
                        .foregroundStyle(Color(uiColor: .systemGray6))
                        .background {
                            Circle()
                                .fill(.gray)
                        }
                }
                .frame(height: 70)
            }
            .padding(.horizontal, 8)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    }
    
    func sendMessage() {
        Task {
            do {
                guard let user = AuthService.shared.currentUser, message.count > 2 else {
                    return
                }

                let message = Message(id: UUID(), createdAt: .now, username: user.username, imageURL: "", text: message, channelUid: channel.channelUid, serverId: channel.serverId)
                try await DatabaseService.shared.sendMessage(message: message)
                messages.append(message)
                self.message = ""
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

#Preview {
    ChatRoomView(messages: .constant([]), channel: Channel(createdAt: .now, name: "off-topic", channelUid: .init(), admin: .init(), serverId: 5, messages: []))
}
