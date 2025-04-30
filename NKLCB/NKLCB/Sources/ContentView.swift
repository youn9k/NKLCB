import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(.nklcbLogo)
                .resizable()
                .scaledToFit()
                .imageScale(.medium)
            
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
