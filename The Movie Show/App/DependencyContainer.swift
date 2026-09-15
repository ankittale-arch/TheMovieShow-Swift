import Foundation

/// Composition root — the only place in the app where concrete types are wired together.
///
/// All services, repositories, and coordinators are built here and injected via
/// constructor injection.  No singleton service locators — every dependency is
/// explicit and testable.
///
/// Later phases will extend this with:
///   - `TMDBAPIClient` (Phase 1)
///   - `SwiftData ModelContainer` (Phase 2)
///   - Repository implementations (Phase 2)
///   - Feature ViewModels (Phases 4–7)
///   - BGTask registration (Phase 8)
@MainActor
final class DependencyContainer {

    static func makeAppCoordinator() -> AppCoordinator {
        AppCoordinator(
            homeCoordinator: HomeCoordinator(),
            searchCoordinator: SearchCoordinator(),
            bookmarksCoordinator: BookmarksCoordinator(),
            recentlyViewedCoordinator: RecentlyViewedCoordinator()
        )
    }
}
