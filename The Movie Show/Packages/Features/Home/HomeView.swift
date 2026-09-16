import SwiftUI

struct HomeView: View {
    let viewModel: HomeViewModel

    var body: some View {
        ZStack {
            switch viewModel.state {
            case .idle:
                Color.clear
            case .loading:
                LoadingView()
            case .loaded(let movies):
                movieGrid(movies: movies)
            case .empty:
                EmptyStateView(
                    title: "No Movies",
                    message: "Nothing here for this category.",
                    systemImageName: "film"
                )
            case .failed(let error):
                ErrorView(error: error) {
                    Task { await viewModel.loadMovies() }
                }
            }
        }
        .navigationTitle("The Movie Show")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if viewModel.isLoadingMore {
                ToolbarItem(placement: .navigationBarTrailing) {
                    ProgressView()
                }
            }
        }
        .safeAreaInset(edge: .top) {
            filtersBar
        }
        .task {
            await viewModel.loadMovies()
        }
    }

    // MARK: - Filters bar (category + genre rows)

    private var filtersBar: some View {
        VStack(spacing: 0) {
            // Category row
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Spacing.xSmall) {
                    ForEach(MovieCategory.allCases) { category in
                        CategoryChip(
                            category: category,
                            isSelected: viewModel.selectedCategory == category
                        ) {
                            Task { await viewModel.selectCategory(category) }
                        }
                    }
                }
                .padding(.horizontal, Spacing.medium)
                .padding(.vertical, Spacing.xSmall)
            }

            // Genre row — appears once genres have loaded
            if !viewModel.genres.isEmpty {
                Divider()
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: Spacing.xSmall) {
                        GenreChip(name: "All", isSelected: viewModel.selectedGenreId == nil) {
                            Task { await viewModel.selectGenre(nil) }
                        }
                        ForEach(viewModel.genres) { genre in
                            GenreChip(
                                name: genre.name,
                                isSelected: viewModel.selectedGenreId == genre.id
                            ) {
                                Task { await viewModel.selectGenre(genre) }
                            }
                        }
                    }
                    .padding(.horizontal, Spacing.medium)
                    .padding(.vertical, Spacing.xSmall)
                }
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .background(.bar)
        .animation(.easeInOut(duration: 0.2), value: viewModel.genres.isEmpty)
    }

    // MARK: - Movie grid

    private func movieGrid(movies: [Movie]) -> some View {
        ScrollView {
            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: Spacing.small),
                    GridItem(.flexible(), spacing: Spacing.small)
                ],
                spacing: Spacing.medium
            ) {
                ForEach(movies) { movie in
                    MovieCardView(movie: movie)
                        .contentShape(Rectangle())
                        .onTapGesture { viewModel.didTapMovie(movie) }
                        .onAppear { viewModel.loadMoreIfNeeded(after: movie) }
                }
            }
            .padding(Spacing.medium)
        }
    }
}

// MARK: - Category chip

private struct CategoryChip: View {
    let category: MovieCategory
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Label(category.displayName, systemImage: category.systemImageName)
                .font(.subheadline.weight(isSelected ? .semibold : .regular))
                .padding(.horizontal, Spacing.medium)
                .padding(.vertical, Spacing.xSmall)
                .background(isSelected ? Color.accentColor : Color.secondary.opacity(0.12))
                .foregroundStyle(isSelected ? Color.white : Color.primary)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.18), value: isSelected)
    }
}

// MARK: - Genre chip

private struct GenreChip: View {
    let name: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(name)
                .font(.subheadline.weight(isSelected ? .semibold : .regular))
                .padding(.horizontal, Spacing.medium)
                .padding(.vertical, Spacing.xSmall)
                .background(isSelected ? Color.accentColor : Color.secondary.opacity(0.12))
                .foregroundStyle(isSelected ? Color.white : Color.primary)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.18), value: isSelected)
    }
}

#Preview {
    NavigationStack {
        HomeView(viewModel: HomeViewModel(
            coordinator: PreviewHomeCoordinator(),
            movieRepository: PreviewMovieRepository()
        ))
    }
}
