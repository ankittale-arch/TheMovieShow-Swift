import SwiftUI

struct BookmarksView: View {
    let viewModel: BookmarksViewModel

    var body: some View {
        Group {
            switch viewModel.state {
            case .idle, .loading:
                LoadingView()
            case .loaded(let movies):
                bookmarkList(movies: movies)
            case .empty:
                EmptyStateView(
                    title: "No Bookmarks",
                    message: "Tap the bookmark icon on any movie to save it here.",
                    systemImageName: "bookmark"
                )
            case .failed(let error):
                ErrorView(error: error) {
                    Task { await viewModel.loadBookmarks() }
                }
            }
        }
        .navigationTitle("Bookmarks")
        .navigationBarTitleDisplayMode(.large)
        .task { await viewModel.loadBookmarks() }
    }

    private func bookmarkList(movies: [Movie]) -> some View {
        List {
            ForEach(movies) { movie in
                BookmarkRow(movie: movie)
                    .contentShape(Rectangle())
                    .onTapGesture { viewModel.didTapMovie(movie) }
                    .listRowInsets(EdgeInsets(
                        top: Spacing.xSmall,
                        leading: Spacing.medium,
                        bottom: Spacing.xSmall,
                        trailing: Spacing.medium
                    ))
                    .listRowSeparator(.hidden)
            }
            .onDelete { offsets in viewModel.removeBookmark(at: offsets) }
        }
        .listStyle(.plain)
    }
}

// MARK: - Bookmark Row

private struct BookmarkRow: View {
    let movie: Movie

    var body: some View {
        HStack(spacing: Spacing.medium) {
            AsyncImageView(url: movie.posterURL, contentMode: .fill)
                .frame(width: 58, height: 87)
                .clipShape(RoundedRectangle(cornerRadius: CornerRadius.medium))
                .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)

            VStack(alignment: .leading, spacing: Spacing.xxSmall) {
                Text(movie.title)
                    .font(.subheadline.weight(.semibold))
                    .lineLimit(2)
                    .foregroundStyle(.primary)

                if let date = movie.releaseDate {
                    Text(date, format: .dateTime.year())
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                HStack(spacing: Spacing.xxxSmall) {
                    Image(systemName: "star.fill")
                        .font(.caption2)
                        .foregroundStyle(Color.App.ratingGold)
                    Text(String(format: "%.1f", movie.rating))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                if !movie.overview.isEmpty {
                    Text(movie.overview)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
            }

            Spacer(minLength: 0)

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, Spacing.xxSmall)
    }
}

#Preview {
    NavigationStack {
        BookmarksView(viewModel: BookmarksViewModel(
            coordinator: PreviewBookmarksCoordinator(),
            bookmarkRepository: PreviewBookmarkRepository()
        ))
    }
}
