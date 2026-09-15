import SwiftUI

enum BookmarksRoute: AppRoute {
    case movieDetail(movieId: Int)
}

@MainActor
protocol BookmarksCoordinatorProtocol: CoordinatorProtocol {
    func showMovieDetail(movieId: Int)
}

@Observable
@MainActor
final class BookmarksCoordinator: BookmarksCoordinatorProtocol {
    var path = NavigationPath()

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
                        Text("Movie Detail — id: \(id)")
                            .navigationTitle("Detail")
                    }
                }
        }
    }
}
