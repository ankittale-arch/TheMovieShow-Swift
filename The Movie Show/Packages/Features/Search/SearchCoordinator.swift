import SwiftUI

enum SearchRoute: AppRoute {
    case movieDetail(movieId: Int)
}

@MainActor
protocol SearchCoordinatorProtocol: MovieDetailCoordinatorProtocol {}

@Observable
@MainActor
final class SearchCoordinator: SearchCoordinatorProtocol {
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
        path.append(SearchRoute.movieDetail(movieId: movieId))
    }

    func navigateBack() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func navigateToRoot() {
        path.removeLast(path.count)
    }
}

struct SearchCoordinatorView: View {
    @State var coordinator: SearchCoordinator
    @State private var viewModel: SearchViewModel

    init(coordinator: SearchCoordinator) {
        let vm = SearchViewModel(
            coordinator: coordinator,
            movieRepository: coordinator.movieRepository
        )
        _coordinator = State(wrappedValue: coordinator)
        _viewModel = State(wrappedValue: vm)
    }

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            SearchView(viewModel: viewModel)
                .navigationDestination(for: SearchRoute.self) { route in
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
