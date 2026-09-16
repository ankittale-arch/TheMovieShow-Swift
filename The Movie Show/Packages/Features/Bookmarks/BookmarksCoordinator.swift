import SwiftUI

enum BookmarksRoute: AppRoute {
    case movieDetail(movieId: Int)
}

@MainActor
protocol BookmarksCoordinatorProtocol: MovieDetailCoordinatorProtocol {}

@Observable
@MainActor
final class BookmarksCoordinator: BookmarksCoordinatorProtocol {
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
        path.append(BookmarksRoute.movieDetail(movieId: movieId))
    }

    func navigateBack() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func navigateToRoot() {
        path.removeLast(path.count)
    }
}

struct BookmarksCoordinatorView: View {
    @State var coordinator: BookmarksCoordinator

    init(coordinator: BookmarksCoordinator) {
        _coordinator = State(wrappedValue: coordinator)
    }

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            BookmarksView(coordinator: coordinator)
                .navigationDestination(for: BookmarksRoute.self) { route in
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
