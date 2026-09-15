import SwiftUI

enum SearchRoute: AppRoute {
    case movieDetail(movieId: Int)
}

@MainActor
protocol SearchCoordinatorProtocol: CoordinatorProtocol {
    func showMovieDetail(movieId: Int)
}

@Observable
@MainActor
final class SearchCoordinator: SearchCoordinatorProtocol {
    var path = NavigationPath()

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

    init(coordinator: SearchCoordinator) {
        _coordinator = State(wrappedValue: coordinator)
    }

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            SearchView(coordinator: coordinator)
                .navigationDestination(for: SearchRoute.self) { route in
                    switch route {
                    case .movieDetail(let id):
                        Text("Movie Detail — id: \(id)")
                            .navigationTitle("Detail")
                    }
                }
        }
    }
}
