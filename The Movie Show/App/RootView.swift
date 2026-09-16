import SwiftUI

struct RootView: View {
    @State private var coordinator: AppCoordinator
    @Environment(NetworkMonitor.self) private var networkMonitor

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
        .safeAreaInset(edge: .top, spacing: 0) {
            if !networkMonitor.isConnected {
                OfflineBanner()
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.3), value: networkMonitor.isConnected)
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

// MARK: - Offline Banner

private struct OfflineBanner: View {
    var body: some View {
        HStack(spacing: Spacing.xSmall) {
            Image(systemName: "wifi.slash")
                .font(.caption.bold())
            Text("You're offline — showing cached content")
                .font(.caption.bold())
            Spacer()
        }
        .foregroundStyle(.white)
        .padding(.vertical, Spacing.xSmall)
        .padding(.horizontal, Spacing.medium)
        .background(Color.App.warning.opacity(0.92))
    }
}

#Preview {
    RootView(coordinator: DependencyContainer.makeAppCoordinator())
        .environment(NetworkMonitor())
}
