import SwiftUI

enum RecentlyViewedRoute: AppRoute {
    case movieDetail(movieId: Int)
}

@MainActor
protocol RecentlyViewedCoordinatorProtocol: MovieDetailCoordinatorProtocol {}

@Observable
@MainActor
final class RecentlyViewedCoordinator: RecentlyViewedCoordinatorProtocol {
    var path = NavigationPath()

    let movieRepository: any MovieRepositoryProtocol
    let bookmarkRepository: any BookmarkRepositoryProtocol
    let recentlyViewedRepository: any RecentlyViewedRepositoryProtocol

    init(
        movieRepository: some MovieRepositoryProtocol,
        bookmarkRepository: some BookmarkRepositoryProtocol,
        recentlyViewedRepository: some RecentlyViewedRepositoryProtocol
    ) {
        self.movieRepository = movieRepository
        self.bookmarkRepository = bookmarkRepository
        self.recentlyViewedRepository = recentlyViewedRepository
    }

    func showMovieDetail(movieId: Int) {
        path.append(RecentlyViewedRoute.movieDetail(movieId: movieId))
    }

    func navigateBack() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func navigateToRoot() {
        path.removeLast(path.count)
    }
}

struct RecentlyViewedCoordinatorView: View {
    @State var coordinator: RecentlyViewedCoordinator

    init(coordinator: RecentlyViewedCoordinator) {
        _coordinator = State(wrappedValue: coordinator)
    }

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            RecentlyViewedView(coordinator: coordinator)
                .navigationDestination(for: RecentlyViewedRoute.self) { route in
                    switch route {
                    case .movieDetail(let id):
                        MovieDetailView(viewModel: MovieDetailViewModel(
                            movieId: id,
                            coordinator: coordinator,
                            movieRepository: coordinator.movieRepository,
                            bookmarkRepository: coordinator.bookmarkRepository,
                            recentlyViewedRepository: coordinator.recentlyViewedRepository
                        ))
                    }
                }
        }
    }
}
