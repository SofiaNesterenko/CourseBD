

import SwiftUI

struct AuthView: View {
    @State var viewModel = AuthViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                Image("discord2")
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width, height: 300)
                    .clipped()
                
                Spacer()
                
                Text("Welcome to Discord")
                    .font(.title)
                    .bold()
                
                Text("Join over 100 million people who use Discord to talk with communities and friends.")
                    .padding()
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                NavigationLink {
                    EmailView()
                        .environment(viewModel)
                } label: {
                    Text("Register")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.white)
                        .background(Color(.discord))
                        .padding(.horizontal)
                }
                
                NavigationLink {
                    SignInView()
                        .environment(viewModel)
                } label: {
                    Text("Log In")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.white)
                        .background(Color(.gray))
                        .padding(.horizontal)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .background(Color(.background))
            .preferredColorScheme(.dark)
        }
    }
}

#Preview {
    AuthView()
}
