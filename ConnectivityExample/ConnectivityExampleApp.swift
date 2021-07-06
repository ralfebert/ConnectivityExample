// Example project ConnectivityExample
// https://www.ralfebert.de/ios/watchos-watchkit-connectivity-tutorial/
// License: https://choosealicense.com/licenses/cc0-1.0/

import SwiftUI

@main
struct ConnectivityExampleApp: App {
    @StateObject var connectivityRequestHandler = ConnectivityRequestHandler()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
