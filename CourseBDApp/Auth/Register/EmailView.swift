

import SwiftUI

struct EmailView: View {
    @Environment(\.authViewModel) var viewModel
    
    var body: some View {
        @Bindable var viewModel = viewModel
        VStack {
            Text("Enter email")
                .font(.title)
                .bold()
            
            DiscordTextField(header: "Email", placeHolder: "Email", text: $viewModel.registerEmail)
            
            NavigationLink {
                NameView()
                    .environment(viewModel)
            } label: {
                Text("Next")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.white)
                    .background(.discord)
            }
            .disabled(viewModel.registerEmail.isEmpty)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color(.background))
        .preferredColorScheme(.dark)
    }
}

#Preview {
    NavigationStack {
        EmailView()
    }
}
