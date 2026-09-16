import SwiftUI

@main
struct TheMovieShowApp: App {
    @State private var appCoordinator = DependencyContainer.makeAppCoordinator()
    @State private var networkMonitor = NetworkMonitor()

    var body: some Scene {
        WindowGroup {
            RootView(coordinator: appCoordinator)
                .environment(networkMonitor)
        }
    }
}
