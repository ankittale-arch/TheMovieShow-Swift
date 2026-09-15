import SwiftUI

enum RecentlyViewedRoute: AppRoute {
    case movieDetail(movieId: Int)
}

@MainActor
protocol RecentlyViewedCoordinatorProtocol: CoordinatorProtocol {
    func showMovieDetail(movieId: Int)
}

@Observable
@MainActor
final class RecentlyViewedCoordinator: RecentlyViewedCoordinatorProtocol {
    var path = NavigationPath()

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
                        Text("Movie Detail — id: \(id)")
                            .navigationTitle("Detail")
                    }
                }
        }
    }
}
