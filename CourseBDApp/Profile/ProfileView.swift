

import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    Color.yellow
                        .frame(height: 200)
                    
                    ZStack(alignment: .topLeading) {
                        Color.black
                            .frame(height: 140)
                        
                        VStack(alignment: .leading) {
                            Image("jason")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100)
                                .clipShape(Circle())
                                .background {
                                    Circle()
                                        .fill(.black)
                                        .padding(-8)
                                }
                            
                            Text("Jason Dubon")
                                .font(.title2)
                                .bold()
                            
                            Text("jasondubon")
                                .font(.callout)
                            
                        }
                        .padding(.leading)
                        .offset(y: -50)
                    }
                    
                    NavigationLink {
                        
                    } label: {
                        HStack {
                            Image(systemName: "person.crop.square.fill")
                                .foregroundStyle(.gray)
                            
                            Text("Account")
                                .foregroundStyle(.white)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.gray)
                        }
                        .padding()
                    }
                    .background(Color(uiColor: .systemGray4))

                    Divider()
                
                    NavigationLink {
                        
                    } label: {
                        HStack {
                            Image(systemName: "pencil")
                                .foregroundStyle(.gray)
                            
                            Text("Profile")
                                .foregroundStyle(.white)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.gray)
                        }
                        .padding()
                    }
                    .background(Color(uiColor: .systemGray4))
                    
                    Divider()
                        .padding(.bottom)
                    
                    Button("Logout") {
                        Task {
                            do {
                                try await AuthService.shared.signOut()
                            } catch {
                                print(error.localizedDescription)
                            }
                        }
                    }
                    .foregroundStyle(.red)
                    .padding()
                }
            }
            .background(Color(.background))
        }
        .preferredColorScheme(.dark)
        
    }
}

#Preview {
    ProfileView()
}
