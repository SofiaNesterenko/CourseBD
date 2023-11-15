

import SwiftUI

struct ServerInfoView: View {
    @Binding var showCreateServer: Bool
    @State var serverName = ""
    
    var body: some View {
        VStack {
            Text("Create Your Server")
                .font(.title)
                .bold()
                .padding()
            
            Text("Your server is where you and your friends hang out. Make yours and start talking.")
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.6)
                .padding(.bottom)
            
            Button {
                
            } label: {
                ZStack {
                    Image(systemName: "circle.dotted")
                        .resizable()
                        .scaledToFit()
                    
                    Image(systemName: "camera.fill")
                        .resizable()
                        .scaledToFit()
                        .padding(36)
                        .padding(.bottom)
                    
                    Text("Upload")
                        .font(.caption2)
                        .textCase(.uppercase)
                        .padding(.top, 42)
                }
                .foregroundStyle(.white)
                .frame(width: 110)
                .overlay(alignment: .topTrailing) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32)
                        .foregroundStyle(.discord)
                        .background(
                            Circle()
                                .fill(.white)
                        )
                }
            }

            
            DiscordTextField(header: "Server Name", placeHolder: "", text: $serverName)
                .padding(.bottom)
            
            Button {
                createServer()
            } label: {
                Text("Create Server")
                    .bold()
                    .foregroundStyle(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        .discord
                    )
            }

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding()
        .background(Color(.background))
        .preferredColorScheme(.dark)
        
    }
    
    func createServer() {
        if let user = AuthService.shared.currentUser, serverName.count > 2 {
            Task {
                do {
                    try await DatabaseService.shared.createServer(user: user, serverName: serverName)
                    showCreateServer = false
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

#Preview {
    ServerInfoView(showCreateServer: .constant(true))
}
