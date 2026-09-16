import SwiftUI

/// Bookmarks screen — placeholder until Phase 7.
struct BookmarksView: View {
    let coordinator: BookmarksCoordinator

    var body: some View {
        EmptyStateView(
            title: "Bookmarks",
            message: "Saved movies coming in Phase 7.",
            systemImageName: "bookmark.fill"
        )
        .navigationTitle("Bookmarks")
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    NavigationStack {
        BookmarksView(coordinator: BookmarksCoordinator(
            movieRepository: PreviewMovieRepository(),
            bookmarkRepository: PreviewBookmarkRepository(),
            recentlyViewedRepository: PreviewRecentlyViewedRepository()
        ))
    }
}
