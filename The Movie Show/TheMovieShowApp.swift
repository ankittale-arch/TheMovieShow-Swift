import SwiftUI

@main
struct TheMovieShowApp: App {
    /// AppCoordinator is created once at launch by the composition root
    /// and held for the lifetime of the app.
    @State private var appCoordinator = DependencyContainer.makeAppCoordinator()

    var body: some Scene {
        WindowGroup {
            RootView(coordinator: appCoordinator)
        }
    }
}
