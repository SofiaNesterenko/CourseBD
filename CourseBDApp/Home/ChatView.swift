

import SwiftUI

struct ChatView: View {
    @Binding var showSideMenu: Bool
    @State var showMembers = false
    @State var messages = [Message]()
    @Binding var channel: Channel?
    
    var server: Server
    
    var body: some View {
        ZStack {
            if let channel {
                VStack(spacing: 0) {
                    HStack {
                        Button {
                            withAnimation {
                                showSideMenu = true
                            }
                        } label: {
                            Image(systemName: "line.3.horizontal")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24)
                                .foregroundStyle(.white)
                        }
                        
                        Image(systemName: "number")
                        
                        Text("\(channel.name)")
                            .bold()
                            .font(.callout)
                        
                        Spacer()
                        
                        Button {
                            withAnimation {
                                showMembers = true
                            }
                        } label: {
                            Image(systemName: "person.2.fill")
                                .foregroundStyle(.white)
                        }

                    }
                    .padding()
                    .padding(.top, 42)
                    .background {
                        Color(uiColor: .systemGray6)
                    }
                    
                    ChatRoomView(messages: $messages, channel: channel)
                        .padding(.bottom)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .preferredColorScheme(.dark)
                .background {
                    Color(.background)
                }
                .ignoresSafeArea()
                .offset(x: showMembers ? -UIScreen.main.bounds.width + 60 : 0)
                .onChange(of: DatabaseService.shared.messages) { oldValue, newValue in
                    fetchMessages()
                }
                .onChange(of: self.channel) { oldValue, newValue in
                    fetchMessages()
                }
                .onAppear {
                    fetchMessages()
                }
            }
            
            Color.black
                .opacity(showMembers ? 0.7 : 0)
                .offset(x: showMembers ? -UIScreen.main.bounds.width + 60 : 0)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation {
                        showMembers = false
                    }
                }
            
            if showMembers {
                MembersView(server: server)
                    .offset(x: 60)
            }
        }
        
    }
    
    func fetchMessages() {
        if let channel, let messages = DatabaseService.shared.messages[channel.channelUid] {
            self.messages = messages
        }
    }
}

#Preview {
    ChatView(showSideMenu: .constant(false), channel: .constant(Channel(createdAt: .now, name: "off-topic", channelUid: .init(), admin: .init(), serverId: 8, messages: [])), server: Server(createdAt: .now, name: "iOS Dojo", imageURL: "", admin: .init(), members: [], channels: []))
}
