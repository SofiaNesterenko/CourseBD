

import SwiftUI

struct DiscordTextField: View {
    var header: String
    var placeHolder: String
    @Binding var text: String
    
    var body: some View {
        VStack {
            Text(header)
                .font(.footnote)
                .textCase(.uppercase)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            TextField(placeHolder, text: $text)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .padding()
                .background(.ultraThinMaterial)
        }
    }
}

#Preview {
    DiscordTextField(header: "Account info", placeHolder: "Email", text: .constant(""))
}
