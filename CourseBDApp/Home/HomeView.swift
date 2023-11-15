

import SwiftUI

struct HomeView: View {
    @State var showSideMenu = false
    @State var showCreateServer = false
    @State var selectedServer: Server?
    @State var selectedChannel: Channel?
    var body: some View {
        ZStack {
            // Menu View
            MenuView(showCreateServer: $showCreateServer, selectedServer: $selectedServer, selectedChannel: $selectedChannel)
            
            // ChatView
            ChatView(showSideMenu: $showSideMenu, channel: $selectedChannel, server: selectedServer ?? Server(createdAt: .now, name: "iOS Dojo", imageURL: "", admin: .init(), members: [], channels: []))
                .offset(x: showSideMenu ? 340 : 0)
            
            Color.black
                .opacity(showSideMenu ? 0.7 : 0)
                .offset(x: showSideMenu ? 340 : 0)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation {
                        showSideMenu = false
                    }
                }
        }
        .toolbar(showSideMenu ? .visible : .hidden, for: .tabBar)
        .fullScreenCover(isPresented: $showCreateServer) {
            CreateServerView(showCreateServer: $showCreateServer)
        }
        .onChange(of: DatabaseService.shared.userServers) { oldValue, newValue in
            if selectedServer == nil {
                selectedServer = DatabaseService.shared.userServers.first
                selectedChannel = selectedServer?.channelModels.first
            }
        }
    }
}

#Preview {
    HomeView()
}
