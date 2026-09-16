import Foundation
import SwiftData

/// Composition root — the only place in the app where concrete types are wired together.
/// All services, repositories, and coordinators are built here via constructor injection.
/// No singleton service locators — every dependency is explicit and testable.
@MainActor
final class DependencyContainer {

    // MARK: - Phase 1: Networking

    static func makeNetworkService() -> NetworkService {
        NetworkService()
    }

    // MARK: - Phase 2: Persistence + Repositories

    static func makeModelContainer() -> ModelContainer {
        (try? PersistenceContainer.make())
            ?? (try! PersistenceContainer.makeInMemory()) // fallback for preview/test
    }

    static func makeMovieRepository(
        network: NetworkServiceProtocol,
        container: ModelContainer
    ) -> MovieRepository {
        MovieRepository(network: network, modelContainer: container)
    }

    static func makeBookmarkRepository(container: ModelContainer) -> BookmarkRepository {
        BookmarkRepository(modelContainer: container)
    }

    static func makeRecentlyViewedRepository(container: ModelContainer) -> RecentlyViewedRepository {
        RecentlyViewedRepository(modelContainer: container)
    }

    // MARK: - Phase 3: Full dependency graph wired into coordinators

    static func makeAppCoordinator() -> AppCoordinator {
        let network = makeNetworkService()
        let container = makeModelContainer()

        let movieRepo = makeMovieRepository(network: network, container: container)
        let bookmarkRepo = makeBookmarkRepository(container: container)
        let recentlyViewedRepo = makeRecentlyViewedRepository(container: container)

        // Every coordinator carries all three repos so any tab can show
        // MovieDetailView with full bookmark + recently-viewed support.
        return AppCoordinator(
            homeCoordinator: HomeCoordinator(
                movieRepository: movieRepo,
                bookmarkRepository: bookmarkRepo,
                recentlyViewedRepository: recentlyViewedRepo
            ),
            searchCoordinator: SearchCoordinator(
                movieRepository: movieRepo,
                bookmarkRepository: bookmarkRepo,
                recentlyViewedRepository: recentlyViewedRepo
            ),
            bookmarksCoordinator: BookmarksCoordinator(
                movieRepository: movieRepo,
                bookmarkRepository: bookmarkRepo,
                recentlyViewedRepository: recentlyViewedRepo
            ),
            recentlyViewedCoordinator: RecentlyViewedCoordinator(
                movieRepository: movieRepo,
                bookmarkRepository: bookmarkRepo,
                recentlyViewedRepository: recentlyViewedRepo
            )
        )
    }
}
