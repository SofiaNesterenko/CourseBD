

import SwiftUI

struct NoServerView: View {
    @Binding var showCreateServer: Bool
    
    var body: some View {
        VStack {
            Text("Servers")
                .font(.title2)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            
            Image("discord2")
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width - 175, height: 250, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .clipShape(RoundedRectangle(cornerRadius: 5))
            
            Text("No servers yet!")
                .font(.title3)
                .bold()
                .padding()
            
            Text("When you join or create a server it will show up here.")
                .multilineTextAlignment(.center)
            
            
            Button {
                showCreateServer = true
            } label: {
                Text("Create a Server")
                    .bold()
                    .frame(height: 40)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .background(
                        .discord
                    )
            }

            
            Spacer(minLength: 160)
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .frame(width: 250)
        .ignoresSafeArea()
        .padding()
        .preferredColorScheme(.dark)
        .background(Color(.background))
    }
}

#Preview {
    NoServerView(showCreateServer: .constant(false))
}
