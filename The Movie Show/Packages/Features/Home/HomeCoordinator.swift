import SwiftUI

/// Routes owned by the Home feature flow.
enum HomeRoute: AppRoute {
    case movieDetail(movieId: Int)
    case movieList(category: String)
}

/// Owns the NavigationPath for the Home tab and builds destination screens.
/// Child coordinators / ViewModels call this via `HomeCoordinatorProtocol`
/// so they never import concrete coordinator types.
@MainActor
protocol HomeCoordinatorProtocol: CoordinatorProtocol {
    func showMovieDetail(movieId: Int)
    func showMovieList(category: String)
}

@Observable
@MainActor
final class HomeCoordinator: HomeCoordinatorProtocol {
    var path = NavigationPath()

    func showMovieDetail(movieId: Int) {
        path.append(HomeRoute.movieDetail(movieId: movieId))
    }

    func showMovieList(category: String) {
        path.append(HomeRoute.movieList(category: category))
    }

    func navigateBack() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func navigateToRoot() {
        path.removeLast(path.count)
    }
}

/// Hosts the NavigationStack for the Home tab and wires route destinations.
struct HomeCoordinatorView: View {
    @State var coordinator: HomeCoordinator

    init(coordinator: HomeCoordinator) {
        _coordinator = State(wrappedValue: coordinator)
    }

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            HomeView(coordinator: coordinator)
                .navigationDestination(for: HomeRoute.self) { route in
                    switch route {
                    case .movieDetail(let id):
                        // Wired in Phase 5
                        Text("Movie Detail — id: \(id)")
                            .navigationTitle("Detail")
                    case .movieList(let category):
                        // Wired in Phase 6
                        Text("Movie List — \(category)")
                            .navigationTitle(category)
                    }
                }
        }
    }
}
