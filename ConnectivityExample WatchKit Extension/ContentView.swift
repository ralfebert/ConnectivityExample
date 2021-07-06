// Example project ConnectivityExample
// https://www.ralfebert.de/ios/watchos-watchkit-connectivity-tutorial/
// License: https://choosealicense.com/licenses/cc0-1.0/

import SwiftUI

struct ContentView: View {
    @StateObject var phoneMessaging = PhoneMessaging()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Button("Request Info") {
                    phoneMessaging.requestInfo()
                }
                ForEach(phoneMessaging.messages, id: \.self) { message in
                    Text(message)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
