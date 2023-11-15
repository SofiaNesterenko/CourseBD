

import SwiftUI
import SDWebImageSwiftUI

struct MessageView: View {
    @State var message: Message
    
    var body: some View {
        HStack(alignment: .top) {
            if message.imageURL == "" {
                Text(message.username.prefix(1))
                    .font(.largeTitle)
                    .frame(width: 28)
                    .padding()
                    .background {
                        Circle()
                            .fill(Color(.discord))
                    }
            } else {
                WebImage(url: URL(string: message.imageURL))
                    .resizable()
                    .scaledToFill()
                    .frame(width: 48, height: 48)
                    .clipShape(Circle())
            }
            
            VStack(alignment: .leading) {
                HStack {
                    Text(message.username)
                        .bold()
                    
                    Text(message.createdAt.formatted())
                        .font(.caption)
                }
                
                Text(message.text)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
        .padding(.bottom, 8)
    }
}

#Preview {
    MessageView(message: Message(id: .init(), createdAt: .now, username: "asjon", imageURL: "", text: "hola", channelUid: .init(), serverId: 5))
}
