
import SwiftUI

struct CreateServerView: View {
    @Binding var showCreateServer: Bool
    
    var body: some View {
        NavigationStack {
            VStack {
                Button("Close") {
                    showCreateServer = false
                }
                .foregroundStyle(.white)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("Create Your Server")
                    .font(.title)
                    .bold()
                    .padding()
                
                Text("Your server is where you and your friends hang out. Make yours and start talking.")
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.6)
                    .padding(.bottom)
                
                NavigationLink {
                    ServerInfoView(showCreateServer: $showCreateServer)
                } label: {
                    Text("Create My Own")
                        .bold()
                        .foregroundStyle(.white)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            .thickMaterial
                        )
                        .overlay(alignment: .trailing) {
                            Image(systemName: "chevron.right")
                                .padding()
                                .foregroundStyle(.white)
                        }
                }

                Spacer()
                
                Text("Have one in mind?")
                    .bold()
                
                NavigationLink {
                    ServerSearchView()
                } label: {
                    Text("Join a Server")
                        .bold()
                        .foregroundStyle(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            .ultraThinMaterial
                        )
                }

                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding()
            .background(Color(.background))
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    CreateServerView(showCreateServer: .constant(true))
}
