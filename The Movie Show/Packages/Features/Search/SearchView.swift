import SwiftUI

struct SearchView: View {
    @Bindable var viewModel: SearchViewModel

    var body: some View {
        ZStack {
            switch viewModel.state {
            case .idle:
                idlePrompt
            case .loading:
                LoadingView()
            case .loaded(let movies):
                resultsGrid(movies: movies)
            case .empty:
                EmptyStateView(
                    title: "No Results",
                    message: "No movies found for \"\(viewModel.searchText)\".",
                    systemImageName: "magnifyingglass"
                )
            case .failed(let error):
                ErrorView(error: error)
            }
        }
        .navigationTitle("Search")
        .navigationBarTitleDisplayMode(.large)
        .searchable(
            text: $viewModel.searchText,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "Movies, genres, actors…"
        )
        .onChange(of: viewModel.searchText) {
            viewModel.onSearchTextChanged()
        }
    }

    // MARK: - Idle prompt

    private var idlePrompt: some View {
        VStack(spacing: Spacing.medium) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 52))
                .foregroundStyle(.secondary.opacity(0.35))
            Text("Search for movies")
                .font(.headline)
                .foregroundStyle(.secondary)
            Text("Find by title, genre, or keyword")
                .font(.subheadline)
                .foregroundStyle(.tertiary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Results grid

    private func resultsGrid(movies: [Movie]) -> some View {
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

            if viewModel.isLoadingMore {
                ProgressView()
                    .padding(.bottom, Spacing.large)
            }
        }
    }
}

#Preview {
    NavigationStack {
        SearchView(viewModel: SearchViewModel(
            coordinator: PreviewSearchCoordinator(),
            movieRepository: PreviewMovieRepository()
        ))
    }
}
