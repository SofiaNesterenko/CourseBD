

import SwiftUI

struct SignInView: View {
    @Environment(\.authViewModel) var viewModel
    
    var body: some View {
        @Bindable var viewModel = viewModel
        VStack {
            Text("Welcome back!")
                .font(.title)
                .bold()
            
            Text("We're so excited to see you again!")
                .foregroundStyle(.gray)
                .padding(.bottom)
            
            VStack(alignment: .leading) {
                DiscordTextField(header: "Account Information", placeHolder: "Email Address", text: $viewModel.signInEmail)
                
                SecureField("Password", text: $viewModel.signInPassword)
                    .padding()
                    .background(.ultraThinMaterial)
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Button {
                viewModel.logIn()
            } label: {
                Text("Log In")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.white)
                    .background(Color(.discord))
            }

        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .preferredColorScheme(.dark)
        .background(Color(.background))
    }
}

#Preview {
    SignInView()
}
