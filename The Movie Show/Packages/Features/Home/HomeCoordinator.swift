import SwiftUI

enum HomeRoute: AppRoute {
    case movieDetail(movieId: Int)
    case movieList(category: MovieCategory)
    case genreMovies(genreId: Int, genreName: String)
}

@MainActor
protocol HomeCoordinatorProtocol: MovieDetailCoordinatorProtocol {
    func showMovieList(category: MovieCategory)
    func showGenreMovies(genreId: Int, genreName: String)
}

@Observable
@MainActor
final class HomeCoordinator: HomeCoordinatorProtocol {
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
        path.append(HomeRoute.movieDetail(movieId: movieId))
    }

    func showMovieList(category: MovieCategory) {
        path.append(HomeRoute.movieList(category: category))
    }

    func showGenreMovies(genreId: Int, genreName: String) {
        path.append(HomeRoute.genreMovies(genreId: genreId, genreName: genreName))
    }

    func navigateBack() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func navigateToRoot() {
        path.removeLast(path.count)
    }
}

struct HomeCoordinatorView: View {
    @State var coordinator: HomeCoordinator
    @State private var viewModel: HomeViewModel

    init(coordinator: HomeCoordinator) {
        let vm = HomeViewModel(
            coordinator: coordinator,
            movieRepository: coordinator.movieRepository
        )
        _coordinator = State(wrappedValue: coordinator)
        _viewModel = State(wrappedValue: vm)
    }

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            HomeView(viewModel: viewModel)
                .navigationDestination(for: HomeRoute.self) { route in
                    switch route {
                    case .movieDetail(let id):
                        MovieDetailView(viewModel: MovieDetailViewModel(
                            movieId: id,
                            coordinator: coordinator,
                            movieRepository: coordinator.movieRepository,
                            bookmarkRepository: coordinator.bookmarkRepository,
                            recentlyViewedRepository: coordinator.recentlyViewedRepository
                        ))

                    case .movieList(let category):
                        MovieListView(viewModel: MovieListViewModel(
                            source: .category(category),
                            coordinator: coordinator,
                            movieRepository: coordinator.movieRepository
                        ))

                    case .genreMovies(let id, let name):
                        MovieListView(viewModel: MovieListViewModel(
                            source: .genre(id: id, name: name),
                            coordinator: coordinator,
                            movieRepository: coordinator.movieRepository
                        ))
                    }
                }
        }
    }
}
