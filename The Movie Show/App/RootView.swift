import SwiftUI

/// The root view of the application — renders the tab bar and delegates
/// each tab's NavigationStack to its own coordinator view.
struct RootView: View {
    @State private var coordinator: AppCoordinator

    init(coordinator: AppCoordinator) {
        _coordinator = State(wrappedValue: coordinator)
    }

    var body: some View {
        TabView(selection: $coordinator.selectedTab) {
            ForEach(AppTab.allCases) { tab in
                tabContent(for: tab)
                    .tabItem {
                        Label(tab.title, systemImage: tab.systemImageName)
                    }
                    .tag(tab)
            }
        }
    }

    @ViewBuilder
    private func tabContent(for tab: AppTab) -> some View {
        switch tab {
        case .home:
            HomeCoordinatorView(coordinator: coordinator.homeCoordinator)
        case .search:
            SearchCoordinatorView(coordinator: coordinator.searchCoordinator)
        case .bookmarks:
            BookmarksCoordinatorView(coordinator: coordinator.bookmarksCoordinator)
        case .recentlyViewed:
            RecentlyViewedCoordinatorView(coordinator: coordinator.recentlyViewedCoordinator)
        }
    }
}

#Preview {
    RootView(coordinator: DependencyContainer.makeAppCoordinator())
}
