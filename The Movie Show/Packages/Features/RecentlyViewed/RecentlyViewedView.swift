import SwiftUI

struct RecentlyViewedView: View {
    let viewModel: RecentlyViewedViewModel
    @State private var showClearConfirmation = false

    var body: some View {
        Group {
            switch viewModel.state {
            case .idle, .loading:
                LoadingView()
            case .loaded(let movies):
                historyList(movies: movies)
            case .empty:
                EmptyStateView(
                    title: "Nothing Yet",
                    message: "Movies you open will appear here automatically.",
                    systemImageName: "clock"
                )
            case .failed(let error):
                ErrorView(error: error) {
                    Task { await viewModel.loadHistory() }
                }
            }
        }
        .navigationTitle("Recently Viewed")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            if case .loaded = viewModel.state {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Clear All", role: .destructive) {
                        showClearConfirmation = true
                    }
                    .disabled(viewModel.isClearing)
                }
            }
        }
        .alert("Clear History", isPresented: $showClearConfirmation) {
            Button("Clear All", role: .destructive) {
                Task { await viewModel.clearAll() }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This will remove all recently viewed movies. This action cannot be undone.")
        }
        .task { await viewModel.loadHistory() }
    }

    private func historyList(movies: [Movie]) -> some View {
        List {
            ForEach(movies) { movie in
                RecentlyViewedRow(movie: movie)
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
        }
        .listStyle(.plain)
        .refreshable { await viewModel.loadHistory() }
    }
}

// MARK: - Recently Viewed Row

private struct RecentlyViewedRow: View {
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
        RecentlyViewedView(viewModel: RecentlyViewedViewModel(
            coordinator: PreviewRecentlyViewedCoordinator(),
            recentlyViewedRepository: PreviewRecentlyViewedRepository()
        ))
    }
}
