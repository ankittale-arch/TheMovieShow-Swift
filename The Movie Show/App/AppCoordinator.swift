import SwiftUI

/// The four primary tabs of the app.
enum AppTab: String, CaseIterable, Identifiable {
    case home
    case search
    case bookmarks
    case recentlyViewed

    var id: String { rawValue }

    var title: String {
        switch self {
        case .home:           return "Home"
        case .search:         return "Search"
        case .bookmarks:      return "Bookmarks"
        case .recentlyViewed: return "Recent"
        }
    }

    var systemImageName: String {
        switch self {
        case .home:           return "house.fill"
        case .search:         return "magnifyingglass"
        case .bookmarks:      return "bookmark.fill"
        case .recentlyViewed: return "clock.fill"
        }
    }
}

/// Root coordinator — owns the tab selection state and child coordinators.
/// The `DependencyContainer` creates this with fully-initialised children so
/// each tab's coordinator starts with its full dependency graph in place.
@Observable
@MainActor
final class AppCoordinator {
    var selectedTab: AppTab = .home

    let homeCoordinator: HomeCoordinator
    let searchCoordinator: SearchCoordinator
    let bookmarksCoordinator: BookmarksCoordinator
    let recentlyViewedCoordinator: RecentlyViewedCoordinator

    init(
        homeCoordinator: HomeCoordinator,
        searchCoordinator: SearchCoordinator,
        bookmarksCoordinator: BookmarksCoordinator,
        recentlyViewedCoordinator: RecentlyViewedCoordinator
    ) {
        self.homeCoordinator = homeCoordinator
        self.searchCoordinator = searchCoordinator
        self.bookmarksCoordinator = bookmarksCoordinator
        self.recentlyViewedCoordinator = recentlyViewedCoordinator
    }

    func selectTab(_ tab: AppTab) {
        selectedTab = tab
    }
}
