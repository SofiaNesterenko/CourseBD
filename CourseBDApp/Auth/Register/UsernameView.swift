

import SwiftUI

struct UsernameView: View {
    @Environment(\.authViewModel) var viewModel
    
    var body: some View {
        @Bindable var viewModel = viewModel
        VStack {
            Text("Next, create an account")
                .font(.title)
                .bold()
                .padding(.bottom, 24)
            
            DiscordTextField(header: "Username", placeHolder: "", text: $viewModel.registerUsername)
            
            Text("Password")
                .font(.footnote)
                .textCase(.uppercase)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            SecureField("", text: $viewModel.registerPassword)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .padding()
                .background(.ultraThinMaterial)
            
            NavigationLink {
                AgeView()
                    .environment(viewModel)
            } label: {
                Text("Next")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.white)
                    .background(.discord)
            }
            .disabled(viewModel.registerPassword.isEmpty || viewModel.registerUsername.isEmpty)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color(.background))
        .preferredColorScheme(.dark)
    }
}

#Preview {
    UsernameView()
}
